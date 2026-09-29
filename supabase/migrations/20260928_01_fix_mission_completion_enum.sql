-- Preserve the existing mission-completion behavior while assigning PostgreSQL enums explicitly.
begin;

create or replace function public.complete_learning_mission(p_mission_key text)
returns table(score numeric, xp_earned integer, badge_earned text, unit_completed boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_student uuid;
  v_mission public.missions%rowtype;
  v_score numeric;
  v_next uuid;
  v_completed_count integer;
  v_total integer;
  v_unit_done boolean;
begin
  v_student := public.current_student_id();
  if v_student is null then raise exception 'Student profile required'; end if;

  select * into v_mission from public.missions where content_key = p_mission_key;
  if v_mission.id is null then raise exception 'Unknown mission'; end if;

  if exists(
    select 1 from public.activities a
    where a.mission_id = v_mission.id
      and not exists(
        select 1 from public.student_activity_progress ap
        where ap.student_id = v_student
          and ap.activity_id = a.id
          and ap.status = 'completed'::public.learning_progress_status
      )
  ) then
    raise exception 'All activities must be completed first';
  end if;

  select coalesce(round(avg(ap.score), 2), 100)
  into v_score
  from public.student_activity_progress ap
  join public.activities a on a.id = ap.activity_id
  where ap.student_id = v_student and a.mission_id = v_mission.id;

  insert into public.student_mission_progress(
    student_id, mission_id, status, score, xp_earned, lives_remaining,
    started_at, completed_at, updated_at
  ) values (
    v_student, v_mission.id, 'completed'::public.mission_status, v_score,
    v_mission.xp_reward, 3, now(), now(), now()
  )
  on conflict(student_id, mission_id) do update set
    status = 'completed'::public.mission_status,
    score = coalesce(student_mission_progress.score, excluded.score),
    xp_earned = greatest(student_mission_progress.xp_earned, excluded.xp_earned),
    completed_at = coalesce(student_mission_progress.completed_at, excluded.completed_at),
    updated_at = now();

  insert into public.student_xp_ledger(student_id, mission_id, xp_amount)
  values(v_student, v_mission.id, v_mission.xp_reward)
  on conflict(student_id, mission_id) do nothing;

  if v_mission.badge_reward is not null then
    insert into public.student_badges(student_id, mission_id, badge_key, badge_name)
    values(v_student, v_mission.id, v_mission.content_key, v_mission.badge_reward)
    on conflict(student_id, badge_key) do nothing;
  end if;

  select id into v_next
  from public.missions
  where unit_id = v_mission.unit_id and sort_order > v_mission.sort_order
  order by sort_order
  limit 1;

  if v_next is not null then
    insert into public.student_mission_progress(student_id, mission_id, status, lives_remaining)
    values(v_student, v_next, 'available'::public.mission_status, 3)
    on conflict(student_id, mission_id) do update set
      status = case
        when student_mission_progress.status in (
          'completed'::public.mission_status,
          'in_progress'::public.mission_status,
          'available'::public.mission_status
        ) then student_mission_progress.status
        else 'available'::public.mission_status
      end;
  end if;

  select count(*) into v_completed_count
  from public.student_mission_progress p
  join public.missions m on m.id = p.mission_id
  where p.student_id = v_student
    and m.unit_id = v_mission.unit_id
    and p.status = 'completed'::public.mission_status;

  select count(*) into v_total from public.missions where unit_id = v_mission.unit_id;
  v_unit_done := v_total > 0 and v_completed_count = v_total;

  insert into public.student_unit_progress(
    student_id, unit_id, status, completed_missions, total_xp,
    started_at, completed_at, updated_at
  ) values (
    v_student,
    v_mission.unit_id,
    case
      when v_unit_done then 'completed'::public.learning_progress_status
      else 'in_progress'::public.learning_progress_status
    end,
    v_completed_count,
    (select coalesce(sum(xp_amount), 0)
     from public.student_xp_ledger x
     join public.missions m on m.id = x.mission_id
     where x.student_id = v_student and m.unit_id = v_mission.unit_id),
    now(),
    case when v_unit_done then now() end,
    now()
  )
  on conflict(student_id, unit_id) do update set
    status = excluded.status,
    completed_missions = excluded.completed_missions,
    total_xp = excluded.total_xp,
    started_at = coalesce(student_unit_progress.started_at, excluded.started_at),
    completed_at = coalesce(student_unit_progress.completed_at, excluded.completed_at),
    updated_at = now();

  return query select v_score, v_mission.xp_reward, v_mission.badge_reward, v_unit_done;
end;
$$;

revoke all on function public.complete_learning_mission(text) from public, anon;
grant execute on function public.complete_learning_mission(text) to authenticated;

commit;
