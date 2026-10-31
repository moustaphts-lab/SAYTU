-- Audit F2 : un compte d'un autre établissement ne doit rien apprendre des facultés de DEMO.
-- À lancer dans l'éditeur SQL de Supabase ; l'erreur finale est volontaire (elle annule tout et affiche le résultat).
-- Attendu : « UCMB sur DEMO : course= dept= group= ... » (tout vide) et « DEMO sur DEMO : course=1 dept=1 ... » (valeurs présentes).
do $$
declare u uuid; du uuid; c bigint; d bigint; g bigint; p bigint; t bigint; pp bigint; ps bigint; s bigint; a bigint; r1 text; r2 text;
begin
  select id into u  from auth.users where email='serignebi@test.con';       -- compte de l'établissement UCMB
  select id into du from auth.users where email='directeur@univdemo.test';  -- compte de DEMO
  select min(id) into c  from public.courses where establishment_id=1;
  select min(id) into d  from public.departments where establishment_id=1;
  select min(id) into g  from public.student_groups where establishment_id=1;
  select min(id) into p  from public.programs where establishment_id=1;
  select min(id) into t  from public.teachers where establishment_id=1;
  select min(id) into pp from public.pay_periods;
  select min(id) into ps from public.payslips where establishment_id=1;
  select min(id) into s  from public.schedule_sessions;
  select min(id) into a  from public.teaching_assignments;
  perform set_config('request.jwt.claims', json_build_object('sub',u,'role','authenticated')::text, true);
  set local role authenticated;
  r1 := format('UCMB sur DEMO : course=%s dept=%s group=%s program=%s teacher=%s period=%s payslip=%s session=%s assignment=%s',
    public.fac_of_course(c), public.fac_of_dept(d), public.fac_of_group(g), public.fac_of_program(p), public.fac_of_teacher(t),
    public.fac_of_period(pp), public.fac_of_payslip(ps), public.fac_of_session(s), public.faculty_of_assignment(a));
  reset role;
  perform set_config('request.jwt.claims', json_build_object('sub',du,'role','authenticated')::text, true);
  set local role authenticated;
  r2 := format('DEMO sur DEMO : course=%s dept=%s group=%s program=%s teacher=%s period=%s payslip=%s session=%s assignment=%s',
    public.fac_of_course(c), public.fac_of_dept(d), public.fac_of_group(g), public.fac_of_program(p), public.fac_of_teacher(t),
    public.fac_of_period(pp), public.fac_of_payslip(ps), public.fac_of_session(s), public.faculty_of_assignment(a));
  reset role;
  raise exception 'RESULT % || %', r1, r2;
end $$;
