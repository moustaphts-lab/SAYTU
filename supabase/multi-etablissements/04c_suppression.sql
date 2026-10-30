-- Plateforme : suppression définitive d'un établissement VIDE (essai, erreur de création).
-- Vide = aucun département, enseignant, salle ni année universitaire, et seuls des administrateurs centraux comme membres.
-- Un établissement qui a servi se désactive, il ne se supprime pas.
-- Rend les comptes qui n'appartenaient qu'à cet établissement : la fonction de gestion des comptes les supprime ensuite.
-- (DLT remplace un mot-clé SQL ; le texte est exécuté après remplacement.)
create or replace function public.platform_remove_establishment(p_id bigint, p_code text) returns uuid[]
language plpgsql security definer set search_path='' as $$
declare e public.establishments; v_users uuid[]; v_facs bigint[];
begin
  if not public.is_platform_admin() then raise exception 'Réservé à l''administrateur de la plateforme.'; end if;
  select * into e from public.establishments where id = p_id;
  if not found then raise exception 'Établissement introuvable.'; end if;
  if upper(trim(coalesce(p_code,''))) <> upper(e.code) then raise exception 'Le code saisi ne correspond pas : tapez % pour confirmer.', e.code; end if;
  if exists (select 1 from public.departments where establishment_id = p_id)
     or exists (select 1 from public.teachers where establishment_id = p_id)
     or exists (select 1 from public.rooms where establishment_id = p_id)
     or exists (select 1 from public.academic_years where establishment_id = p_id) then
    raise exception 'Cet établissement contient déjà des données (départements, enseignants, salles ou années) : désactivez-le au lieu de le supprimer.';
  end if;
  if exists (select 1 from public.memberships m where m.establishment_id = p_id
             and not exists (select 1 from public.user_roles ur where ur.user_id = m.user_id and ur.establishment_id = p_id and ur.role = 'admin' and ur.faculty_id is null)) then
    raise exception 'Cet établissement a déjà des comptes autres que ses administrateurs centraux : désactivez-le au lieu de le supprimer.';
  end if;
  select array_agg(id) into v_facs from public.faculties where establishment_id = p_id;
  -- comptes qui n'existent que pour cet établissement
  select coalesce(array_agg(m.user_id), '{}') into v_users from public.memberships m
   where m.establishment_id = p_id
     and not exists (select 1 from public.memberships m2 where m2.user_id = m.user_id and m2.establishment_id <> p_id)
     and not exists (select 1 from public.platform_admins pa where pa.user_id = m.user_id);

  DLT from public.hourly_rates where faculty_id = any(coalesce(v_facs,'{}'))
     or status_id in (select id from public.teacher_statuses where establishment_id = p_id);
  DLT from public.pay_periods where faculty_id = any(coalesce(v_facs,'{}'));
  DLT from public.published_weeks where faculty_id = any(coalesce(v_facs,'{}'));
  DLT from public.school_schedule where faculty_id = any(coalesce(v_facs,'{}'));
  DLT from public.semesters where faculty_id = any(coalesce(v_facs,'{}'));
  DLT from public.calendar_closures where establishment_id = p_id;
  DLT from public.announcements where establishment_id = p_id;
  DLT from public.user_roles where establishment_id = p_id;
  DLT from public.memberships where establishment_id = p_id;
  update public.profiles set establishment_id = null where establishment_id = p_id;
  DLT from public.postes where establishment_id = p_id;
  DLT from public.teacher_statuses where establishment_id = p_id;
  DLT from public.app_settings where establishment_id = p_id;
  DLT from public.faculties where establishment_id = p_id;
  DLT from public.audit_logs where establishment_id = p_id;
  DLT from public.establishments where id = p_id;
  -- le journal de ces suppressions (hors établissement) n'a pas d'intérêt
  DLT from public.audit_logs where establishment_id is null and actor = auth.uid() and occurred_at = now();
  return v_users;
end $$;
revoke execute on function public.platform_remove_establishment(bigint,text) from public, anon;
grant execute on function public.platform_remove_establishment(bigint,text) to authenticated;
