alter table public.student_activity_progress enable row level security;
alter table public.student_xp_ledger enable row level security;
alter table public.student_badges enable row level security;
alter table public.student_unit_progress enable row level security;

create policy "students read own activity progress" on public.student_activity_progress for select to authenticated using (student_id=public.current_student_id());
create policy "teachers read class activity progress" on public.student_activity_progress for select to authenticated using (exists(select 1 from public.class_members cm join public.classes c on c.id=cm.class_id where cm.student_id=student_activity_progress.student_id and c.teacher_id=public.current_teacher_id()));
create policy "students read own xp" on public.student_xp_ledger for select to authenticated using (student_id=public.current_student_id());
create policy "teachers read class xp" on public.student_xp_ledger for select to authenticated using (exists(select 1 from public.class_members cm join public.classes c on c.id=cm.class_id where cm.student_id=student_xp_ledger.student_id and c.teacher_id=public.current_teacher_id()));
create policy "students read own badges" on public.student_badges for select to authenticated using (student_id=public.current_student_id());
create policy "teachers read class badges" on public.student_badges for select to authenticated using (exists(select 1 from public.class_members cm join public.classes c on c.id=cm.class_id where cm.student_id=student_badges.student_id and c.teacher_id=public.current_teacher_id()));
create policy "students read own unit progress" on public.student_unit_progress for select to authenticated using (student_id=public.current_student_id());
create policy "teachers read class unit progress" on public.student_unit_progress for select to authenticated using (exists(select 1 from public.class_members cm join public.classes c on c.id=cm.class_id where cm.student_id=student_unit_progress.student_id and c.teacher_id=public.current_teacher_id()));

-- Direct student writes to canonical progress and rewards are intentionally removed.
drop policy if exists "students create own mission progress" on public.student_mission_progress;
drop policy if exists "students update own mission progress" on public.student_mission_progress;
drop policy if exists "students create own attempts" on public.student_attempts;

create or replace function public.start_learning_mission(p_mission_key text)
returns table(mission_id uuid, current_activity_key text, lives_remaining integer)
language plpgsql security definer set search_path=public as $$
declare v_student uuid; v_mission uuid; v_unit uuid; v_first_activity uuid;
begin
  v_student:=public.current_student_id();
  if v_student is null then raise exception 'Student profile required'; end if;
  select m.id,m.unit_id into v_mission,v_unit from public.missions m where m.content_key=p_mission_key;
  if v_mission is null then raise exception 'Unknown mission'; end if;
  if exists(select 1 from public.missions m where m.unit_id=v_unit and m.sort_order < (select sort_order from public.missions where id=v_mission) and not exists(select 1 from public.student_mission_progress p where p.student_id=v_student and p.mission_id=m.id and p.status='completed')) then raise exception 'Mission is locked'; end if;
  select a.id into v_first_activity from public.activities a where a.mission_id=v_mission order by a.sort_order limit 1;
  insert into public.student_mission_progress(student_id,mission_id,status,current_activity_id,lives_remaining,started_at,last_resumed_at)
  values(v_student,v_mission,'in_progress',v_first_activity,3,now(),now())
  on conflict(student_id,mission_id) do update set last_resumed_at=now();
  insert into public.student_unit_progress(student_id,unit_id,status,started_at)
  values(v_student,v_unit,'in_progress',now()) on conflict(student_id,unit_id) do update set status=case when student_unit_progress.status='completed' then 'completed'::public.learning_progress_status else 'in_progress'::public.learning_progress_status end,updated_at=now();
  return query select v_mission,a.content_key,p.lives_remaining from public.student_mission_progress p left join public.activities a on a.id=p.current_activity_id where p.student_id=v_student and p.mission_id=v_mission;
end $$;

create or replace function public.save_learning_activity(
  p_activity_key text, p_response jsonb, p_score numeric, p_is_correct boolean,
  p_lives_remaining integer, p_attempt_number integer
) returns void language plpgsql security definer set search_path=public as $$
declare v_student uuid; v_activity uuid; v_mission uuid; v_next uuid;
begin
  v_student:=public.current_student_id();
  if v_student is null then raise exception 'Student profile required'; end if;
  select a.id,a.mission_id into v_activity,v_mission from public.activities a where a.content_key=p_activity_key;
  if v_activity is null then raise exception 'Unknown activity'; end if;
  if p_lives_remaining not between 0 and 3 or p_attempt_number < 1 then raise exception 'Invalid attempt state'; end if;
  insert into public.student_attempts(student_id,activity_id,attempt_number,score,lives_remaining,response,is_correct)
  values(v_student,v_activity,p_attempt_number,greatest(0,least(100,p_score)),p_lives_remaining,p_response,p_is_correct)
  on conflict(student_id,activity_id,attempt_number) do update set score=excluded.score,lives_remaining=excluded.lives_remaining,response=excluded.response,is_correct=excluded.is_correct;
  insert into public.student_activity_progress(student_id,activity_id,status,response,score,attempt_count,completed_at,updated_at)
  values(v_student,v_activity,case when p_is_correct then 'completed' else 'in_progress' end,p_response,greatest(0,least(100,p_score)),p_attempt_number,case when p_is_correct then now() end,now())
  on conflict(student_id,activity_id) do update set status=case when student_activity_progress.status='completed' then 'completed'::public.learning_progress_status else excluded.status end,response=case when student_activity_progress.status='completed' then student_activity_progress.response else excluded.response end,score=case when student_activity_progress.status='completed' then student_activity_progress.score else excluded.score end,attempt_count=greatest(student_activity_progress.attempt_count,excluded.attempt_count),completed_at=coalesce(student_activity_progress.completed_at,excluded.completed_at),updated_at=now();
  select a.id into v_next from public.activities a where a.mission_id=v_mission and a.sort_order>(select sort_order from public.activities where id=v_activity) order by a.sort_order limit 1;
  update public.student_mission_progress set status='in_progress',current_activity_id=case when p_is_correct then coalesce(v_next,v_activity) else v_activity end,lives_remaining=p_lives_remaining,last_resumed_at=now(),updated_at=now() where student_id=v_student and mission_id=v_mission and status<>'completed';
end $$;

create or replace function public.save_learning_activity_draft(p_activity_key text,p_response jsonb,p_lives_remaining integer)
returns void language plpgsql security definer set search_path=public as $$
declare v_student uuid;v_activity uuid;v_mission uuid;
begin
  v_student:=public.current_student_id();
  if v_student is null then raise exception 'Student profile required'; end if;
  select a.id,a.mission_id into v_activity,v_mission from public.activities a where a.content_key=p_activity_key;
  if v_activity is null or p_lives_remaining not between 0 and 3 then raise exception 'Invalid activity state'; end if;
  insert into public.student_activity_progress(student_id,activity_id,status,response,attempt_count,updated_at)
  values(v_student,v_activity,'in_progress',p_response,0,now())
  on conflict(student_id,activity_id) do update set response=case when student_activity_progress.status='completed' then student_activity_progress.response else excluded.response end,updated_at=now();
  update public.student_mission_progress set status='in_progress',current_activity_id=v_activity,lives_remaining=p_lives_remaining,last_resumed_at=now(),updated_at=now() where student_id=v_student and mission_id=v_mission and status<>'completed';
end $$;

create or replace function public.complete_learning_mission(p_mission_key text)
returns table(score numeric,xp_earned integer,badge_earned text,unit_completed boolean)
language plpgsql security definer set search_path=public as $$
declare v_student uuid; v_mission public.missions%rowtype; v_score numeric; v_next uuid; v_completed_count integer; v_total integer; v_unit_done boolean;
begin
  v_student:=public.current_student_id();
  if v_student is null then raise exception 'Student profile required'; end if;
  select * into v_mission from public.missions where content_key=p_mission_key;
  if v_mission.id is null then raise exception 'Unknown mission'; end if;
  if exists(select 1 from public.activities a where a.mission_id=v_mission.id and not exists(select 1 from public.student_activity_progress ap where ap.student_id=v_student and ap.activity_id=a.id and ap.status='completed')) then raise exception 'All activities must be completed first'; end if;
  select coalesce(round(avg(ap.score),2),100) into v_score from public.student_activity_progress ap join public.activities a on a.id=ap.activity_id where ap.student_id=v_student and a.mission_id=v_mission.id;
  insert into public.student_mission_progress(student_id,mission_id,status,score,xp_earned,lives_remaining,started_at,completed_at,updated_at)
  values(v_student,v_mission.id,'completed',v_score,v_mission.xp_reward,3,now(),now(),now())
  on conflict(student_id,mission_id) do update set status='completed',score=coalesce(student_mission_progress.score,excluded.score),xp_earned=greatest(student_mission_progress.xp_earned,excluded.xp_earned),completed_at=coalesce(student_mission_progress.completed_at,excluded.completed_at),updated_at=now();
  insert into public.student_xp_ledger(student_id,mission_id,xp_amount) values(v_student,v_mission.id,v_mission.xp_reward) on conflict(student_id,mission_id) do nothing;
  if v_mission.badge_reward is not null then insert into public.student_badges(student_id,mission_id,badge_key,badge_name) values(v_student,v_mission.id,v_mission.content_key,v_mission.badge_reward) on conflict(student_id,badge_key) do nothing; end if;
  select id into v_next from public.missions where unit_id=v_mission.unit_id and sort_order>v_mission.sort_order order by sort_order limit 1;
  if v_next is not null then insert into public.student_mission_progress(student_id,mission_id,status,lives_remaining) values(v_student,v_next,'available',3) on conflict(student_id,mission_id) do nothing; end if;
  select count(*) into v_completed_count from public.student_mission_progress p join public.missions m on m.id=p.mission_id where p.student_id=v_student and m.unit_id=v_mission.unit_id and p.status='completed';
  select count(*) into v_total from public.missions where unit_id=v_mission.unit_id;
  v_unit_done:=v_total>0 and v_completed_count=v_total;
  insert into public.student_unit_progress(student_id,unit_id,status,completed_missions,total_xp,started_at,completed_at,updated_at)
  values(v_student,v_mission.unit_id,case when v_unit_done then 'completed' else 'in_progress' end,v_completed_count,(select coalesce(sum(xp_amount),0) from public.student_xp_ledger x join public.missions m on m.id=x.mission_id where x.student_id=v_student and m.unit_id=v_mission.unit_id),now(),case when v_unit_done then now() end,now())
  on conflict(student_id,unit_id) do update set status=excluded.status,completed_missions=excluded.completed_missions,total_xp=excluded.total_xp,started_at=coalesce(student_unit_progress.started_at,excluded.started_at),completed_at=coalesce(student_unit_progress.completed_at,excluded.completed_at),updated_at=now();
  return query select v_score,v_mission.xp_reward,v_mission.badge_reward,v_unit_done;
end $$;

revoke all on function public.start_learning_mission(text) from public, anon;
revoke all on function public.save_learning_activity(text,jsonb,numeric,boolean,integer,integer) from public, anon;
revoke all on function public.save_learning_activity_draft(text,jsonb,integer) from public, anon;
revoke all on function public.complete_learning_mission(text) from public, anon;
grant execute on function public.start_learning_mission(text) to authenticated;
grant execute on function public.save_learning_activity(text,jsonb,numeric,boolean,integer,integer) to authenticated;
grant execute on function public.save_learning_activity_draft(text,jsonb,integer) to authenticated;
grant execute on function public.complete_learning_mission(text) to authenticated;
