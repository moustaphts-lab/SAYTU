-- Heures validées qui ne sont pas encore dans le calcul d'une période non approuvée
-- (validées ou tarif ajouté après le dernier calcul) : l'écran invite à recalculer.
create or replace function public.payroll_not_included(p_period bigint) returns jsonb
language plpgsql stable security definer set search_path to ''
as $function$
declare p public.pay_periods; v jsonb;
begin
  select * into p from public.pay_periods where id = p_period;
  if not found then raise exception 'Période introuvable.'; end if;
  if not public.can_read_payroll_for(p.faculty_id) then raise exception 'Accès refusé.'; end if;
  select jsonb_build_object(
      'seances', count(*),
      'minutes', coalesce(sum(a.retained_minutes),0),
      'sans_tarif', count(*) filter (where not exists (select 1 from public.rate_for(a.teacher_id, s.session_date, p.faculty_id))))
    into v
  from public.attendance_records a
  join public.schedule_sessions s on s.id = a.session_id
  where a.status = 'valide' and a.pay_period_id is null and s.session_date <= p.end_date
    and public.fac_of_session(s.id) = p.faculty_id
    and not exists (select 1 from public.payroll_items x where x.attendance_id = a.id and x.pay_period_id = p.id);
  return v;
end $function$;
revoke execute on function public.payroll_not_included(bigint) from anon;
