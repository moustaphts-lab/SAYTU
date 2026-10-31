-- Étape 6 : circuit de paie configurable — qui vise la paie avant les paiements.
--   aucun         : pas de visa, les paiements suivent l'approbation du service financier
--   faculte       : visa du responsable de chaque faculté (doyen), activé faculté par faculté (UCAB, comme avant)
--   etablissement : visa de la direction de l'établissement (poste « Direction » au niveau de l'établissement)
-- Le reste du circuit ne change pas : validation manuelle des heures, calcul et approbation par le service financier.

alter table public.app_settings add column payroll_visa_mode text not null default 'faculte'
  constraint app_settings_payroll_visa_mode_check check (payroll_visa_mode in ('aucun','faculte','etablissement'));

-- la paie de cette faculté doit-elle être visée avant les paiements ?
create or replace function public.visa_required(p_fac bigint) returns boolean
language sql stable security definer set search_path='' as $$
  select case s.payroll_visa_mode when 'aucun' then false when 'etablissement' then true else f.payroll_visa end
  from public.faculties f join public.app_settings s on s.establishment_id = f.establishment_id
  where f.id = p_fac $$;

-- la personne connectée peut-elle viser la paie de cette faculté ?
create or replace function public.can_visa(p_fac bigint) returns boolean
language sql stable security definer set search_path='' as $$
  select coalesce((select case s.payroll_visa_mode
      when 'faculte' then exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'direction' and ur.faculty_id = f.id)
      when 'etablissement' then exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'direction'
                                         and ur.faculty_id is null and ur.establishment_id = f.establishment_id)
      else false end
    from public.faculties f join public.app_settings s on s.establishment_id = f.establishment_id where f.id = p_fac), false) $$;

revoke execute on function public.visa_required(bigint), public.can_visa(bigint) from public, anon;
grant execute on function public.visa_required(bigint), public.can_visa(bigint) to authenticated;
