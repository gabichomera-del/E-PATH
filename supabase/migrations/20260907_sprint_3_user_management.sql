-- Sprint 3: canonical identity, class enrollment, and teacher support model.
create extension if not exists pgcrypto;
do $$ begin create type public.app_role as enum ('student', 'teacher', 'admin'); exception when duplicate_object then null; end $$;
do $$ begin create type public.reset_status as enum ('pending', 'completed', 'expired'); exception when duplicate_object then null; end $$;

create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null check (length(trim(first_name)) > 0),
  last_name text not null check (length(trim(last_name)) > 0),
  email text not null unique,
  role public.app_role not null,
  created_at timestamptz not null default now()
);
create table if not exists public.students (
  id uuid primary key default gen_random_uuid(), user_id uuid not null unique references public.users(id) on delete cascade,
  grade text not null, section text not null, student_code text not null unique,
  created_at timestamptz not null default now()
);
create table if not exists public.teachers (
  id uuid primary key default gen_random_uuid(), user_id uuid not null unique references public.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
create table if not exists public.classes (
  id uuid primary key default gen_random_uuid(), teacher_id uuid not null references public.teachers(id) on delete cascade,
  name text not null, grade text not null, section text not null, academic_year integer not null check (academic_year between 2020 and 2100),
  class_code text not null unique check (class_code ~ '^EPATH-[A-Z0-9]{5}$'), created_at timestamptz not null default now()
);
create table if not exists public.class_members (
  id uuid primary key default gen_random_uuid(), class_id uuid not null references public.classes(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade, joined_at timestamptz not null default now(),
  unique (class_id, student_id)
);
create table if not exists public.password_reset_requests (
  id uuid primary key default gen_random_uuid(), student_id uuid not null references public.students(id) on delete cascade,
  teacher_id uuid not null references public.teachers(id) on delete cascade,
  temporary_password text not null, created_at timestamptz not null default now(), status public.reset_status not null default 'pending'
);
comment on column public.password_reset_requests.temporary_password is 'Stores only a salted, non-reversible hash. The temporary password is returned once by the server.';

create index if not exists classes_teacher_idx_v2 on public.classes(teacher_id);
create index if not exists classes_code_idx on public.classes(class_code);
create index if not exists class_members_student_idx_v2 on public.class_members(student_id);
create index if not exists reset_requests_teacher_idx on public.password_reset_requests(teacher_id, created_at desc);

create or replace function public.validate_class_code(requested_code text) returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.classes where class_code = upper(trim(requested_code)));
$$;
grant execute on function public.validate_class_code(text) to anon, authenticated;

create or replace function public.handle_epath_user() returns trigger language plpgsql security definer set search_path = public as $$
declare requested_role public.app_role; requested_class uuid; new_student uuid;
begin
  requested_role := (new.raw_user_meta_data->>'role')::public.app_role;
  if requested_role = 'student' and split_part(lower(new.email), '@', 2) <> 'alumnos.innovaschools.edu.pe' then raise exception 'Invalid student email domain'; end if;
  if requested_role = 'teacher' and split_part(lower(new.email), '@', 2) <> 'innovaschools.edu.pe' then raise exception 'Invalid teacher email domain'; end if;
  if requested_role = 'admin' then raise exception 'Admin accounts cannot be self-registered'; end if;
  insert into public.users(id, first_name, last_name, email, role) values (new.id, trim(new.raw_user_meta_data->>'first_name'), trim(new.raw_user_meta_data->>'last_name'), lower(new.email), requested_role);
  if requested_role = 'teacher' then insert into public.teachers(user_id) values (new.id);
  else
    select id into requested_class from public.classes where class_code = upper(trim(new.raw_user_meta_data->>'class_code'));
    if requested_class is null then raise exception 'Invalid class code'; end if;
    insert into public.students(user_id, grade, section, student_code) values (new.id, new.raw_user_meta_data->>'grade', new.raw_user_meta_data->>'section', 'STU-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 10))) returning id into new_student;
    insert into public.class_members(class_id, student_id) values (requested_class, new_student);
  end if;
  return new;
end; $$;
drop trigger if exists on_epath_user_created on auth.users;
create trigger on_epath_user_created after insert on auth.users for each row execute procedure public.handle_epath_user();

create or replace function public.current_teacher_id() returns uuid language sql stable security definer set search_path = public as $$ select id from public.teachers where user_id = auth.uid() $$;
create or replace function public.current_student_id() returns uuid language sql stable security definer set search_path = public as $$ select id from public.students where user_id = auth.uid() $$;

alter table public.users enable row level security; alter table public.students enable row level security; alter table public.teachers enable row level security;
alter table public.classes enable row level security; alter table public.class_members enable row level security; alter table public.password_reset_requests enable row level security;

create policy "users read own account" on public.users for select using (id = auth.uid());
create policy "teachers read enrolled users" on public.users for select using (exists (select 1 from public.students s join public.class_members cm on cm.student_id=s.id join public.classes c on c.id=cm.class_id where s.user_id=users.id and c.teacher_id=public.current_teacher_id()));
create policy "students read own profile" on public.students for select using (user_id = auth.uid());
create policy "teachers read enrolled students" on public.students for select using (exists (select 1 from public.class_members cm join public.classes c on c.id=cm.class_id where cm.student_id=students.id and c.teacher_id=public.current_teacher_id()));
create policy "teachers read own profile" on public.teachers for select using (user_id = auth.uid());
create policy "teachers create classes" on public.classes for insert with check (teacher_id = public.current_teacher_id());
create policy "teachers manage own classes" on public.classes for all using (teacher_id = public.current_teacher_id()) with check (teacher_id = public.current_teacher_id());
create policy "students read assigned class" on public.classes for select using (exists (select 1 from public.class_members cm where cm.class_id=classes.id and cm.student_id=public.current_student_id()));
create policy "students read own membership" on public.class_members for select using (student_id = public.current_student_id());
create policy "teachers read own class members" on public.class_members for select using (exists (select 1 from public.classes c where c.id=class_members.class_id and c.teacher_id=public.current_teacher_id()));
create policy "teachers read reset audit" on public.password_reset_requests for select using (teacher_id = public.current_teacher_id());

-- Move learning ownership from the legacy auth-id profile to the canonical student entity.
alter table if exists public.student_mission_progress drop constraint if exists student_mission_progress_student_id_fkey;
alter table if exists public.student_mission_progress add constraint student_mission_progress_student_id_fkey foreign key (student_id) references public.students(id) on delete cascade;
alter table if exists public.student_attempts drop constraint if exists student_attempts_student_id_fkey;
alter table if exists public.student_attempts add constraint student_attempts_student_id_fkey foreign key (student_id) references public.students(id) on delete cascade;
drop policy if exists "students read own mission progress" on public.student_mission_progress;
drop policy if exists "students create own mission progress" on public.student_mission_progress;
drop policy if exists "students update own mission progress" on public.student_mission_progress;
drop policy if exists "students read own attempts" on public.student_attempts;
drop policy if exists "students create own attempts" on public.student_attempts;
drop policy if exists "teachers read class progress" on public.student_mission_progress;
drop policy if exists "teachers read class attempts" on public.student_attempts;
create policy "students read own mission progress" on public.student_mission_progress for select using (student_id = public.current_student_id());
create policy "students create own mission progress" on public.student_mission_progress for insert with check (student_id = public.current_student_id());
create policy "students update own mission progress" on public.student_mission_progress for update using (student_id = public.current_student_id()) with check (student_id = public.current_student_id());
create policy "students read own attempts" on public.student_attempts for select using (student_id = public.current_student_id());
create policy "students create own attempts" on public.student_attempts for insert with check (student_id = public.current_student_id());
create policy "teachers read class progress" on public.student_mission_progress for select using (exists (select 1 from public.class_members cm join public.classes c on c.id=cm.class_id where cm.student_id=student_mission_progress.student_id and c.teacher_id=public.current_teacher_id()));
create policy "teachers read class attempts" on public.student_attempts for select using (exists (select 1 from public.class_members cm join public.classes c on c.id=cm.class_id where cm.student_id=student_attempts.student_id and c.teacher_id=public.current_teacher_id()));
