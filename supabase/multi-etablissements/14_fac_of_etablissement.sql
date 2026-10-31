-- Audit F2 : les fonctions fac_of_* (et faculty_of_assignment) renvoyaient la faculté de n'importe quel élément,
-- même pour un compte connecté d'un autre établissement (fuite minime : un numéro de faculté).
-- Elles ne répondent plus que pour les facultés de l'établissement de travail de l'appelant.
-- Hors connexion (outils d'administration de la base, fonction manage-users), le comportement est inchangé.

create or replace function public.fac_in_scope(f bigint)
returns bigint language sql stable security definer set search_path = '' as $$
  select f where f is null or auth.uid() is null
    or exists (select 1 from public.faculties fa where fa.id = f and fa.establishment_id = public.current_establishment()) $$;
revoke all on function public.fac_in_scope(bigint) from public, anon, authenticated;

create or replace function public.fac_of_course(c bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select d.faculty_id from public.courses c2 join public.departments d on d.id = c2.department_id where c2.id = c)) $$;
create or replace function public.fac_of_dept(d bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select faculty_id from public.departments where id = d)) $$;
create or replace function public.fac_of_group(g bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select d.faculty_id from public.student_groups sg join public.programs p on p.id = sg.program_id join public.departments d on d.id = p.department_id where sg.id = g)) $$;
create or replace function public.fac_of_payslip(s bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select pp.faculty_id from public.payslips ps join public.pay_periods pp on pp.id = ps.pay_period_id where ps.id = s)) $$;
create or replace function public.fac_of_period(p bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select faculty_id from public.pay_periods where id = p)) $$;
create or replace function public.fac_of_program(p bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select d.faculty_id from public.programs p2 join public.departments d on d.id = p2.department_id where p2.id = p)) $$;
create or replace function public.fac_of_session(s bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select public.faculty_of_assignment(assignment_id) from public.schedule_sessions where id = s)) $$;
create or replace function public.fac_of_teacher(t bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select d.faculty_id from public.teachers t2 join public.departments d on d.id = t2.department_id where t2.id = t)) $$;
create or replace function public.faculty_of_assignment(p_asg bigint) returns bigint language sql stable security definer set search_path = '' as
$$ select public.fac_in_scope((select d.faculty_id from public.teaching_assignments ta join public.courses c on c.id = ta.course_id join public.departments d on d.id = c.department_id where ta.id = p_asg)) $$;
