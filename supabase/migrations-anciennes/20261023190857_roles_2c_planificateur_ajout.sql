
do $$ declare t text;
begin
  foreach t in array array['academic_years','semesters','departments','programs','student_groups','courses','rooms','teachers']
  loop
    execute format('create policy %1$s_write on public.%1$I for all to authenticated using ((select public.is_planner())) with check ((select public.is_planner()))', t);
  end loop;
end $$;
create policy ts_write on public.teacher_statuses for all to authenticated
  using ((select public.is_planner())) with check ((select public.is_planner()));
create policy attendance_select_planner on public.attendance_records for select to authenticated
  using ((select public.is_planner()));
