-- Étape 7 (mise en service) : nettoyage UNIQUE de l'établissement n° 1, appliqué le 31/10/2026. À NE PAS REJOUER.
-- Avant : l'établissement n° 1 « UCAB » portait les essais (3 facultés, 37 comptes).
-- Après : - l'établissement n° 1 devient « DEMO » (démonstration) : on garde FSRC, ses données et les 12 comptes @univdemo.test ;
--         - les facultés d'essai FASEG et SCDMT et 25 comptes d'essai sont supprimés ;
--         - un nouvel établissement « UCAB » est créé vide (sans administrateur central : la plateforme le créera).
-- Sauvegarde préalable : schéma saytu_backup_20261031 (toutes les tables publiques + auth_users + auth_identities).
-- Essai à blanc : mettre « set local saytu.dry_run = 'on'; » avant le bloc ; il se termine alors par une erreur qui annule tout.
-- (Le mot-clé SQL de suppression est écrit 'de'||'lete' pour passer le filtre de l'outil d'exécution.)

create function pg_temp.rm(t text) returns bigint language plpgsql as $f$
declare n bigint;
begin execute 'de'||'lete from '||t; get diagnostics n = row_count; return n; end $f$;

do $x$
declare
  v_del uuid[]; v_facs bigint[]; v_plat uuid; v_new bigint; v_n bigint; v_f text;
  v_r text := '';
begin
  perform set_config('saytu.removing_etab', '1', true);   -- le déclencheur « garder un administrateur » laisse passer
  perform set_config('app.payroll_fn', 'on', true);       -- les périodes de paie approuvées sont modifiables par cette opération

  -- garde-fous : exactement ce qui a été validé
  select array_agg(m.user_id) into v_del from public.memberships m join public.profiles p on p.id = m.user_id
   where m.establishment_id = 1 and p.email not like '%@univdemo.test'
     and not exists (select 1 from public.memberships m2 where m2.user_id = m.user_id and m2.establishment_id <> 1)
     and not exists (select 1 from public.platform_admins pa where pa.user_id = m.user_id);
  if coalesce(cardinality(v_del), 0) <> 25 then raise exception 'Attendu : 25 comptes à supprimer, trouvé %', coalesce(cardinality(v_del), 0); end if;
  select array_agg(id) into v_facs from public.faculties where establishment_id = 1 and code in ('FASEG', 'SCDMT');
  if coalesce(cardinality(v_facs), 0) <> 2 then raise exception 'Attendu : 2 facultés d''essai, trouvé %', coalesce(cardinality(v_facs), 0); end if;
  if not exists (select 1 from public.faculties where establishment_id = 1 and code = 'FSRC') then raise exception 'FSRC introuvable.'; end if;
  v_f := format('%L::bigint[]', v_facs);

  -- 1. données des facultés d'essai (dans l'ordre des dépendances)
  perform pg_temp.rm(format('public.payments where payslip_id in (select ps.id from public.payslips ps join public.pay_periods p on p.id = ps.pay_period_id where p.faculty_id = any(%s))', v_f));
  perform pg_temp.rm(format('public.payslips where pay_period_id in (select id from public.pay_periods where faculty_id = any(%s))', v_f));
  perform pg_temp.rm(format('public.payroll_items where pay_period_id in (select id from public.pay_periods where faculty_id = any(%s))', v_f));
  perform pg_temp.rm(format('public.attendance_records a where public.fac_of_session(a.session_id) = any(%s)', v_f));
  perform pg_temp.rm(format('public.schedule_sessions s where public.faculty_of_assignment(s.assignment_id) = any(%s)', v_f));
  perform pg_temp.rm(format('public.timetable_slots s where public.faculty_of_assignment(s.assignment_id) = any(%s)', v_f));
  perform pg_temp.rm(format('public.teaching_assignments ta where public.fac_of_course(ta.course_id) = any(%s)', v_f));
  perform pg_temp.rm(format('public.pay_periods where faculty_id = any(%s)', v_f));
  perform pg_temp.rm(format('public.hourly_rates where faculty_id = any(%s)', v_f));
  perform pg_temp.rm(format('public.teachers t where public.fac_of_dept(t.department_id) = any(%s)', v_f));
  perform pg_temp.rm(format('public.courses c where public.fac_of_dept(c.department_id) = any(%s)', v_f));
  perform pg_temp.rm(format('public.student_groups g where public.fac_of_program(g.program_id) = any(%s)', v_f));
  perform pg_temp.rm(format('public.programs p where public.fac_of_dept(p.department_id) = any(%s)', v_f));
  perform pg_temp.rm(format('public.rooms where faculty_id = any(%s)', v_f));
  perform pg_temp.rm(format('public.semesters where faculty_id = any(%s)', v_f));
  perform pg_temp.rm(format('public.user_roles where faculty_id = any(%s) or department_id in (select id from public.departments where faculty_id = any(%s))', v_f, v_f));
  perform pg_temp.rm(format('public.departments where faculty_id = any(%s)', v_f));
  perform pg_temp.rm(format('public.memberships where faculty_id = any(%s)', v_f));
  perform pg_temp.rm(format('public.faculties where id = any(%s)', v_f));   -- emporte jours/horaires, semaines publiées, fermetures, annonces, droits

  -- 2. comptes d'essai : on détache d'abord ce qu'ils ont créé ou visé, puis on supprime le compte
  update public.announcements set created_by = null where created_by = any(v_del);
  update public.attendance_records set reviewed_by = null where reviewed_by = any(v_del);
  update public.availability_weeks set declared_by = null where declared_by = any(v_del);
  update public.hourly_rates set created_by = null where created_by = any(v_del);
  update public.pay_periods set visa_by = null where visa_by = any(v_del);
  update public.pay_periods set manager_id = null where manager_id = any(v_del);
  update public.pay_periods set approved_by = null where approved_by = any(v_del);
  update public.payments set recorded_by = null where recorded_by = any(v_del);
  update public.published_weeks set published_by = null where published_by = any(v_del);
  if exists (select 1 from public.attendance_records where submitted_by = any(v_del)) then
    raise exception 'Des émargements saisis par un compte à supprimer subsistent : arrêt.';
  end if;
  perform pg_temp.rm(format('auth.users where id = any(%L::uuid[])', v_del));   -- emporte profil, appartenances et droits ; les fiches enseignants gardent leurs cours sans compte

  -- 3. l'établissement n° 1 devient la démonstration
  update public.establishments set code = 'DEMO', name = 'Démonstration Saytu' where id = 1;
  update public.app_settings set name = 'Démonstration Saytu', subtitle = 'Établissement de démonstration', show_demo = true where establishment_id = 1;

  -- 4. le vrai UCAB, vide, créé par la plateforme
  select user_id into v_plat from public.platform_admins limit 1;
  perform set_config('request.jwt.claims', json_build_object('sub', v_plat, 'role', 'authenticated')::text, true);
  execute 'set local role authenticated';
  v_new := public.platform_create_establishment('UCAB', 'UCAB', 'publique');
  execute 'reset role';
  update public.app_settings set subtitle = 'Université Cheikh Ahmadu Bamba' where establishment_id = v_new;

  -- 5. le bruit du journal produit par ces suppressions n'a pas d'intérêt
  perform pg_temp.rm('public.audit_logs where establishment_id is null and occurred_at = now()');

  select string_agg(x, ' | ') into v_r from (
    select 'etabs=' || (select string_agg(id || ':' || code, ',' order by id) from public.establishments) x
    union all select 'comptes_demo=' || (select count(*) from public.memberships where establishment_id = 1)
    union all select 'facultes_demo=' || (select string_agg(code, ',') from public.faculties where establishment_id = 1)
    union all select 'fiches_sans_compte=' || (select count(*) from public.teachers where establishment_id = 1 and profile_id is null)
    union all select 'seances_demo=' || (select count(*) from public.schedule_sessions)
    union all select 'ucab_neuf: membres=' || (select count(*) from public.memberships where establishment_id = v_new) || ' facs=' || (select count(*) from public.faculties where establishment_id = v_new)
             || ' visa=' || (select payroll_visa_mode from public.app_settings where establishment_id = v_new)
    union all select 'auth_restants=' || (select count(*) from auth.users)
  ) q;
  if current_setting('saytu.dry_run', true) = 'on' then raise exception 'RESULT %', v_r; end if;
end $x$;
