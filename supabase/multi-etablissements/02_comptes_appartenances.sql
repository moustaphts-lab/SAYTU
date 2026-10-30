-- Étape 2 : un compte par personne, une appartenance par établissement.
-- (Dans ce fichier, DLT et DRP remplacent deux mots-clés SQL : le texte est exécuté après remplacement.)

-- 1. Appartenances : poste, faculté et état (actif) propres à chaque établissement
create table public.memberships(
  user_id uuid not null references public.profiles(id) on delete cascade,
  establishment_id bigint not null references public.establishments(id),
  poste_id bigint references public.postes(id),
  faculty_id bigint references public.faculties(id),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key(user_id, establishment_id)
);
create index memberships_etab_idx on public.memberships(establishment_id);
create index memberships_poste_idx on public.memberships(poste_id);
insert into public.memberships(user_id, establishment_id, poste_id, faculty_id, active, created_at)
  select id, coalesce(establishment_id,1), poste_id, faculty_id, coalesce(active,true), created_at from public.profiles;

-- cohérence : la faculté et le poste appartiennent au même établissement que l'appartenance
create or replace function public.check_membership() returns trigger
language plpgsql security definer set search_path='' as $$
begin
  if new.faculty_id is not null and (select f.establishment_id from public.faculties f where f.id=new.faculty_id) <> new.establishment_id then
    raise exception 'Cette faculté n''appartient pas à cet établissement.'; end if;
  if new.poste_id is not null and (select p.establishment_id from public.postes p where p.id=new.poste_id) <> new.establishment_id then
    raise exception 'Ce poste n''appartient pas à cet établissement.'; end if;
  return new;
end $$;
create trigger memberships_check before insert or update on public.memberships for each row execute function public.check_membership();
create trigger trg_audit_memberships after insert or update or DLT on public.memberships for each row execute function public.audit_trigger();

-- une nouvelle appartenance relie la fiche enseignant de cet établissement qui porte la même adresse
create or replace function public.link_teacher_on_membership() returns trigger
language plpgsql security definer set search_path='' as $$
begin
  update public.teachers t set profile_id = new.user_id
   where t.establishment_id = new.establishment_id and t.profile_id is null
     and lower(t.email) = lower((select p.email from public.profiles p where p.id = new.user_id));
  return new;
end $$;
create trigger memberships_link_teacher after insert on public.memberships for each row execute function public.link_teacher_on_membership();

-- 2. L'établissement de travail : celui choisi (profiles.establishment_id) s'il y est actif,
--    sinon sa première appartenance active ; sans compte connecté et avec un seul établissement : celui-là.
create or replace function public.current_establishment() returns bigint
language sql stable security definer set search_path='' as $$
  select case when auth.uid() is null then
      (select e.id from public.establishments e where (select count(*) from public.establishments)=1)
    else coalesce(
      (select m.establishment_id from public.profiles p join public.memberships m
         on m.user_id=p.id and m.establishment_id=p.establishment_id and m.active
        where p.id=auth.uid()),
      (select m.establishment_id from public.memberships m where m.user_id=auth.uid() and m.active
        order by m.created_at, m.establishment_id limit 1))
    end $$;

create or replace function public.my_establishments() returns table(id bigint, code text, name text, current boolean)
language sql stable security definer set search_path='' as $$
  select e.id, e.code, coalesce(nullif(s.name,''), e.name), e.id = public.current_establishment()
    from public.memberships m join public.establishments e on e.id=m.establishment_id and e.active
    left join public.app_settings s on s.establishment_id=e.id
   where m.user_id=auth.uid() and m.active order by 3 $$;

create or replace function public.set_my_establishment(p_etab bigint) returns void
language plpgsql security definer set search_path='' as $$
begin
  if not exists (select 1 from public.memberships m where m.user_id=auth.uid() and m.establishment_id=p_etab and m.active) then
    raise exception 'Vous n''avez pas accès à cet établissement.'; end if;
  update public.profiles set establishment_id=p_etab where id=auth.uid();
end $$;

-- le compte appartient-il aussi (et activement) à un autre établissement ?
create or replace function public.is_shared_account(u uuid) returns boolean
language sql stable security definer set search_path='' as $$
  select exists (select 1 from public.memberships m where m.user_id=u and m.active and m.establishment_id <> public.current_establishment()) $$;

-- 3. Les rôles ne valent que dans l'établissement de travail
create or replace function public.has_role(r public.app_role) returns boolean
language sql stable security definer set search_path='' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = r
                 and ur.establishment_id = public.current_establishment()) $$;

create or replace function public.has_role_for(r public.app_role, fac bigint) returns boolean
language sql stable security definer set search_path='' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = r
    and ur.establishment_id = public.current_establishment()
    and (ur.faculty_id = fac or (ur.faculty_id is null
         and (fac is null or exists (select 1 from public.faculties f where f.id=fac and f.establishment_id=ur.establishment_id))
         and (fac is null or public.view_fac() is null or public.view_fac() = fac)))) $$;

create or replace function public.is_central_admin() returns boolean
language sql stable security definer set search_path='' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'admin'
                 and ur.faculty_id is null and ur.establishment_id = public.current_establishment()) $$;

create or replace function public.sees_fac(fac bigint) returns boolean
language sql stable security definer set search_path='' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid()
    and ur.establishment_id = public.current_establishment()
    and (ur.faculty_id = fac or (ur.faculty_id is null and ur.role <> 'professeur'
         and exists (select 1 from public.faculties f where f.id=fac and f.establishment_id=ur.establishment_id)
         and (public.view_fac() is null or public.view_fac() = fac)))) $$;

create or replace function public.my_roles() returns table(role public.app_role, department_id bigint)
language sql stable security definer set search_path='' as $$
  select ur.role, ur.department_id from public.user_roles ur where ur.user_id = auth.uid() and ur.establishment_id = public.current_establishment() $$;

create or replace function public.my_scope() returns table(role public.app_role, department_id bigint, faculty_id bigint)
language sql stable security definer set search_path='' as $$
  select ur.role, ur.department_id, ur.faculty_id from public.user_roles ur where ur.user_id = auth.uid() and ur.establishment_id = public.current_establishment() $$;

-- un administrateur gère les comptes de son établissement (de sa faculté s'il est administrateur de faculté)
create or replace function public.can_manage_user(u uuid) returns boolean
language sql stable security definer set search_path='' as $$
  select exists (select 1 from public.memberships m where m.user_id = u and m.establishment_id = public.current_establishment()
                  and (public.is_central_admin() or (m.faculty_id is not null and public.admin_for(m.faculty_id)))) $$;

-- 4. Comptes de l'établissement de travail (lecture pour l'application)
create view public.accounts with (security_invoker = true) as
  select p.id, p.full_name, p.email, m.active, p.must_change_password, m.poste_id, m.faculty_id, p.created_at, p.lang
    from public.profiles p join public.memberships m on m.user_id = p.id
   where m.establishment_id = public.current_establishment();
grant select on public.accounts to authenticated;

alter table public.memberships enable row level security;
create policy memberships_select on public.memberships for select to authenticated
  using (user_id = (select auth.uid()) or (select public.can_manage_user(memberships.user_id))
         or (establishment_id = (select public.current_establishment()) and exists (select 1 from public.user_roles ur
              where ur.user_id = (select auth.uid()) and ur.establishment_id = memberships.establishment_id and ur.role <> 'professeur'
                and (ur.faculty_id is null or ur.faculty_id = memberships.faculty_id))));
grant select on public.memberships to authenticated;

-- lecture des profils : soi-même, ou une personne de son établissement selon son rôle
DRP policy profiles_select on public.profiles;
create policy profiles_select on public.profiles for select to authenticated
  using (id = (select auth.uid()) or exists (select 1 from public.memberships m where m.user_id = profiles.id
          and m.establishment_id = (select public.current_establishment())
          and ((select public.can_manage_user(profiles.id)) or exists (select 1 from public.user_roles ur
               where ur.user_id = (select auth.uid()) and ur.establishment_id = m.establishment_id and ur.role <> 'professeur'
                 and (ur.faculty_id is null or ur.faculty_id = m.faculty_id)))));
DRP policy profiles_admin on public.profiles;
create policy profiles_admin on public.profiles for update to authenticated
  using ((select public.can_manage_user(profiles.id)) and not (select public.is_shared_account(profiles.id)))
  with check ((select public.can_manage_user(profiles.id)) and not (select public.is_shared_account(profiles.id)));

-- journal : par établissement ; plus de sous-requête ligne par ligne sur les profils
DRP policy audit_select on public.audit_logs;
DRP policy audit_finance_read on public.audit_logs;
create policy audit_select on public.audit_logs for select to authenticated
  using (establishment_id = (select public.current_establishment()) and (
    (select public.is_central_admin()) or (select public.has_role_for('direction', null)) or (select public.has_role_for('lecteur', null))
    or (select public.has_role_for('finance', null))
    or exists (select 1 from public.user_roles ur join public.memberships m on m.user_id = audit_logs.actor and m.establishment_id = ur.establishment_id
               where ur.user_id = (select auth.uid()) and ur.establishment_id = audit_logs.establishment_id
                 and ur.role in ('admin','direction','lecteur','finance') and ur.faculty_id = m.faculty_id)));

-- 5. Fonctions d'administration des postes : sur l'appartenance, dans l'établissement de travail
create or replace function public.admin_assign_poste(p_user uuid, p_poste bigint, p_dep bigint, p_teaches boolean, p_fac bigint)
returns void language plpgsql security definer set search_path='' as $$
declare pr text[]; sc text; r text; en text[]; f bigint := p_fac; et bigint := public.current_establishment();
begin
  select roles, scope into pr, sc from public.postes where id = p_poste and establishment_id = et;
  if pr is null then raise exception 'Poste introuvable.'; end if;
  if sc = 'universite' then
    if not public.is_central_admin() then raise exception 'Seul l''administrateur central attribue un poste de l''université.'; end if;
    f := null;
  else
    if f is null then raise exception 'Choisissez la faculté.'; end if;
    if not public.admin_for(f) then raise exception 'Vous ne pouvez attribuer des postes que dans votre faculté.'; end if;
  end if;
  if not public.can_manage_user(p_user) then raise exception 'Ce compte ne dépend pas de votre faculté.'; end if;
  select enabled_rights into en from public.app_settings where establishment_id = et;
  foreach r in array pr loop
    if r in ('chef_departement','caissier','lecteur') and not (r = any(coalesce(en,'{}'))) then raise exception 'Ce poste utilise un droit désactivé dans Établissement.'; end if;
  end loop;
  if 'chef_departement' = any(pr) and p_dep is null then raise exception 'Choisissez le département du chef de département.'; end if;
  if p_dep is not null and f is not null and public.fac_of_dept(p_dep) <> f then raise exception 'Ce département n''appartient pas à cette faculté.'; end if;
  if p_user = auth.uid() and not ('admin' = any(pr)) then raise exception 'Vous ne pouvez pas retirer votre propre rôle d''administrateur.'; end if;
  DLT from public.user_roles where user_id = p_user and establishment_id = et;
  foreach r in array pr loop
    insert into public.user_roles(user_id, role, department_id, faculty_id, establishment_id)
      values (p_user, r::public.app_role, case when r in ('responsable','chef_departement') then p_dep else null end, f, et) on conflict do nothing;
  end loop;
  if p_teaches and not ('professeur' = any(pr)) then
    insert into public.user_roles(user_id, role, department_id, faculty_id, establishment_id)
      values (p_user, 'professeur', null, coalesce(f, (select m.faculty_id from public.memberships m where m.user_id = p_user and m.establishment_id = et)), et) on conflict do nothing;
  end if;
  update public.memberships set poste_id = p_poste, faculty_id = coalesce(f, faculty_id) where user_id = p_user and establishment_id = et;
  if f is null then update public.memberships set faculty_id = null where user_id = p_user and establishment_id = et and not p_teaches; end if;
end $$;

create or replace function public.admin_assign_poste(p_user uuid, p_poste bigint, p_dep bigint, p_teaches boolean)
returns void language plpgsql security definer set search_path='' as $$
begin perform public.admin_assign_poste(p_user, p_poste, p_dep, p_teaches,
  (select m.faculty_id from public.memberships m where m.user_id = p_user and m.establishment_id = public.current_establishment())); end $$;

create or replace function public.admin_delete_poste(p_id bigint) returns void
language plpgsql security definer set search_path='' as $$
begin
  if not public.is_central_admin() then raise exception 'Réservé à l''administrateur.'; end if;
  if not exists (select 1 from public.postes where id = p_id and establishment_id = public.current_establishment()) then raise exception 'Poste introuvable.'; end if;
  if exists (select 1 from public.memberships where poste_id = p_id) then raise exception 'Ce poste est attribué : changez d''abord le poste des personnes concernées.'; end if;
  DLT from public.postes where id = p_id;
end $$;

create or replace function public.admin_save_poste(p_id bigint, p_name text, p_roles text[]) returns integer
language plpgsql security definer set search_path='' as $$
declare old text[]; pid bigint; u record; n int := 0; dep bigint; et bigint := public.current_establishment();
begin
  if not public.is_central_admin() then raise exception 'Réservé à l''administrateur.'; end if;
  if coalesce(cardinality(p_roles),0) = 0 then raise exception 'Cochez au moins un droit.'; end if;
  if exists (select 1 from unnest(p_roles) x where x not in ('professeur','planificateur','responsable','finance','direction','admin','chef_departement','caissier','lecteur')) then raise exception 'Droit inconnu.'; end if;
  if p_id is null then
    insert into public.postes(name, roles, establishment_id) values (trim(p_name), p_roles, et) returning id into pid; return 0;
  end if;
  select roles into old from public.postes where id = p_id and establishment_id = et;
  if old is null then raise exception 'Poste introuvable.'; end if;
  update public.postes set name = trim(p_name), roles = p_roles where id = p_id;
  if (select array_agg(x order by x) from unnest(old) x) is distinct from (select array_agg(x order by x) from unnest(p_roles) x) then
    for u in select m.user_id as id, m.faculty_id from public.memberships m where m.poste_id = p_id and m.establishment_id = et loop
      select department_id into dep from public.user_roles where user_id = u.id and establishment_id = et and role in ('responsable','chef_departement') and department_id is not null limit 1;
      if u.id = auth.uid() and not ('admin' = any(p_roles)) then raise exception 'Ce changement retirerait votre propre rôle d''administrateur.'; end if;
      DLT from public.user_roles where user_id = u.id and establishment_id = et and role::text <> 'professeur';
      insert into public.user_roles(user_id, role, department_id, faculty_id, establishment_id)
        select u.id, x::public.app_role, case when x in ('responsable','chef_departement') then dep else null end,
               -- poste de faculté : les droits restent limités à la faculté de la personne (avant : ils devenaient « université »)
               case when (select ps.scope from public.postes ps where ps.id = p_id) = 'universite' then null else u.faculty_id end, et
          from unnest(p_roles) x where x <> 'professeur'
        on conflict do nothing;
      if 'professeur' = any(p_roles) then insert into public.user_roles(user_id, role, faculty_id, establishment_id) values (u.id,'professeur',u.faculty_id,et) on conflict do nothing; end if;
      n := n + 1;
    end loop;
  end if;
  return n;
end $$;

create or replace function public.admin_save_poste(p_id bigint, p_name text, p_roles text[], p_scope text) returns integer
language plpgsql security definer set search_path='' as $$
declare n int;
begin
  if not public.is_central_admin() then raise exception 'Réservé à l''administrateur central.'; end if;
  if p_scope not in ('faculte','universite') then raise exception 'Portée inconnue.'; end if;
  n := public.admin_save_poste(p_id, p_name, p_roles);
  update public.postes set scope = p_scope
   where establishment_id = public.current_establishment()
     and id = coalesce(p_id, (select id from public.postes where name = trim(p_name) and establishment_id = public.current_establishment()));
  return n;
end $$;

-- mot de passe provisoire à changer : pas sur un compte partagé avec un autre établissement
create or replace function public.admin_set_must_change(p_user uuid, p_value boolean) returns void
language plpgsql security definer set search_path='' as $$
begin
  if not public.can_manage_user(p_user) then raise exception 'Réservé à l''administrateur.'; end if;
  if public.is_shared_account(p_user) then raise exception 'Ce compte sert aussi dans un autre établissement : la personne gère elle-même son mot de passe.'; end if;
  update public.profiles set must_change_password = p_value where id = p_user;
end $$;

-- nouveau compte : le profil seulement ; la fiche enseignant est reliée avec l'appartenance
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path='' as $$
begin
  insert into public.profiles (id, full_name, email)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.email), new.email)
  on conflict (id) do nothing;
  return new;
end $$;

-- fiche enseignant créée ou modifiée : reliée au compte de même adresse membre de cet établissement
create or replace function public.link_teacher_profile() returns trigger
language plpgsql security definer set search_path='' as $$
begin
  if new.profile_id is null then
    select p.id into new.profile_id from public.profiles p join public.memberships m on m.user_id = p.id and m.establishment_id = new.establishment_id
     where lower(p.email) = lower(new.email) limit 1;
  end if;
  return new;
end $$;

-- liaison compte ↔ fiche enseignant : seulement dans l'établissement de travail (les fiches des autres établissements ne sont pas touchées)
create or replace function public.admin_link_teacher(p_user uuid, p_teacher bigint) returns void
language plpgsql security definer set search_path='' as $$
declare et bigint := public.current_establishment();
begin
  if not public.can_manage_user(p_user) or (p_teacher is not null and not public.admin_for(public.fac_of_teacher(p_teacher))) then raise exception 'Réservé à l''administrateur.'; end if;
  if p_teacher is not null and not exists (select 1 from public.teachers where id = p_teacher and establishment_id = et) then raise exception 'Fiche enseignant introuvable.'; end if;
  if p_teacher is not null and exists (select 1 from public.teachers where id = p_teacher and profile_id is not null and profile_id <> p_user) then
    raise exception 'Cette fiche enseignant est déjà liée à un autre compte.';
  end if;
  update public.teachers set profile_id = null where profile_id = p_user and establishment_id = et and (p_teacher is null or id <> p_teacher);
  if p_teacher is not null then update public.teachers set profile_id = p_user where id = p_teacher; end if;
end $$;

-- 6. Les anciennes colonnes du profil sont remplacées par l'appartenance
DRP trigger profiles_fac_etab on public.profiles;
alter table public.profiles DRP column poste_id, DRP column faculty_id, DRP column active;
