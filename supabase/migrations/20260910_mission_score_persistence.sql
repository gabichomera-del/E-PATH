alter table public.student_mission_progress
  add column if not exists xp_earned integer not null default 0;

comment on column public.student_mission_progress.score is
  'Final mission score percentage. This value is preserved after completion.';

comment on column public.student_mission_progress.xp_earned is
  'XP awarded when the mission was completed.';
