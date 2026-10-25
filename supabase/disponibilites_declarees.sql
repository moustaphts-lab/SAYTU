-- UCAB Touba : disponibilités déclarées
-- À exécuter une fois dans Supabase > SQL Editor.
--
-- Principe : teachers.availability_declared = true signifie que le professeur a rempli sa grille.
-- Les plages enregistrées font alors foi : aucune plage = indisponible toute la semaine.
-- false = rien déclaré : disponible partout.
--
-- (La colonne availability_declared existe déjà. Ce script ajoute les deux fonctions
--  qui enregistrent la grille en une seule opération.)

alter table public.teachers add column if not exists availability_declared boolean not null default false;
update public.teachers t
   set availability_declared = exists (select 1 from public.teacher_availability a where a.teacher_id = t.id)
 where availability_declared = false;

-- Enregistre toute la grille du professeur connecté (remplace ses plages) et marque « déclaré ».
create or replace function public.save_availability(p_ranges jsonb)
returns void language plpgsql security definer set search_path to '' as $$
declare v_teacher bigint := public.current_teacher_id();
begin
  if v_teacher is null then raise exception 'Aucun profil professeur associé à ce compte.'; end if;
  if not public.has_role('professeur') then raise exception 'Votre compte n''a pas le rôle Professeur.'; end if;
  if p_ranges is null or jsonb_typeof(p_ranges) <> 'array' then raise exception 'Plages invalides.'; end if;
  delete from public.teacher_availability where teacher_id = v_teacher;
  insert into public.teacher_availability(teacher_id, day_of_week, start_time, end_time)
    select v_teacher, (r->>'day')::int, (r->>'start')::time, (r->>'end')::time
      from jsonb_array_elements(p_ranges) r;
  update public.teachers set availability_declared = true where id = v_teacher;
end $$;

-- Efface les plages et revient à « rien déclaré » (disponible partout).
create or replace function public.reset_availability()
returns void language plpgsql security definer set search_path to '' as $$
declare v_teacher bigint := public.current_teacher_id();
begin
  if v_teacher is null then raise exception 'Aucun profil professeur associé à ce compte.'; end if;
  if not public.has_role('professeur') then raise exception 'Votre compte n''a pas le rôle Professeur.'; end if;
  delete from public.teacher_availability where teacher_id = v_teacher;
  update public.teachers set availability_declared = false where id = v_teacher;
end $$;

revoke all on function public.save_availability(jsonb) from public, anon;
revoke all on function public.reset_availability() from public, anon;
grant execute on function public.save_availability(jsonb) to authenticated;
grant execute on function public.reset_availability() to authenticated;
