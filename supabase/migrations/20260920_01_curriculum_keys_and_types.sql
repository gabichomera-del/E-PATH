-- Stable public curriculum keys while preserving UUID primary/foreign keys.
alter table public.units add column if not exists content_key text;
alter table public.missions add column if not exists content_key text;
alter table public.missions add column if not exists objective text not null default '';
alter table public.activities add column if not exists content_key text;
alter table public.activity_items add column if not exists content_key text;
alter table public.activities add column if not exists metadata jsonb not null default '{}'::jsonb;

create unique index if not exists units_content_key_uidx on public.units(content_key) where content_key is not null;
create unique index if not exists missions_content_key_uidx on public.missions(content_key) where content_key is not null;
create unique index if not exists activities_content_key_uidx on public.activities(content_key) where content_key is not null;
create unique index if not exists activity_items_content_key_uidx on public.activity_items(content_key) where content_key is not null;

do $$ begin alter table public.units add constraint units_content_key_unique unique(content_key); exception when duplicate_object then null; end $$;
do $$ begin alter table public.missions add constraint missions_content_key_unique unique(content_key); exception when duplicate_object then null; end $$;
do $$ begin alter table public.activities add constraint activities_content_key_unique unique(content_key); exception when duplicate_object then null; end $$;
do $$ begin alter table public.activity_items add constraint activity_items_content_key_unique unique(content_key); exception when duplicate_object then null; end $$;

alter type public.activity_type add value if not exists 'learning_profile';
alter type public.activity_type add value if not exists 'navigation';
alter type public.activity_type add value if not exists 'schedule';
alter type public.activity_type add value if not exists 'code_unlock';
alter type public.activity_type add value if not exists 'problem_path';
alter type public.activity_type add value if not exists 'grammar_machine';
alter type public.activity_type add value if not exists 'survival_guide';
alter type public.activity_type add value if not exists 'guided_advice';
alter type public.activity_type add value if not exists 'multi_select';
alter type public.activity_type add value if not exists 'listening';
alter type public.activity_type add value if not exists 'school_builder';
alter type public.activity_type add value if not exists 'school_schedule';
alter type public.activity_type add value if not exists 'school_profile';
alter type public.activity_type add value if not exists 'checkpoint_schedule';
alter type public.activity_type add value if not exists 'evaluated_writing';

-- Preserve map states while adding explicit execution states for durable resume.
alter type public.mission_status add value if not exists 'not_started';
alter type public.mission_status add value if not exists 'in_progress';
