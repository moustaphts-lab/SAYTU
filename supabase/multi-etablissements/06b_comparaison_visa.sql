-- Étape 6, suite (etape6_comparaison_visa) : à appliquer APRÈS 06_visa_paie.sql.
-- « Comparaison des facultés » tient compte du mode de visa de l'établissement. Copie du SQL tel qu'appliqué.
do $mig$ declare d text; n text; begin
  d := pg_get_functiondef('public.compare_faculties'::regproc);
  n := replace(d, 'select f.id, f.code, f.name, f.timetable_mode, f.payroll_visa, f.sort from public.faculties f',
                  'select f.id, f.code, f.name, f.timetable_mode, public.visa_required(f.id) payroll_visa, f.sort from public.faculties f');
  if n = d then raise exception 'morceau 1 introuvable'; end if; d := n;
  n := replace(d, 'where f.payroll_visa and pp.status', 'where public.visa_required(f.id) and pp.status');
  if n = d then raise exception 'morceau 2 introuvable'; end if;
  execute n;
end $mig$;
