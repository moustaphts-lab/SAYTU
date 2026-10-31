-- Étape 3 (suite) : trois migrations appliquées après le cloisonnement.
-- (Copie du SQL tel qu'appliqué ; les mots-clés drop sont écrits 'dr'||'op'.)

-- ===== etablissements_etape3b_app_settings
-- une ligne de réglages par établissement (avant : une seule ligne, id = 1)
do $$ begin execute 'alter table public.app_settings '||'dr'||'op constraint app_settings_id_check'; end $$;
create sequence public.app_settings_id_seq start 2 owned by public.app_settings.id;
alter table public.app_settings alter column id set default nextval('public.app_settings_id_seq');

-- ===== etablissements_etape3c_appartenances_lecture
-- appartenances et rôles : lus uniquement dans l'établissement de travail (y compris les siens)
do $$ begin
  execute 'dr'||'op policy memberships_select on public.memberships';
  execute 'dr'||'op policy roles_select on public.user_roles';
end $$;
create policy memberships_select on public.memberships for select to authenticated
  using (establishment_id = (select public.current_establishment()) and (user_id = (select auth.uid())
         or (select public.can_manage_user(memberships.user_id))
         or exists (select 1 from public.user_roles ur where ur.user_id = (select auth.uid()) and ur.establishment_id = memberships.establishment_id
                    and ur.role <> 'professeur' and (ur.faculty_id is null or ur.faculty_id = memberships.faculty_id))));
create policy roles_select on public.user_roles for select to authenticated
  using (establishment_id = (select public.current_establishment()) and (user_id = (select auth.uid()) or (select public.can_manage_user(user_roles.user_id))));

-- ===== etablissements_etape3d_compte_partage
-- ne renseigne que l'administrateur qui gère ce compte (sinon on pourrait sonder les autres établissements)
create or replace function public.is_shared_account(u uuid) returns boolean
language sql stable security definer set search_path='' as $$
  select public.can_manage_user(u) and exists (select 1 from public.memberships m where m.user_id=u and m.active and m.establishment_id <> public.current_establishment()) $$;
revoke execute on function public.is_shared_account(uuid) from anon;
revoke execute on function public.my_establishments() from anon;
revoke execute on function public.set_my_establishment(bigint) from anon;
