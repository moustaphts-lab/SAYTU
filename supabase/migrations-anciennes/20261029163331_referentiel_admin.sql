
create or replace function public.can_edit_ref() returns boolean language sql stable security definer set search_path to '' as $$
  select public.is_planner() or public.has_role('admin') $$;
alter policy academic_years_write on public.academic_years using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy calendar_closures_write on public.calendar_closures using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy course_programs_planner on public.course_programs using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy courses_write on public.courses using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy departments_write on public.departments using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy programs_write on public.programs using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy rooms_write on public.rooms using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy school_schedule_update on public.school_schedule using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy semesters_write on public.semesters using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy student_groups_write on public.student_groups using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy ts_write on public.teacher_statuses using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));
alter policy teachers_write on public.teachers using ((select public.can_edit_ref())) with check ((select public.can_edit_ref()));

