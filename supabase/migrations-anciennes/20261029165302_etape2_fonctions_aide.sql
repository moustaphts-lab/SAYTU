
create or replace function public.fac_of_dept(d bigint) returns bigint language sql stable security definer set search_path to '' as $$ select faculty_id from public.departments where id = d $$;
create or replace function public.fac_of_program(p bigint) returns bigint language sql stable security definer set search_path to '' as $$ select d.faculty_id from public.programs p2 join public.departments d on d.id = p2.department_id where p2.id = p $$;
create or replace function public.fac_of_group(g bigint) returns bigint language sql stable security definer set search_path to '' as $$ select d.faculty_id from public.student_groups sg join public.programs p on p.id = sg.program_id join public.departments d on d.id = p.department_id where sg.id = g $$;
create or replace function public.fac_of_course(c bigint) returns bigint language sql stable security definer set search_path to '' as $$ select d.faculty_id from public.courses c2 join public.departments d on d.id = c2.department_id where c2.id = c $$;
create or replace function public.fac_of_teacher(t bigint) returns bigint language sql stable security definer set search_path to '' as $$ select d.faculty_id from public.teachers t2 join public.departments d on d.id = t2.department_id where t2.id = t $$;
create or replace function public.fac_of_session(s bigint) returns bigint language sql stable security definer set search_path to '' as $$ select public.faculty_of_assignment(assignment_id) from public.schedule_sessions where id = s $$;

-- un droit vaut pour une faculté s'il est donné pour toute l'université (faculty_id vide) ou pour cette faculté
create or replace function public.has_role_for(r public.app_role, fac bigint) returns boolean language sql stable security definer set search_path to '' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = r and (ur.faculty_id is null or ur.faculty_id = fac)) $$;
create or replace function public.is_planner_for(fac bigint) returns boolean language sql stable security definer set search_path to '' as $$ select public.has_role_for('planificateur', fac) $$;
create or replace function public.is_central_admin() returns boolean language sql stable security definer set search_path to '' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'admin' and ur.faculty_id is null) $$;
create or replace function public.admin_for(fac bigint) returns boolean language sql stable security definer set search_path to '' as $$ select public.has_role_for('admin', fac) $$;
-- voir une faculté : un droit de personnel pour toute l'université, ou n'importe quel droit dans cette faculté
create or replace function public.sees_fac(fac bigint) returns boolean language sql stable security definer set search_path to '' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid()
    and ((ur.faculty_id is null and ur.role <> 'professeur') or ur.faculty_id = fac)) $$;
-- un administrateur gère un compte de sa faculté ; l'administrateur central les gère tous
create or replace function public.can_manage_user(u uuid) returns boolean language sql stable security definer set search_path to '' as $$
  select public.is_central_admin() or exists (select 1 from public.profiles p where p.id = u and p.faculty_id is not null and public.admin_for(p.faculty_id)) $$;

create or replace function public.can_review_department(dept bigint) returns boolean language sql stable security definer set search_path to '' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid()
    and ((ur.role = 'responsable' and (ur.department_id = dept or (ur.department_id is null and (ur.faculty_id is null or ur.faculty_id = public.fac_of_dept(dept)))))
      or (ur.role = 'chef_departement' and ur.department_id = dept))) $$;

