
revoke execute on function public.has_role(public.app_role), public.current_teacher_id(), public.can_review_department(bigint),
  public.is_planner(), public.my_roles() from public, anon;
grant execute on function public.has_role(public.app_role), public.current_teacher_id(), public.can_review_department(bigint),
  public.is_planner(), public.my_roles() to authenticated;
