-- Postes configurables (attribution, création, suppression), droits optionnels, et nettoyage des anciennes fonctions.
-- À exécuter une fois dans Supabase > SQL Editor.

create or replace function public.admin_assign_poste(p_user uuid, p_poste bigint, p_dep bigint, p_teaches boolean) returns void
language plpgsql security definer set search_path to '' as $$
declare pr text[]; r text; en text[];
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  select roles into pr from public.postes where id = p_poste;
  if pr is null then raise exception 'Poste introuvable.'; end if;
  select enabled_rights into en from public.app_settings where id = 1;
  foreach r in array pr loop
    if r in ('chef_departement','caissier','lecteur') and not (r = any(coalesce(en,'{}'))) then
      raise exception 'Ce poste utilise un droit désactivé dans Établissement.'; end if;
  end loop;
  if 'chef_departement' = any(pr) and p_dep is null then raise exception 'Choisissez le département du chef de département.'; end if;
  if p_user = auth.uid() and not ('admin' = any(pr)) then raise exception 'Vous ne pouvez pas retirer votre propre rôle d''administrateur.'; end if;
  delete from public.user_roles where user_id = p_user;
  foreach r in array pr loop
    insert into public.user_roles(user_id, role, department_id)
      values (p_user, r::public.app_role, case when r in ('responsable','chef_departement') then p_dep else null end)
      on conflict do nothing;
  end loop;
  if p_teaches and not ('professeur' = any(pr)) then
    insert into public.user_roles(user_id, role, department_id) values (p_user, 'professeur', null) on conflict do nothing;
  end if;
  update public.profiles set poste_id = p_poste where id = p_user;
end $$;

create or replace function public.admin_save_poste(p_id bigint, p_name text, p_roles text[]) returns int
language plpgsql security definer set search_path to '' as $$
declare old text[]; pid bigint; u record; n int := 0; dep bigint;
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  if coalesce(cardinality(p_roles),0) = 0 then raise exception 'Cochez au moins un droit.'; end if;
  if exists (select 1 from unnest(p_roles) x where x not in ('professeur','planificateur','responsable','finance','direction','admin','chef_departement','caissier','lecteur')) then raise exception 'Droit inconnu.'; end if;
  if p_id is null then
    insert into public.postes(name, roles) values (trim(p_name), p_roles) returning id into pid; return 0;
  end if;
  select roles into old from public.postes where id = p_id;
  if old is null then raise exception 'Poste introuvable.'; end if;
  update public.postes set name = trim(p_name), roles = p_roles where id = p_id;
  if (select array_agg(x order by x) from unnest(old) x) is distinct from (select array_agg(x order by x) from unnest(p_roles) x) then
    for u in select id from public.profiles where poste_id = p_id loop
      select department_id into dep from public.user_roles where user_id = u.id and role in ('responsable','chef_departement') and department_id is not null limit 1;
      if u.id = auth.uid() and not ('admin' = any(p_roles)) then raise exception 'Ce changement retirerait votre propre rôle d''administrateur.'; end if;
      delete from public.user_roles where user_id = u.id and role::text <> 'professeur';
      insert into public.user_roles(user_id, role, department_id)
        select u.id, x::public.app_role, case when x in ('responsable','chef_departement') then dep else null end from unnest(p_roles) x where x <> 'professeur'
        on conflict do nothing;
      if 'professeur' = any(p_roles) then insert into public.user_roles(user_id, role) values (u.id,'professeur') on conflict do nothing; end if;
      n := n + 1;
    end loop;
  end if;
  return n;
end $$;

create or replace function public.admin_delete_poste(p_id bigint) returns void
language plpgsql security definer set search_path to '' as $$
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  if exists (select 1 from public.profiles where poste_id = p_id) then raise exception 'Ce poste est attribué : changez d''abord le poste des personnes concernées.'; end if;
  delete from public.postes where id = p_id;
end $$;

create or replace function public.admin_set_rights(p_rights text[]) returns void
language plpgsql security definer set search_path to '' as $$
begin
  if not public.has_role('admin') then raise exception 'Réservé à l''administrateur.'; end if;
  update public.app_settings set enabled_rights = coalesce(p_rights,'{}') where id = 1;
end $$;

revoke execute on function public.admin_assign_poste(uuid,bigint,bigint,boolean) from public, anon;
revoke execute on function public.admin_save_poste(bigint,text,text[]) from public, anon;
revoke execute on function public.admin_delete_poste(bigint) from public, anon;
revoke execute on function public.admin_set_rights(text[]) from public, anon;
grant execute on function public.admin_assign_poste(uuid,bigint,bigint,boolean) to authenticated;
grant execute on function public.admin_save_poste(bigint,text,text[]) to authenticated;
grant execute on function public.admin_delete_poste(bigint) to authenticated;
grant execute on function public.admin_set_rights(text[]) to authenticated;

-- nettoyage : anciennes fonctions remplacées (elles ne faisaient plus qu'afficher une erreur)
drop function if exists public.generate_sessions cascade;
drop function if exists public.save_availability cascade;
drop function if exists public.reset_availability cascade;

select 'Postes installés, anciennes fonctions retirées' as resultat;
