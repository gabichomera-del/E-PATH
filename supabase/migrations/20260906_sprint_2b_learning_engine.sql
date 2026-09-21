-- Sprint 2B: reusable curriculum, mission progress, and attempt history.
create type public.activity_type as enum ('matching', 'fill_blank', 'multiple_choice', 'unscramble', 'reading', 'writing');
create type public.mission_status as enum ('locked', 'available', 'completed');
create type public.mission_difficulty as enum ('starter', 'explorer', 'challenger');

create table public.grades (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  sort_order integer not null unique check (sort_order > 0)
);

create table public.units (
  id uuid primary key default gen_random_uuid(),
  grade_id uuid not null references public.grades(id) on delete restrict,
  title text not null,
  description text not null default '',
  sort_order integer not null check (sort_order > 0),
  created_at timestamptz not null default now(),
  unique (grade_id, sort_order)
);

create table public.missions (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references public.units(id) on delete cascade,
  title text not null,
  description text not null default '',
  sort_order integer not null check (sort_order > 0),
  difficulty public.mission_difficulty not null default 'starter',
  xp_reward integer not null default 0 check (xp_reward >= 0),
  badge_reward text,
  created_at timestamptz not null default now(),
  unique (unit_id, sort_order)
);

create table public.activities (
  id uuid primary key default gen_random_uuid(),
  mission_id uuid not null references public.missions(id) on delete cascade,
  type public.activity_type not null,
  instructions text not null,
  sort_order integer not null check (sort_order > 0),
  unique (mission_id, sort_order)
);

create table public.activity_items (
  id uuid primary key default gen_random_uuid(),
  activity_id uuid not null references public.activities(id) on delete cascade,
  content jsonb not null default '{}'::jsonb,
  answer jsonb not null,
  sort_order integer not null default 1 check (sort_order > 0),
  unique (activity_id, sort_order)
);

create table public.student_mission_progress (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  mission_id uuid not null references public.missions(id) on delete cascade,
  status public.mission_status not null default 'locked',
  score numeric(5,2) check (score between 0 and 100),
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  unique (student_id, mission_id)
);

create table public.student_attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  activity_id uuid not null references public.activities(id) on delete cascade,
  attempt_number integer not null check (attempt_number > 0),
  score numeric(5,2) not null check (score between 0 and 100),
  lives_remaining integer not null check (lives_remaining between 0 and 3),
  response jsonb,
  is_correct boolean not null,
  attempted_at timestamptz not null default now(),
  unique (student_id, activity_id, attempt_number)
);

create index units_grade_idx on public.units(grade_id, sort_order);
create index missions_unit_idx on public.missions(unit_id, sort_order);
create index activities_mission_idx on public.activities(mission_id, sort_order);
create index activity_items_activity_idx on public.activity_items(activity_id, sort_order);
create index mission_progress_student_idx on public.student_mission_progress(student_id, status);
create index attempts_student_activity_idx on public.student_attempts(student_id, activity_id, attempted_at desc);

alter table public.grades enable row level security;
alter table public.units enable row level security;
alter table public.missions enable row level security;
alter table public.activities enable row level security;
alter table public.activity_items enable row level security;
alter table public.student_mission_progress enable row level security;
alter table public.student_attempts enable row level security;

create policy "authenticated users read grades" on public.grades for select to authenticated using (true);
create policy "authenticated users read units" on public.units for select to authenticated using (true);
create policy "authenticated users read missions" on public.missions for select to authenticated using (true);
create policy "authenticated users read activities" on public.activities for select to authenticated using (true);
create policy "authenticated users read activity items" on public.activity_items for select to authenticated using (true);
create policy "students read own mission progress" on public.student_mission_progress for select using (auth.uid() = student_id);
create policy "students create own mission progress" on public.student_mission_progress for insert with check (auth.uid() = student_id);
create policy "students update own mission progress" on public.student_mission_progress for update using (auth.uid() = student_id) with check (auth.uid() = student_id);
create policy "students read own attempts" on public.student_attempts for select using (auth.uid() = student_id);
create policy "students create own attempts" on public.student_attempts for insert with check (auth.uid() = student_id);
create policy "teachers read class progress" on public.student_mission_progress for select using (exists (select 1 from public.class_members cm join public.classes c on c.id = cm.class_id where cm.student_id = student_mission_progress.student_id and c.teacher_id = auth.uid()));
create policy "teachers read class attempts" on public.student_attempts for select using (exists (select 1 from public.class_members cm join public.classes c on c.id = cm.class_id where cm.student_id = student_attempts.student_id and c.teacher_id = auth.uid()));
