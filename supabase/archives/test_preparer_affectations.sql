-- UCAB Touba : préparer un test complet « affectations → emploi du temps → publication »
-- À exécuter dans Supabase > SQL Editor (une seule transaction : tout ou rien).
-- (Si l'alerte RLS apparaît : « Run without RLS ».)
--
-- EFFACE  : affectations, créneaux, séances, semaines publiées, disponibilités (aucun émargement n'existe encore).
-- GARDE   : départements, filières, groupes, 60 matières (rattachées à leur filière), 14 enseignants,
--           comptes, salles, semestres, jours et horaires.
-- CRÉE    : des disponibilités pour la semaine du 2 au 6 novembre 2026, pour 10 enseignants sur 14.
--           4 enseignants restent SANS réponse pour tester ce cas :
--           Fall (compte awa.ndiaye@univdemo.test : il peut se connecter et répondre lui-même),
--           Thiam (compte alioune.thiam.hist@ucab.test), Kane et Seck.

begin;

delete from public.schedule_sessions;
delete from public.timetable_slots;
delete from public.published_weeks;
delete from public.teaching_assignments;
delete from public.teacher_availability;
delete from public.availability_weeks;

-- Disponibilités de la semaine du 2 novembre : 2 ou 3 jours par enseignant, matin (8 h–12 h) et après-midi (14 h–18 h)
create temp table _t on commit drop as
  select t.id, row_number() over (order by t.id) as i
    from public.teachers t
   where t.active and t.last_name not in ('Fall','Thiam','Kane','Seck');

insert into public.teacher_availability(teacher_id, week_start, day_of_week, start_time, end_time)
  select t.id, date '2026-11-02', d.day, h.s, h.e
    from _t t
    cross join lateral (values ((t.i % 5) + 1), (((t.i + 2) % 5) + 1), (case when t.i % 2 = 0 then ((t.i + 4) % 5) + 1 end)) d(day)
    cross join (values (time '08:00', time '12:00'), (time '14:00', time '18:00')) h(s, e)
   where d.day is not null;

insert into public.availability_weeks(teacher_id, week_start, by_planner)
  select id, date '2026-11-02', true from _t;

commit;

-- Contrôle
select (select count(*) from public.teaching_assignments) as affectations,
       (select count(*) from public.timetable_slots) as creneaux,
       (select count(*) from public.availability_weeks) as enseignants_ayant_repondu,
       (select count(*) from public.teacher_availability) as plages_disponibles;
