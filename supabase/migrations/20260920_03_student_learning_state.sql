do $$ begin
  create type public.learning_progress_status as enum ('not_started', 'in_progress', 'completed');
exception when duplicate_object then null; end $$;

alter table public.student_mission_progress add column if not exists current_activity_id uuid references public.activities(id) on delete set null;
alter table public.student_mission_progress add column if not exists lives_remaining integer not null default 3 check (lives_remaining between 0 and 3);
alter table public.student_mission_progress add column if not exists started_at timestamptz;
alter table public.student_mission_progress add column if not exists last_resumed_at timestamptz;

create table if not exists public.student_activity_progress (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  activity_id uuid not null references public.activities(id) on delete cascade,
  status public.learning_progress_status not null default 'not_started',
  response jsonb,
  score numeric(5,2) check (score between 0 and 100),
  attempt_count integer not null default 0 check (attempt_count >= 0),
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  unique(student_id, activity_id)
);

create table if not exists public.student_xp_ledger (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  mission_id uuid not null references public.missions(id) on delete cascade,
  xp_amount integer not null check (xp_amount >= 0),
  awarded_at timestamptz not null default now(),
  unique(student_id, mission_id)
);

create table if not exists public.student_badges (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  mission_id uuid not null references public.missions(id) on delete cascade,
  badge_key text not null,
  badge_name text not null,
  earned_at timestamptz not null default now(),
  unique(student_id, badge_key)
);

create table if not exists public.student_unit_progress (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  unit_id uuid not null references public.units(id) on delete cascade,
  status public.learning_progress_status not null default 'not_started',
  completed_missions integer not null default 0 check (completed_missions >= 0),
  total_xp integer not null default 0 check (total_xp >= 0),
  started_at timestamptz,
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  unique(student_id, unit_id)
);

create index if not exists activity_progress_student_idx on public.student_activity_progress(student_id, status);
create index if not exists xp_ledger_student_idx on public.student_xp_ledger(student_id, awarded_at desc);
create index if not exists badges_student_idx on public.student_badges(student_id, earned_at desc);
create index if not exists unit_progress_student_idx on public.student_unit_progress(student_id, status);
