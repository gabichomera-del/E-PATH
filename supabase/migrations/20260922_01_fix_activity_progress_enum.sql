-- Fix enum assignment in save_learning_activity without changing table data.
begin;

create or replace function public.save_learning_activity(
  p_activity_key text,
  p_response jsonb,
  p_score numeric,
  p_is_correct boolean,
  p_lives_remaining integer,
  p_attempt_number integer
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_student uuid;
  v_activity uuid;
  v_mission uuid;
  v_next uuid;
begin
  v_student := public.current_student_id();
  if v_student is null then
    raise exception 'Student profile required';
  end if;

  select a.id, a.mission_id
  into v_activity, v_mission
  from public.activities a
  where a.content_key = p_activity_key;

  if v_activity is null then
    raise exception 'Unknown activity';
  end if;

  if p_lives_remaining not between 0 and 3 or p_attempt_number < 1 then
    raise exception 'Invalid attempt state';
  end if;

  insert into public.student_attempts(
    student_id,
    activity_id,
    attempt_number,
    score,
    lives_remaining,
    response,
    is_correct
  ) values (
    v_student,
    v_activity,
    p_attempt_number,
    greatest(0, least(100, p_score)),
    p_lives_remaining,
    p_response,
    p_is_correct
  )
  on conflict(student_id, activity_id, attempt_number)
  do update set
    score = excluded.score,
    lives_remaining = excluded.lives_remaining,
    response = excluded.response,
    is_correct = excluded.is_correct;

  insert into public.student_activity_progress(
    student_id,
    activity_id,
    status,
    response,
    score,
    attempt_count,
    completed_at,
    updated_at
  ) values (
    v_student,
    v_activity,
    case
      when p_is_correct then 'completed'::public.learning_progress_status
      else 'in_progress'::public.learning_progress_status
    end,
    p_response,
    greatest(0, least(100, p_score)),
    p_attempt_number,
    case when p_is_correct then now() end,
    now()
  )
  on conflict(student_id, activity_id)
  do update set
    status = case
      when student_activity_progress.status = 'completed'::public.learning_progress_status
        then 'completed'::public.learning_progress_status
      else excluded.status
    end,
    response = case
      when student_activity_progress.status = 'completed'::public.learning_progress_status
        then student_activity_progress.response
      else excluded.response
    end,
    score = case
      when student_activity_progress.status = 'completed'::public.learning_progress_status
        then student_activity_progress.score
      else excluded.score
    end,
    attempt_count = greatest(student_activity_progress.attempt_count, excluded.attempt_count),
    completed_at = coalesce(student_activity_progress.completed_at, excluded.completed_at),
    updated_at = now();

  select a.id
  into v_next
  from public.activities a
  where a.mission_id = v_mission
    and a.sort_order > (select sort_order from public.activities where id = v_activity)
  order by a.sort_order
  limit 1;

  update public.student_mission_progress
  set
    status = 'in_progress'::public.mission_status,
    current_activity_id = case when p_is_correct then coalesce(v_next, v_activity) else v_activity end,
    lives_remaining = p_lives_remaining,
    last_resumed_at = now(),
    updated_at = now()
  where student_id = v_student
    and mission_id = v_mission
    and status <> 'completed'::public.mission_status;
end;
$$;

revoke all on function public.save_learning_activity(text, jsonb, numeric, boolean, integer, integer) from public, anon;
grant execute on function public.save_learning_activity(text, jsonb, numeric, boolean, integer, integer) to authenticated;

commit;
