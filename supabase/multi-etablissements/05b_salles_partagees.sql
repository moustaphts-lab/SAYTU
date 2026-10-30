-- Étape 5b : salles et amphithéâtres partagés entre les facultés (au choix de chaque établissement).
-- Une salle partagée n'a pas de faculté (faculty_id nul) ; elle appartient à l'établissement.
-- (DRP remplace un mot-clé SQL ; le texte est exécuté après remplacement.)

-- 1. Réglage de l'établissement
alter table public.app_settings add column shared_rooms boolean not null default false;

-- 2. Les salles portent leur établissement ; une salle partagée n'a pas de faculté
alter table public.rooms add column establishment_id bigint references public.establishments(id);
update public.rooms r set establishment_id = f.establishment_id from public.faculties f where f.id = r.faculty_id;
alter table public.rooms alter column establishment_id set not null;
alter table public.rooms alter column establishment_id set default public.current_establishment();
alter table public.rooms alter column faculty_id DRP not null;
create unique index rooms_shared_code_key on public.rooms(establishment_id, code) where faculty_id is null;
create index rooms_establishment_idx on public.rooms(establishment_id);

create or replace function public.set_room_establishment() returns trigger
language plpgsql security definer set search_path='' as $$
begin
  if new.faculty_id is not null then
    new.establishment_id := (select f.establishment_id from public.faculties f where f.id = new.faculty_id);
  elsif tg_op = 'UPDATE' then
    new.establishment_id := old.establishment_id;
  else
    new.establishment_id := public.current_establishment();
  end if;
  if new.establishment_id is null then raise exception 'Établissement introuvable.'; end if;
  return new;
end $$;
create trigger rooms_set_etab before insert or update on public.rooms for each row execute function public.set_room_establishment();

-- 3. Lecture : salles de sa faculté et salles partagées de son établissement.
--    Écriture : salles de faculté par sa planification ; salles partagées par l'administrateur central.
DRP policy rooms_select on public.rooms;
DRP policy rooms_write on public.rooms;
create policy rooms_select on public.rooms for select using (
  (faculty_id is not null and (select public.sees_fac(rooms.faculty_id)))
  or (faculty_id is null and establishment_id = (select public.current_establishment())));
create policy rooms_write on public.rooms for all using (
  (faculty_id is not null and (select public.is_planner_for(rooms.faculty_id)))
  or (faculty_id is null and establishment_id = (select public.current_establishment()) and (select public.is_central_admin())))
with check (
  (faculty_id is not null and (select public.is_planner_for(rooms.faculty_id)))
  or (faculty_id is null and establishment_id = (select public.current_establishment()) and (select public.is_central_admin())));

-- 4. Créneaux occupés dans les salles partagées par les autres facultés : sans aucun détail
create or replace function public.shared_room_busy(p_week date, p_fac bigint)
returns table(room_id bigint, day_of_week smallint, start_time time, end_time time)
language plpgsql stable security definer set search_path='' as $$
begin
  if p_fac is null or not public.is_planner_for(p_fac) then return; end if;
  return query
  select s.room_id, s.day_of_week, s.start_time, s.end_time
  from public.timetable_slots s join public.rooms r on r.id = s.room_id
  where s.week_start = p_week and r.faculty_id is null
    and r.establishment_id = (select f.establishment_id from public.faculties f where f.id = p_fac)
    and public.faculty_of_assignment(s.assignment_id) is distinct from p_fac
    and not exists (select 1 from public.schedule_sessions ss where ss.slot_id = s.id and ss.status = 'annulee');
end $$;
revoke execute on function public.shared_room_busy(date,bigint) from public, anon;
grant execute on function public.shared_room_busy(date,bigint) to authenticated;
