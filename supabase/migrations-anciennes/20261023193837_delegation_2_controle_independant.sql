create or replace function public.review_attendance(p_id bigint, p_decision attendance_status, p_retained_minutes integer default null, p_reason text default null)
returns public.attendance_records
language plpgsql security definer set search_path = '' as $$
declare
  r public.attendance_records;
  v_dept bigint;
  v_retained int;
begin
  select * into r from public.attendance_records where id = p_id for update;
  if not found then raise exception 'Émargement introuvable.'; end if;
  select c.department_id into v_dept from public.schedule_sessions s
    join public.teaching_assignments ta on ta.id = s.assignment_id
    join public.courses c on c.id = ta.course_id where s.id = r.session_id;
  if not public.can_review_department(v_dept) then raise exception 'Vous n''êtes pas habilité à contrôler ce département.'; end if;
  if r.teacher_id = public.current_teacher_id() then raise exception 'Contrôle indépendant requis : vous ne pouvez pas valider vos propres heures.'; end if;
  if r.submitted_by = auth.uid() then raise exception 'Contrôle indépendant requis : vous ne pouvez pas valider un émargement que vous avez saisi.'; end if;
  if r.status <> 'soumis' then raise exception 'Seuls les émargements « soumis » peuvent être contrôlés (statut actuel : %).', r.status; end if;
  if r.pay_period_id is not null then raise exception 'Émargement rattaché à une période de paie : régularisation requise.'; end if;
  if p_decision = 'soumis' then raise exception 'Décision invalide.'; end if;
  if p_decision in ('rejete','correction_demandee') and coalesce(trim(p_reason),'') = '' then
    raise exception 'Un motif est obligatoire pour un rejet ou une demande de correction.';
  end if;
  if p_decision = 'valide' then
    v_retained := coalesce(p_retained_minutes, least(r.declared_minutes, r.planned_minutes));
    if v_retained > r.declared_minutes then raise exception 'La durée retenue ne peut pas dépasser la durée déclarée.'; end if;
    if v_retained > r.planned_minutes and coalesce(trim(p_reason),'') = '' then
      raise exception 'Durée retenue supérieure à la durée prévue : motif obligatoire.';
    end if;
    update public.schedule_sessions set status = 'effectuee' where id = r.session_id;
  else
    v_retained := null;
  end if;
  update public.attendance_records set status = p_decision, retained_minutes = v_retained,
    reviewed_by = auth.uid(), reviewed_at = now(), review_reason = nullif(trim(p_reason),'')
  where id = p_id returning * into r;
  return r;
end $$;
