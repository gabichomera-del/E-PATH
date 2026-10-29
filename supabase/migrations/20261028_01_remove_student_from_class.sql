begin;

create or replace function public.remove_student_from_class(
  p_class_id uuid,
  p_student_id uuid
)
returns boolean
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_user_id uuid;
  v_teacher_id uuid;
  v_membership_id uuid;
begin
  v_user_id := auth.uid();
  if v_user_id is null then
    raise exception using errcode = 'P0001', message = 'Authentication required.';
  end if;

  select t.id
  into v_teacher_id
  from public.teachers t
  where t.user_id = v_user_id;

  if v_teacher_id is null then
    raise exception using errcode = 'P0001', message = 'Teacher access required.';
  end if;

  if not exists (
    select 1
    from public.classes c
    where c.id = p_class_id
      and c.teacher_id = v_teacher_id
  ) then
    raise exception using errcode = 'P0001', message = 'Class not found or access denied.';
  end if;

  delete from public.class_members cm
  where cm.class_id = p_class_id
    and cm.student_id = p_student_id
  returning cm.id into v_membership_id;

  if v_membership_id is null then
    raise exception using errcode = 'P0001', message = 'Student is not enrolled in this class.';
  end if;

  return true;
end;
$$;

revoke all on function public.remove_student_from_class(uuid, uuid) from public, anon;
grant execute on function public.remove_student_from_class(uuid, uuid) to authenticated;

commit;
