create policy availability_select on public.teacher_availability for select to authenticated
  using (teacher_id = (select public.current_teacher_id()) or (select public.is_planner()));
create policy availability_insert on public.teacher_availability for insert to authenticated
  with check (teacher_id = (select public.current_teacher_id()));
create policy availability_update on public.teacher_availability for update to authenticated
  using (teacher_id = (select public.current_teacher_id())) with check (teacher_id = (select public.current_teacher_id()));
create policy availability_delete on public.teacher_availability for delete to authenticated
  using (teacher_id = (select public.current_teacher_id()));
create trigger trg_audit_availability after insert or delete or update on public.teacher_availability
  for each row execute function public.audit_trigger();
grant select, insert, update, delete on public.teacher_availability to authenticated;
