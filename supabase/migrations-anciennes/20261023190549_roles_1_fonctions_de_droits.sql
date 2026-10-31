
-- Finance : seul le rôle finance gère la paie (l'administrateur n'y a plus accès)
create or replace function public.is_finance()
returns boolean language sql stable security definer set search_path = '' as $$
  select public.has_role('finance');
$$;
-- Lecture des données de paie : finance et direction (consultation)
create or replace function public.can_read_payroll()
returns boolean language sql stable security definer set search_path = '' as $$
  select public.has_role('finance') or public.has_role('direction');
$$;
-- Validation des heures : rôle responsable (par département ou pour tous)
create or replace function public.can_review_department(dept bigint)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.user_roles ur
    where ur.user_id = auth.uid() and ur.role = 'responsable'
      and (ur.department_id is null or ur.department_id = dept));
$$;
-- Référentiel et emplois du temps : rôle planificateur
create or replace function public.is_planner()
returns boolean language sql stable security definer set search_path = '' as $$
  select public.has_role('planificateur');
$$;
