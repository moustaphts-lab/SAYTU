-- Étape 4 : l'administrateur de la plateforme Saytu, la création d'établissements et les modèles de départ.
-- (DLT et DRP remplacent deux mots-clés SQL ; le texte est exécuté après remplacement.)

-- 1. Administrateurs de la plateforme : au-dessus des établissements, sans accès à leurs données
create table public.platform_admins(
  user_id uuid primary key references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.platform_admins enable row level security;  -- aucune règle : accessible seulement par les fonctions

create or replace function public.is_platform_admin() returns boolean
language sql stable security definer set search_path='' as $$
  select exists (select 1 from public.platform_admins where user_id = auth.uid()) $$;

-- un établissement désactivé n'est plus accessible à ses membres
create or replace function public.current_establishment() returns bigint
language sql stable security definer set search_path='' as $$
  select case when auth.uid() is null then
      (select e.id from public.establishments e where (select count(*) from public.establishments)=1)
    else coalesce(
      (select m.establishment_id from public.profiles p join public.memberships m
         on m.user_id=p.id and m.establishment_id=p.establishment_id and m.active
         join public.establishments e on e.id=m.establishment_id and e.active
        where p.id=auth.uid()),
      (select m.establishment_id from public.memberships m join public.establishments e on e.id=m.establishment_id and e.active
        where m.user_id=auth.uid() and m.active order by m.created_at, m.establishment_id limit 1))
    end $$;

-- 2. Liste des établissements : fiche et activité seulement (aucune donnée d'enseignement ni de paie)
create or replace function public.platform_establishments()
returns table(id bigint, code text, name text, active boolean, created_at timestamptz, comptes bigint, facultes bigint, administrateurs bigint, derniere_connexion timestamptz)
language plpgsql stable security definer set search_path='' as $$
begin
  if not public.is_platform_admin() then raise exception 'Réservé à l''administrateur de la plateforme.'; end if;
  return query
  select e.id, e.code, coalesce(nullif(s.name,''), e.name), e.active, e.created_at,
    (select count(*) from public.memberships m where m.establishment_id = e.id and m.active),
    (select count(*) from public.faculties f where f.establishment_id = e.id),
    (select count(*) from public.user_roles ur where ur.establishment_id = e.id and ur.role = 'admin' and ur.faculty_id is null),
    (select max(u.last_sign_in_at) from public.memberships m join auth.users u on u.id = m.user_id where m.establishment_id = e.id)
  from public.establishments e left join public.app_settings s on s.establishment_id = e.id
  order by e.id;
end $$;

-- 3. Nouvel établissement, avec un modèle de départ (postes, statuts, droits optionnels)
create or replace function public.platform_create_establishment(p_code text, p_name text, p_model text) returns bigint
language plpgsql security definer set search_path='' as $$
declare e bigint; v_code text := upper(trim(p_code)); nm text := trim(p_name);
begin
  if not public.is_platform_admin() then raise exception 'Réservé à l''administrateur de la plateforme.'; end if;
  if v_code !~ '^[A-Z0-9][A-Z0-9-]{1,19}$' then raise exception 'Code invalide (2 à 20 lettres ou chiffres, sans espace).'; end if;
  if nm = '' then raise exception 'Le nom est obligatoire.'; end if;
  if p_model not in ('publique','privee','ecole') then raise exception 'Modèle inconnu.'; end if;
  if exists (select 1 from public.establishments where upper(establishments.code) = v_code) then raise exception 'Ce code d''établissement existe déjà.'; end if;
  insert into public.establishments(code, name) values (v_code, nm) returning id into e;
  insert into public.app_settings(establishment_id, name, subtitle, enabled_rights, show_demo)
    values (e, nm, 'Enseignements', case p_model when 'publique' then '{chef_departement,caissier,lecteur}'::text[] else '{caissier}'::text[] end, false);

  if p_model = 'publique' then
    insert into public.teacher_statuses(code, label, establishment_id) values
      ('VAC','Vacataire',e),('MA','Maître-assistant',e),('MC','Maître de conférences',e),('PR','Professeur titulaire',e);
    insert into public.postes(name, roles, scope, sort, establishment_id) values
      ('Rectorat','{direction}','universite',5,e),
      ('Professeur','{professeur}','faculte',10,e),
      ('Directeur des études','{planificateur}','faculte',20,e),
      ('Secrétaire','{planificateur,responsable}','faculte',30,e),
      ('Aide du responsable financier','{responsable}','faculte',40,e),
      ('Représentant financier','{finance}','faculte',50,e),
      ('Responsable financier de l''université','{finance}','universite',52,e),
      ('Doyen','{direction}','faculte',60,e),
      ('Administrateur central','{admin}','universite',70,e),
      ('Administrateur de faculté','{admin}','faculte',72,e),
      ('Chef de département','{chef_departement}','faculte',80,e),
      ('Caissier','{caissier}','faculte',90,e),
      ('Contrôleur (consultation)','{lecteur}','universite',95,e);
  elsif p_model = 'privee' then
    insert into public.teacher_statuses(code, label, establishment_id) values
      ('VAC','Vacataire',e),('PERM','Permanent',e);
    insert into public.postes(name, roles, scope, sort, establishment_id) values
      ('Direction générale','{direction}','universite',5,e),
      ('Professeur','{professeur}','faculte',10,e),
      ('Directeur pédagogique','{planificateur}','faculte',20,e),
      ('Secrétaire','{planificateur,responsable}','faculte',30,e),
      ('Comptable','{finance}','faculte',50,e),
      ('Responsable administratif et financier','{finance}','universite',52,e),
      ('Directeur d''école','{direction}','faculte',60,e),
      ('Administrateur central','{admin}','universite',70,e),
      ('Administrateur de faculté','{admin}','faculte',72,e),
      ('Caissier','{caissier}','faculte',90,e);
  else
    insert into public.teacher_statuses(code, label, establishment_id) values
      ('VAC','Vacataire',e),('PERM','Permanent',e);
    insert into public.postes(name, roles, scope, sort, establishment_id) values
      ('Direction','{direction}','universite',5,e),
      ('Professeur','{professeur}','faculte',10,e),
      ('Directeur des études','{planificateur}','faculte',20,e),
      ('Secrétaire','{planificateur,responsable}','faculte',30,e),
      ('Comptable','{finance}','faculte',50,e),
      ('Administrateur central','{admin}','universite',70,e),
      ('Caissier','{caissier}','faculte',90,e);
    -- une école sans facultés : l'établissement est sa propre et unique « faculté »
    insert into public.faculties(code, name, establishment_id) values (v_code, nm, e);
  end if;
  return e;
end $$;

create or replace function public.platform_set_active(p_id bigint, p_active boolean) returns void
language plpgsql security definer set search_path='' as $$
begin
  if not public.is_platform_admin() then raise exception 'Réservé à l''administrateur de la plateforme.'; end if;
  update public.establishments set active = p_active where id = p_id;
  if not found then raise exception 'Établissement introuvable.'; end if;
end $$;

-- premier administrateur central : appelée par la fonction de gestion des comptes, après création du compte
create or replace function public.platform_attach_admin(p_etab bigint, p_user uuid) returns void
language plpgsql security definer set search_path='' as $$
declare po bigint;
begin
  if not public.is_platform_admin() then raise exception 'Réservé à l''administrateur de la plateforme.'; end if;
  select id into po from public.postes where establishment_id = p_etab and scope = 'universite' and roles = '{admin}' order by sort limit 1;
  insert into public.memberships(user_id, establishment_id, poste_id) values (p_user, p_etab, po)
    on conflict (user_id, establishment_id) do update set poste_id = excluded.poste_id, active = true;
  insert into public.user_roles(user_id, role, faculty_id, establishment_id) values (p_user, 'admin', null, p_etab) on conflict do nothing;
end $$;

revoke execute on function public.is_platform_admin(), public.platform_establishments(), public.platform_create_establishment(text,text,text),
  public.platform_set_active(bigint,boolean), public.platform_attach_admin(bigint,uuid) from public;
grant execute on function public.is_platform_admin(), public.platform_establishments(), public.platform_create_establishment(text,text,text),
  public.platform_set_active(bigint,boolean), public.platform_attach_admin(bigint,uuid) to authenticated;
