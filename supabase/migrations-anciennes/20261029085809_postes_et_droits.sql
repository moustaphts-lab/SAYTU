
-- droits optionnels
alter table public.app_settings add column if not exists enabled_rights text[] not null default '{}';

create or replace function public.can_read_payroll() returns boolean language sql stable security definer set search_path to '' as $$
  select public.has_role('finance') or public.has_role('direction') or public.has_role('caissier') or public.has_role('lecteur'); $$;

create or replace function public.can_review_department(dept bigint) returns boolean language sql stable security definer set search_path to '' as $$
  select exists (select 1 from public.user_roles ur where ur.user_id = auth.uid()
    and ((ur.role = 'responsable' and (ur.department_id is null or ur.department_id = dept))
      or (ur.role = 'chef_departement' and ur.department_id = dept))); $$;

alter policy attendance_select on public.attendance_records using (
  (teacher_id = (select public.current_teacher_id())) or (select public.has_role('finance')) or (select public.has_role('direction')) or (select public.has_role('lecteur'))
  or (select public.is_planner()) or exists (select 1 from public.schedule_sessions s join public.teaching_assignments ta on ta.id = s.assignment_id join public.courses c on c.id = ta.course_id
    where s.id = attendance_records.session_id and public.can_review_department(c.department_id)));
alter policy audit_select on public.audit_logs using ((select public.has_role('admin')) or (select public.has_role('direction')) or (select public.has_role('lecteur')));
alter policy absence_requests_select on public.absence_requests using (
  (teacher_id = (select public.current_teacher_id())) or (select public.is_planner()) or (select public.has_role('direction')) or (select public.has_role('lecteur')));

-- postes : un nom donné à une combinaison de droits
create table public.postes(
  id bigint generated always as identity primary key,
  name text not null unique check (length(trim(name)) between 2 and 60),
  roles text[] not null check (cardinality(roles) > 0),
  sort int not null default 100,
  created_at timestamptz not null default now());
alter table public.postes enable row level security;
create policy postes_select on public.postes for select to authenticated using (true);
create trigger trg_audit_postes after insert or update or delete on public.postes for each row execute function public.audit_trigger();
insert into public.postes(name,roles,sort) values
 ('Professeur','{professeur}',10),('Directeur des études','{planificateur}',20),('Secrétaire','{planificateur,responsable}',30),
 ('Aide du responsable financier','{responsable}',40),('Responsable financier','{finance}',50),('Direction générale','{direction}',60),
 ('Administrateur','{admin}',70),('Chef de département','{chef_departement}',80),('Caissier','{caissier}',90),('Contrôleur (consultation)','{lecteur}',95);

alter table public.profiles add column if not exists poste_id bigint references public.postes(id) on delete set null;
-- comptes existants : le poste dont les droits correspondent (hors « professeur » quand la personne a aussi un autre droit)
update public.profiles pr set poste_id = p.id from public.postes p
 where pr.poste_id is null and (
   select coalesce(array_agg(distinct r.role::text order by r.role::text) filter (where r.role <> 'professeur'), '{}') from public.user_roles r where r.user_id = pr.id
 ) = (select array_agg(x order by x) from unnest(p.roles) x) and p.roles <> '{professeur}';
update public.profiles pr set poste_id = (select id from public.postes where roles = '{professeur}')
 where pr.poste_id is null and exists (select 1 from public.user_roles r where r.user_id = pr.id and r.role = 'professeur')
   and not exists (select 1 from public.user_roles r where r.user_id = pr.id and r.role <> 'professeur');

