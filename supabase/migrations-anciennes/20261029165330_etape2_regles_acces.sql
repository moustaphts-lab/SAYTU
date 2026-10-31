
-- lecture : chacun ne voit que ses facultés
alter policy faculties_select on public.faculties using ((select public.sees_fac(id)));
alter policy departments_select on public.departments using ((select public.sees_fac(faculty_id)));
alter policy programs_select on public.programs using ((select public.sees_fac(public.fac_of_dept(department_id))));
alter policy student_groups_select on public.student_groups using ((select public.sees_fac(public.fac_of_program(program_id))));
alter policy courses_select on public.courses using ((select public.sees_fac(public.fac_of_dept(department_id))));
alter policy course_programs_select on public.course_programs using ((select public.sees_fac(public.fac_of_course(course_id))));
alter policy rooms_select on public.rooms using ((select public.sees_fac(faculty_id)));
alter policy semesters_select on public.semesters using ((select public.sees_fac(faculty_id)));
alter policy school_schedule_select on public.school_schedule using ((select public.sees_fac(faculty_id)));
alter policy calendar_closures_select on public.calendar_closures using (faculty_id is null or (select public.sees_fac(faculty_id)));
alter policy teachers_select on public.teachers using (id = (select public.current_teacher_id()) or (select public.sees_fac(public.fac_of_dept(department_id))));
alter policy teaching_assignments_select on public.teaching_assignments using (teacher_id = (select public.current_teacher_id()) or (select public.sees_fac(public.fac_of_course(course_id))));
alter policy assignment_groups_select on public.assignment_groups using ((select public.sees_fac(public.faculty_of_assignment(assignment_id))) or exists (select 1 from public.teaching_assignments ta where ta.id = assignment_id and ta.teacher_id = (select public.current_teacher_id())));
alter policy timetable_slots_select on public.timetable_slots using (
  (published and ((select public.sees_fac(public.faculty_of_assignment(assignment_id))) or exists (select 1 from public.teaching_assignments ta where ta.id = assignment_id and ta.teacher_id = (select public.current_teacher_id()))))
  or (select public.is_planner_for(public.faculty_of_assignment(assignment_id))));
alter policy schedule_sessions_select on public.schedule_sessions using (teacher_id = (select public.current_teacher_id()) or (select public.sees_fac(public.faculty_of_assignment(assignment_id))));
alter policy announcements_select on public.announcements using (faculty_id is null or (select public.sees_fac(faculty_id)));
alter policy absence_requests_select on public.absence_requests using (teacher_id = (select public.current_teacher_id())
  or (select public.is_planner_for(public.fac_of_session(session_id))) or (select public.has_role_for('direction', public.fac_of_session(session_id))) or (select public.has_role_for('lecteur', public.fac_of_session(session_id))));
alter policy attendance_select on public.attendance_records using (teacher_id = (select public.current_teacher_id())
  or (select public.has_role_for('finance', public.fac_of_session(session_id))) or (select public.has_role_for('direction', public.fac_of_session(session_id)))
  or (select public.has_role_for('lecteur', public.fac_of_session(session_id))) or (select public.is_planner_for(public.fac_of_session(session_id)))
  or exists (select 1 from public.schedule_sessions s join public.teaching_assignments ta on ta.id = s.assignment_id join public.courses c on c.id = ta.course_id
    where s.id = attendance_records.session_id and public.can_review_department(c.department_id)));
alter policy attendance_select_planner on public.attendance_records using ((select public.is_planner_for(public.fac_of_session(session_id))));
alter policy availability_select on public.teacher_availability using (teacher_id = (select public.current_teacher_id()) or (select public.is_planner_for(public.fac_of_teacher(teacher_id))));
alter policy availability_weeks_select on public.availability_weeks using (teacher_id = (select public.current_teacher_id()) or (select public.is_planner_for(public.fac_of_teacher(teacher_id))));
alter policy profiles_select on public.profiles using (id = (select auth.uid()) or (select public.can_manage_user(id))
  or exists (select 1 from public.user_roles ur where ur.user_id = (select auth.uid()) and ur.role <> 'professeur' and (ur.faculty_id is null or ur.faculty_id = profiles.faculty_id)));
alter policy roles_select on public.user_roles using (user_id = (select auth.uid()) or (select public.can_manage_user(user_id)));
-- journal : le personnel de l'université voit tout ; celui d'une faculté voit les actions des personnes de sa faculté
alter policy audit_select on public.audit_logs using (exists (select 1 from public.user_roles ur where ur.user_id = (select auth.uid()) and ur.role in ('admin','direction','lecteur')
  and (ur.faculty_id is null or ur.faculty_id = (select p.faculty_id from public.profiles p where p.id = audit_logs.actor))));
alter policy audit_finance_read on public.audit_logs using (exists (select 1 from public.user_roles ur where ur.user_id = (select auth.uid()) and ur.role = 'finance'
  and (ur.faculty_id is null or ur.faculty_id = (select p.faculty_id from public.profiles p where p.id = audit_logs.actor))));

-- écriture : le directeur des études de la faculté
alter policy departments_write on public.departments using ((select public.is_planner_for(faculty_id))) with check ((select public.is_planner_for(faculty_id)));
alter policy programs_write on public.programs using ((select public.is_planner_for(public.fac_of_dept(department_id)))) with check ((select public.is_planner_for(public.fac_of_dept(department_id))));
alter policy student_groups_write on public.student_groups using ((select public.is_planner_for(public.fac_of_program(program_id)))) with check ((select public.is_planner_for(public.fac_of_program(program_id))));
alter policy courses_write on public.courses using ((select public.is_planner_for(public.fac_of_dept(department_id)))) with check ((select public.is_planner_for(public.fac_of_dept(department_id))));
alter policy course_programs_planner on public.course_programs using ((select public.is_planner_for(public.fac_of_course(course_id)))) with check ((select public.is_planner_for(public.fac_of_course(course_id))));
alter policy rooms_write on public.rooms using ((select public.is_planner_for(faculty_id))) with check ((select public.is_planner_for(faculty_id)));
alter policy semesters_write on public.semesters using ((select public.is_planner_for(faculty_id))) with check ((select public.is_planner_for(faculty_id)));
alter policy school_schedule_update on public.school_schedule using ((select public.is_planner_for(faculty_id))) with check ((select public.is_planner_for(faculty_id)));
alter policy calendar_closures_write on public.calendar_closures using (case when faculty_id is null then (select public.is_central_admin()) or (select public.has_role_for('planificateur', null)) else (select public.is_planner_for(faculty_id)) end)
  with check (case when faculty_id is null then (select public.is_central_admin()) or (select public.has_role_for('planificateur', null)) else (select public.is_planner_for(faculty_id)) end);
alter policy teachers_write on public.teachers using ((select public.is_planner_for(public.fac_of_dept(department_id)))) with check ((select public.is_planner_for(public.fac_of_dept(department_id))));
alter policy ts_write on public.teacher_statuses using ((select public.is_planner())) with check ((select public.is_planner()));
alter policy academic_years_write on public.academic_years using ((select public.is_central_admin()) or (select public.has_role_for('planificateur', null))) with check ((select public.is_central_admin()) or (select public.has_role_for('planificateur', null)));
alter policy teaching_assignments_planner on public.teaching_assignments using ((select public.is_planner_for(public.fac_of_course(course_id)))) with check ((select public.is_planner_for(public.fac_of_course(course_id))));
alter policy assignment_groups_planner on public.assignment_groups using ((select public.is_planner_for(public.faculty_of_assignment(assignment_id)))) with check ((select public.is_planner_for(public.faculty_of_assignment(assignment_id))));
alter policy timetable_slots_planner on public.timetable_slots using ((select public.is_planner_for(public.faculty_of_assignment(assignment_id)))) with check ((select public.is_planner_for(public.faculty_of_assignment(assignment_id))));
alter policy schedule_sessions_planner on public.schedule_sessions using ((select public.is_planner_for(public.faculty_of_assignment(assignment_id)))) with check ((select public.is_planner_for(public.faculty_of_assignment(assignment_id))));
alter policy announcements_write on public.announcements using (case when faculty_id is null then (select public.is_central_admin()) else (select public.is_planner_for(faculty_id)) or (select public.admin_for(faculty_id)) end)
  with check (case when faculty_id is null then (select public.is_central_admin()) else (select public.is_planner_for(faculty_id)) or (select public.admin_for(faculty_id)) end);
alter policy app_settings_update on public.app_settings using ((select public.is_central_admin())) with check ((select public.is_central_admin()));
alter policy faculties_admin on public.faculties using ((select public.is_central_admin())) with check ((select public.is_central_admin()));
create policy faculties_own_admin on public.faculties for update to authenticated using ((select public.admin_for(id))) with check ((select public.admin_for(id)));
alter policy profiles_admin on public.profiles using ((select public.can_manage_user(id))) with check ((select public.can_manage_user(id)));
alter policy roles_admin on public.user_roles using ((select public.can_manage_user(user_id)))
  with check ((select public.can_manage_user(user_id)) and ((select public.is_central_admin()) or (faculty_id is not null and (select public.admin_for(faculty_id)))));

