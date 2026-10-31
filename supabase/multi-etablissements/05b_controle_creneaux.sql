-- Étape 5b, suite (etape5b_controle_creneaux) : à appliquer APRÈS 05b_salles_partagees.sql.
-- check_slot() : la salle doit être celle de la faculté ou une salle partagée de l'établissement ;
-- un conflit avec une autre faculté n'affiche aucun détail. Copie du SQL tel qu'appliqué.
do $mig$ declare d text; n text; begin
  d := pg_get_functiondef('public.check_slot()'::regprocedure);
  n := replace(d, 'select capacity, code, room_type into v_cap, v_room, v_rtype from public.rooms where id = new.room_id;',
'select capacity, code, room_type into v_cap, v_room, v_rtype from public.rooms where id = new.room_id;
  -- la salle est celle de la faculté du cours, ou une salle partagée de son établissement
  if not exists (select 1 from public.rooms r join public.faculties f on f.id = public.faculty_of_assignment(a.id)
                  where r.id = new.room_id and (r.faculty_id = f.id or (r.faculty_id is null and r.establishment_id = f.establishment_id))) then
    raise exception ''La salle % n''''est pas disponible pour cette faculté.'', v_room;
  end if;');
  if n = d then raise exception 'morceau 1 introuvable'; end if; d := n;
  n := replace(d, 'select s.id, s.room_id, ta.teacher_id, c.code course, s.start_time, s.end_time
      from', 'select s.id, s.room_id, ta.teacher_id, c.code course, s.start_time, s.end_time, public.faculty_of_assignment(s.assignment_id) fac
      from');
  if n = d then raise exception 'morceau 2 introuvable'; end if; d := n;
  n := replace(d, '    loop
      raise exception ''Conflit avec %', '    loop
      -- cours d''une autre faculté : aucun détail
      if o.fac is distinct from public.faculty_of_assignment(new.assignment_id) then
        raise exception ''Conflit de % à % : %.'', to_char(o.start_time,''HH24:MI''), to_char(o.end_time,''HH24:MI''),
          case when o.room_id = new.room_id then ''la salle est occupée par une autre faculté''
               when o.teacher_id = a.teacher_id then ''le professeur a un cours dans une autre faculté'' else ''un des groupes a déjà un cours'' end;
      end if;
      raise exception ''Conflit avec %');
  if n = d then raise exception 'morceau 3 introuvable'; end if;
  execute n;
end $mig$;
