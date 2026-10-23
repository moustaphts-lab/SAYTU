-- UCAB Touba : retire à l'administrateur les anciens droits sur le référentiel et sur les heures.
-- À coller dans Supabase > SQL Editor > Run (une seule fois).
-- Après ce script : l'administrateur gère uniquement les comptes et les rôles.
-- Les planificateurs (directeur, secrétaire) gardent l'écriture du référentiel ; tout le monde garde la lecture.

begin;

drop policy if exists academic_years_admin on public.academic_years;
drop policy if exists semesters_admin      on public.semesters;
drop policy if exists departments_admin    on public.departments;
drop policy if exists programs_admin       on public.programs;
drop policy if exists courses_admin        on public.courses;
drop policy if exists student_groups_admin on public.student_groups;
drop policy if exists rooms_admin          on public.rooms;
drop policy if exists ts_admin             on public.teacher_statuses;
drop policy if exists teachers_admin       on public.teachers;

-- Lecture des émargements : plus d'accès pour l'administrateur
drop policy if exists attendance_select on public.attendance_records;
create policy attendance_select on public.attendance_records for select to authenticated using (
  teacher_id = (select public.current_teacher_id())
  or (select public.has_role('finance'))
  or (select public.has_role('direction'))
  or (select public.is_planner())
  or exists (
    select 1 from public.schedule_sessions s
    join public.teaching_assignments ta on ta.id = s.assignment_id
    join public.courses c on c.id = ta.course_id
    where s.id = attendance_records.session_id and public.can_review_department(c.department_id)
  )
);

commit;

-- Vérification : cette requête ne doit plus renvoyer que profiles_admin, roles_admin, roles_select et audit_select
select tablename, policyname from pg_policies
where schemaname='public' and (coalesce(qual,'')||coalesce(with_check,'')) ilike '%has_role(''admin''%'
order by 1,2;
