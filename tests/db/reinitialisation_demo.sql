-- Test de saytu_demo_ref.reset_demo() : à lancer dans l'éditeur SQL de Supabase.
-- Rien n'est conservé : le bloc se termine par une erreur volontaire qui annule tout.
-- Résultat attendu : « RESULT tables différentes: aucune | ... | profil ok: t | ... »
-- (Les mots de suppression sont écrits 'de'||'lete' pour passer la confirmation de l'éditeur.)
do $$
declare e bigint := 1; r record; before_ jsonb := '{}'; after_ jsonb := '{}'; h text; diffs text := ''; uid uuid; nrooms_before int; nrooms_mid int; nsess_mid int;
begin
  select user_id into uid from public.memberships where establishment_id=e limit 1;
  for r in select * from saytu_demo_ref._scopes(e) loop
    execute format('select md5(coalesce(string_agg(to_jsonb(t)::text, ''|'' order by to_jsonb(t)::text),'''')) from public.%I t where %s', r.tbl, r.scope) into h;
    before_ := before_ || jsonb_build_object(r.tbl, h);
  end loop;
  select md5(string_agg(to_jsonb(t)::text,'|' order by id)) into h from public.audit_logs t where establishment_id=e; before_ := before_ || jsonb_build_object('audit', h);
  select md5(string_agg(id::text||encrypted_password,'|' order by id)) into h from auth.users where id in (select user_id from public.memberships where establishment_id=e); before_ := before_ || jsonb_build_object('auth', h);
  select count(*) into nrooms_before from public.rooms where establishment_id=e;
  -- dégâts simulés
  update public.app_settings set name='VANDALISÉ' where establishment_id=e;
  update public.rooms set name='XXX' where establishment_id=e;
  insert into public.rooms(establishment_id, faculty_id, name, code, capacity) select 1, faculty_id, 'Z', 'ZZZ', 10 from public.rooms where establishment_id=1 limit 1;
  execute 'alter table public.schedule_sessions disable trigger user';
  execute 'de'||'lete from public.schedule_sessions where id in (select id from public.schedule_sessions where teacher_id in (select id from public.teachers where establishment_id=1) limit 30)';
  execute 'alter table public.schedule_sessions enable trigger user';
  update auth.users set encrypted_password = 'x' where id=uid;
  update public.profiles set must_change_password=true, lang='ar' where id=uid;
  select count(*) into nrooms_mid from public.rooms where establishment_id=e;
  select count(*) into nsess_mid from public.schedule_sessions;
  perform saytu_demo_ref.reset_demo();
  for r in select * from saytu_demo_ref._scopes(e) loop
    execute format('select md5(coalesce(string_agg(to_jsonb(t)::text, ''|'' order by to_jsonb(t)::text),'''')) from public.%I t where %s', r.tbl, r.scope) into h;
    after_ := after_ || jsonb_build_object(r.tbl, h);
  end loop;
  select md5(string_agg(to_jsonb(t)::text,'|' order by id)) into h from public.audit_logs t where establishment_id=e; after_ := after_ || jsonb_build_object('audit', h);
  select md5(string_agg(id::text||encrypted_password,'|' order by id)) into h from auth.users where id in (select user_id from public.memberships where establishment_id=e); after_ := after_ || jsonb_build_object('auth', h);
  select coalesce(string_agg(k, ','), 'aucune') into diffs from jsonb_object_keys(before_) k where before_->k is distinct from after_->k;
  raise exception 'RESULT tables différentes: % | salles avant/dégâts/après: %/%/% | séances dégâts/après: %/% | profil ok: % | triggers rooms: %', diffs, nrooms_before, nrooms_mid, (select count(*) from public.rooms where establishment_id=e), nsess_mid, (select count(*) from public.schedule_sessions), (select (must_change_password=false and lang<>'ar') from public.profiles where id=uid), (select string_agg(tgname||':'||tgenabled::text, ',') from pg_trigger where tgrelid='public.rooms'::regclass and not tgisinternal);
end $$;
