-- UCAB Touba : disponibilités par semaine (à exécuter UNE fois dans Supabase > SQL Editor)
-- Le reste du passage aux semaines (colonnes, tables, publication, synchronisation des séances)
-- est déjà appliqué. Ce script ajoute les deux fonctions qui enregistrent la grille d'une semaine :
--  - le professeur pour lui-même, tant que la semaine n'est pas publiée ;
--  - le directeur des études pour n'importe quel professeur, à tout moment.

create or replace function public.save_week_availability(p_week date, p_ranges jsonb, p_teacher bigint default null)
returns void language plpgsql security definer set search_path to '' as $$
declare v_teacher bigint; v_planner boolean := false;
begin
  if p_week is null or extract(isodow from p_week) <> 1 then raise exception 'Semaine invalide.'; end if;
  if p_ranges is null or jsonb_typeof(p_ranges) <> 'array' then raise exception 'Plages invalides.'; end if;
  if p_teacher is null then
    v_teacher := public.current_teacher_id();
    if v_teacher is null or not public.has_role('professeur') then raise exception 'Aucun profil professeur associé à ce compte.'; end if;
    if exists (select 1 from public.published_weeks w where w.week_start = p_week) then
      raise exception 'L''emploi du temps de cette semaine est déjà publié : contactez le directeur des études pour modifier vos disponibilités.';
    end if;
  else
    if not public.is_planner() then raise exception 'Réservé au directeur des études.'; end if;
    v_teacher := p_teacher; v_planner := true;
  end if;
  delete from public.teacher_availability where teacher_id = v_teacher and week_start = p_week;
  insert into public.teacher_availability(teacher_id, week_start, day_of_week, start_time, end_time)
    select v_teacher, p_week, (r->>'day')::int, (r->>'start')::time, (r->>'end')::time from jsonb_array_elements(p_ranges) r;
  insert into public.availability_weeks(teacher_id, week_start, by_planner) values (v_teacher, p_week, v_planner)
    on conflict (teacher_id, week_start) do update set declared_at = now(), declared_by = auth.uid(), by_planner = excluded.by_planner;
end $$;

create or replace function public.clear_week_availability(p_week date, p_teacher bigint default null)
returns void language plpgsql security definer set search_path to '' as $$
declare v_teacher bigint;
begin
  if p_teacher is null then
    v_teacher := public.current_teacher_id();
    if v_teacher is null or not public.has_role('professeur') then raise exception 'Aucun profil professeur associé à ce compte.'; end if;
    if exists (select 1 from public.published_weeks w where w.week_start = p_week) then
      raise exception 'L''emploi du temps de cette semaine est déjà publié : contactez le directeur des études.';
    end if;
  else
    if not public.is_planner() then raise exception 'Réservé au directeur des études.'; end if;
    v_teacher := p_teacher;
  end if;
  delete from public.teacher_availability where teacher_id = v_teacher and week_start = p_week;
  delete from public.availability_weeks where teacher_id = v_teacher and week_start = p_week;
end $$;

revoke all on function public.save_week_availability(date, jsonb, bigint) from public, anon;
revoke all on function public.clear_week_availability(date, bigint) from public, anon;
grant execute on function public.save_week_availability(date, jsonb, bigint) to authenticated;
grant execute on function public.clear_week_availability(date, bigint) to authenticated;
