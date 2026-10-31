-- La paie se fait dans les facultés : seul un droit « Paie » ou « Caissier » rattaché à la faculté permet d'agir.
-- Le même droit au niveau de l'université (responsable financier central) ne donne que la consultation.
create or replace function public.is_finance_for(fac bigint) returns boolean language sql stable security definer set search_path to ''
as $$ select fac is not null and exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'finance' and ur.faculty_id = fac) $$;
create or replace function public.is_cashier_for(fac bigint) returns boolean language sql stable security definer set search_path to ''
as $$ select fac is not null and exists (select 1 from public.user_roles ur where ur.user_id = auth.uid() and ur.role = 'caissier' and ur.faculty_id = fac) $$;
revoke execute on function public.is_cashier_for(bigint) from anon;

do $$
declare d text;
begin
  d := pg_get_functiondef('public.record_payment(bigint,integer,date,text,text)'::regprocedure);
  d := replace(d, 'public.has_role_for(''caissier'', v_fac)', 'public.is_cashier_for(v_fac)');
  execute d;
  d := pg_get_functiondef('public.set_teacher_payment(bigint,text,text)'::regprocedure);
  d := replace(d, 'public.has_role_for(''finance'', v_fac) or public.has_role_for(''caissier'', v_fac)', 'public.is_finance_for(v_fac) or public.is_cashier_for(v_fac)');
  execute d;
end $$;

update public.postes set name = 'Représentant financier' where name = 'Responsable financier' and scope = 'faculte';
insert into public.postes(name, roles, scope, sort)
select 'Responsable financier de l''université', array['finance'], 'universite', 52
where not exists (select 1 from public.postes where name = 'Responsable financier de l''université');
