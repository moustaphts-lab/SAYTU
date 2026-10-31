-- Étape 4b (etablissements_etape4b_admins_centraux) : administrateurs centraux vus par la plateforme.
-- Copie du SQL tel qu'appliqué.

-- administrateurs centraux d'un établissement (pour la plateforme : nom, adresse, dernière connexion seulement)
create or replace function public.platform_establishment_admins(p_etab bigint)
returns table(user_id uuid, full_name text, email text, last_sign_in_at timestamptz, active boolean)
language plpgsql stable security definer set search_path='' as $$
begin
  if not public.is_platform_admin() then raise exception 'Réservé à l''administrateur de la plateforme.'; end if;
  return query
  select p.id, p.full_name, p.email, u.last_sign_in_at, coalesce(m.active,false)
    from public.user_roles ur join public.profiles p on p.id = ur.user_id
    left join public.memberships m on m.user_id = ur.user_id and m.establishment_id = ur.establishment_id
    left join auth.users u on u.id = ur.user_id
   where ur.establishment_id = p_etab and ur.role = 'admin' and ur.faculty_id is null
   order by p.full_name;
end $$;
revoke execute on function public.platform_establishment_admins(bigint) from public;
grant execute on function public.platform_establishment_admins(bigint) to authenticated;

-- la plateforme peut-elle réinitialiser ce compte ? (administrateur central de cet établissement)
create or replace function public.platform_can_reset(p_etab bigint, p_user uuid) returns boolean
language sql stable security definer set search_path='' as $$
  select public.is_platform_admin() and exists (select 1 from public.user_roles ur
    where ur.user_id = p_user and ur.establishment_id = p_etab and ur.role = 'admin' and ur.faculty_id is null) $$;
revoke execute on function public.platform_can_reset(bigint,uuid) from public;
grant execute on function public.platform_can_reset(bigint,uuid) to authenticated;
