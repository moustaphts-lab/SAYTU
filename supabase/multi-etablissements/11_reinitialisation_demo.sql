-- Audit M5 : remise à zéro de l'établissement de démonstration (DEMO).
-- Le mot de passe de DEMO est public : un visiteur peut modifier ou supprimer des données.
-- Ce script crée, dans un schéma privé (jamais exposé à l'application), :
--   * saytu_demo_ref.snap            : copie de référence des données de DEMO (une ligne par table)
--   * saytu_demo_ref.take_snapshot() : enregistre l'état actuel de DEMO comme référence
--   * saytu_demo_ref.reset_demo()    : remet DEMO exactement dans l'état de référence (en une seule transaction)
-- Les comptes (e-mails, mots de passe, nom, langue) sont aussi remis comme à la référence.
-- Aucun accès pour l'application ni pour les visiteurs : seul le propriétaire de la base peut les appeler
-- (par exemple depuis l'éditeur SQL de Supabase, ou plus tard depuis pg_cron).
-- Usage :  select saytu_demo_ref.take_snapshot();   -- fixer la référence (après avoir préparé DEMO)
--          select saytu_demo_ref.reset_demo();      -- remettre DEMO à la référence

create schema if not exists saytu_demo_ref;
revoke all on schema saytu_demo_ref from public, anon, authenticated;

create table if not exists saytu_demo_ref.snap (
  tbl text primary key,
  rows jsonb not null,
  taken_at timestamptz not null default now()
);
alter table saytu_demo_ref.snap enable row level security;
revoke all on saytu_demo_ref.snap from public, anon, authenticated;

-- Tables de DEMO, des parents vers les enfants, avec la condition qui sélectionne les lignes de l'établissement e
create or replace function saytu_demo_ref._scopes(e bigint)
returns table(ord int, tbl text, scope text)
language plpgsql set search_path = '' as $$
declare
  f   text := format('faculty_id in (select id from public.faculties where establishment_id=%s)', e);
  crs text := format('select id from public.courses where establishment_id=%s', e);
  ta  text := format('select id from public.teaching_assignments where course_id in (%s)', crs);
  tch text := format('select id from public.teachers where establishment_id=%s', e);
  grp text := format('select id from public.student_groups where establishment_id=%s', e);
  rm  text := format('select id from public.rooms where establishment_id=%s', e);
  slt text;
  ses text;
  pp  text := format('select id from public.pay_periods where %s', f);
  psl text := format('select id from public.payslips where establishment_id=%s', e);
begin
  slt := format('select id from public.timetable_slots where assignment_id in (%s) or room_id in (%s)', ta, rm);
  ses := format('select id from public.schedule_sessions where teacher_id in (%s) or group_id in (%s) or room_id in (%s) or assignment_id in (%s) or slot_id in (%s)', tch, grp, rm, ta, slt);
  return query select * from (values
    ( 1, 'academic_years',       format('establishment_id=%s', e)),
    ( 2, 'faculties',            format('establishment_id=%s', e)),
    ( 3, 'teacher_statuses',     format('establishment_id=%s', e)),
    ( 4, 'postes',               format('establishment_id=%s', e)),
    ( 5, 'departments',          format('establishment_id=%s', e)),
    ( 6, 'programs',             format('establishment_id=%s', e)),
    ( 7, 'rooms',                format('establishment_id=%s', e)),
    ( 8, 'student_groups',       format('establishment_id=%s', e)),
    ( 9, 'courses',              format('establishment_id=%s', e)),
    (10, 'course_programs',      format('course_id in (%s)', crs)),
    (11, 'teachers',             format('establishment_id=%s', e)),
    (12, 'semesters',            f),
    (13, 'school_schedule',      f),
    (14, 'hourly_rates',         f),
    (15, 'teaching_assignments', format('course_id in (%s)', crs)),
    (16, 'assignment_groups',    format('assignment_id in (%s)', ta)),
    (17, 'timetable_slots',      format('id in (%s)', slt)),
    (18, 'schedule_sessions',    format('id in (%s)', ses)),
    (19, 'absence_requests',     format('session_id in (%s)', ses)),
    (20, 'pay_periods',          f),
    (21, 'attendance_records',   format('session_id in (%s) or teacher_id in (%s)', ses, tch)),
    (22, 'payroll_items',        format('pay_period_id in (%s)', pp)),
    (23, 'payslips',             format('establishment_id=%s', e)),
    (24, 'payments',             format('payslip_id in (%s)', psl)),
    (25, 'availability_weeks',   format('teacher_id in (%s)', tch)),
    (26, 'teacher_availability', format('teacher_id in (%s)', tch)),
    (27, 'published_weeks',      f),
    (28, 'announcements',        format('establishment_id=%s', e)),
    (29, 'calendar_closures',    format('establishment_id=%s', e)),
    (30, 'memberships',          format('establishment_id=%s', e)),
    (31, 'user_roles',           format('establishment_id=%s', e)),
    (32, 'app_settings',         format('establishment_id=%s', e))
  ) v(ord, tbl, scope);
end $$;

-- Enregistre l'état actuel de DEMO comme état de référence
create or replace function saytu_demo_ref.take_snapshot()
returns text
language plpgsql security definer set search_path = '' as $$
declare e bigint; n int; r record; j jsonb; total int := 0; uids uuid[];
begin
  select count(*) into n from public.establishments where demo;
  if n <> 1 then raise exception 'Il doit y avoir exactement un établissement de démonstration (trouvé : %).', n; end if;
  select id into e from public.establishments where demo;
  select coalesce(array_agg(user_id), '{}') into uids from public.memberships where establishment_id = e;
  execute 'de' || 'lete from saytu_demo_ref.snap';
  for r in select * from saytu_demo_ref._scopes(e) order by ord loop
    execute format('select coalesce(jsonb_agg(to_jsonb(t)), ''[]''::jsonb) from public.%I t where %s', r.tbl, r.scope) into j;
    insert into saytu_demo_ref.snap(tbl, rows) values (r.tbl, j);
    total := total + jsonb_array_length(j);
  end loop;
  select coalesce(jsonb_agg(to_jsonb(t)), '[]'::jsonb) into j from public.audit_logs t where establishment_id = e;
  insert into saytu_demo_ref.snap(tbl, rows) values ('audit_logs', j);
  select coalesce(jsonb_agg(to_jsonb(p)), '[]'::jsonb) into j from public.profiles p where p.id = any(uids);
  insert into saytu_demo_ref.snap(tbl, rows) values ('_profiles', j);
  select coalesce(jsonb_agg(jsonb_build_object('id', u.id, 'encrypted_password', u.encrypted_password)), '[]'::jsonb) into j from auth.users u where u.id = any(uids);
  insert into saytu_demo_ref.snap(tbl, rows) values ('_auth', j);
  return format('Référence enregistrée : %s lignes dans %s tables, %s comptes.', total, (select count(*) from saytu_demo_ref._scopes(e)), coalesce(array_length(uids,1),0));
end $$;

-- Remet DEMO dans l'état de référence (tout ou rien)
create or replace function saytu_demo_ref.reset_demo()
returns text
language plpgsql security definer set search_path = '' as $$
declare e bigint; n int; r record; j jsonb; tbls text[]; t text; removed int := 0; added int := 0; c int;
begin
  select count(*) into n from public.establishments where demo;
  if n <> 1 then raise exception 'Il doit y avoir exactement un établissement de démonstration (trouvé : %).', n; end if;
  select id into e from public.establishments where demo;
  if (select count(*) from saytu_demo_ref.snap) = 0 then raise exception 'Aucune référence enregistrée : lancez d''abord take_snapshot().'; end if;

  select array_agg(s.tbl order by s.ord) into tbls from saytu_demo_ref._scopes(e) s;
  -- les règles propres à chaque table (journal, protections de paie approuvée...) sont suspendues le temps de la remise à zéro
  -- (les contraintes de clés étrangères restent actives)
  foreach t in array tbls loop
    execute format('alter table public.%I disable trigger user', t);
  end loop;

  -- 1. suppression des lignes de DEMO, des enfants vers les parents
  for r in select * from saytu_demo_ref._scopes(e) order by ord desc loop
    execute format('de' || 'lete from public.%I where %s', r.tbl, r.scope);
    get diagnostics c = row_count; removed := removed + c;
  end loop;
  -- 2. réinsertion de la référence, des parents vers les enfants, avec les mêmes numéros
  for r in select * from saytu_demo_ref._scopes(e) order by ord loop
    select rows into j from saytu_demo_ref.snap where tbl = r.tbl;
    if j is null then raise exception 'Référence incomplète pour %.', r.tbl; end if;
    execute format('insert into public.%I overriding system value select * from jsonb_populate_recordset(null::public.%I, $1)', r.tbl, r.tbl) using j;
    get diagnostics c = row_count; added := added + c;
  end loop;

  foreach t in array tbls loop
    execute format('alter table public.%I enable trigger user', t);
  end loop;

  -- 3. comptes : nom, langue, obligation de changer le mot de passe, mot de passe
  select rows into j from saytu_demo_ref.snap where tbl = '_profiles';
  update public.profiles p set full_name = x.full_name, lang = x.lang, must_change_password = x.must_change_password
    from jsonb_populate_recordset(null::public.profiles, j) x where p.id = x.id;
  select rows into j from saytu_demo_ref.snap where tbl = '_auth';
  update auth.users u set encrypted_password = x.encrypted_password
    from jsonb_to_recordset(j) x(id uuid, encrypted_password text)
    where u.id = x.id and u.encrypted_password is distinct from x.encrypted_password;

  -- 4. journal : remis comme à la référence (les opérations de la remise à zéro n'y laissent pas de trace)
  execute format('de' || 'lete from public.audit_logs where establishment_id = %s', e);
  select rows into j from saytu_demo_ref.snap where tbl = 'audit_logs';
  insert into public.audit_logs overriding system value select * from jsonb_populate_recordset(null::public.audit_logs, j);

  return format('DEMO remis à la référence du %s : %s lignes retirées, %s lignes rétablies.',
    to_char((select max(taken_at) from saytu_demo_ref.snap), 'DD/MM/YYYY HH24:MI'), removed, added);
end $$;

revoke all on function saytu_demo_ref._scopes(bigint) from public, anon, authenticated;
revoke all on function saytu_demo_ref.take_snapshot() from public, anon, authenticated;
revoke all on function saytu_demo_ref.reset_demo() from public, anon, authenticated;
