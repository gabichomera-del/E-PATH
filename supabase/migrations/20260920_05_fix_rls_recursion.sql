-- Break circular RLS evaluation across users, students, classes, and
-- class_members. This migration changes policies only; it does not alter data.
begin;

create or replace function public.current_teacher_owns_class(target_class_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.classes c
    where c.id = target_class_id
      and c.teacher_id = public.current_teacher_id()
  );
$$;

create or replace function public.current_student_belongs_to_class(target_class_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.class_members cm
    where cm.class_id = target_class_id
      and cm.student_id = public.current_student_id()
  );
$$;

create or replace function public.current_teacher_has_student(target_student_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.class_members cm
    join public.classes c on c.id = cm.class_id
    where cm.student_id = target_student_id
      and c.teacher_id = public.current_teacher_id()
  );
$$;

create or replace function public.current_teacher_can_read_user(target_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.students s
    join public.class_members cm on cm.student_id = s.id
    join public.classes c on c.id = cm.class_id
    where s.user_id = target_user_id
      and c.teacher_id = public.current_teacher_id()
  );
$$;

revoke all on function public.current_teacher_owns_class(uuid) from public, anon;
revoke all on function public.current_student_belongs_to_class(uuid) from public, anon;
revoke all on function public.current_teacher_has_student(uuid) from public, anon;
revoke all on function public.current_teacher_can_read_user(uuid) from public, anon;
grant execute on function public.current_teacher_owns_class(uuid) to authenticated;
grant execute on function public.current_student_belongs_to_class(uuid) to authenticated;
grant execute on function public.current_teacher_has_student(uuid) to authenticated;
grant execute on function public.current_teacher_can_read_user(uuid) to authenticated;

drop policy if exists "teachers read enrolled users" on public.users;
create policy "teachers read enrolled users"
on public.users for select to authenticated
using (public.current_teacher_can_read_user(id));

drop policy if exists "teachers read enrolled students" on public.students;
create policy "teachers read enrolled students"
on public.students for select to authenticated
using (public.current_teacher_has_student(id));

drop policy if exists "students read assigned class" on public.classes;
create policy "students read assigned class"
on public.classes for select to authenticated
using (public.current_student_belongs_to_class(id));

drop policy if exists "teachers read own class members" on public.class_members;
create policy "teachers read own class members"
on public.class_members for select to authenticated
using (public.current_teacher_owns_class(class_id));

commit;
