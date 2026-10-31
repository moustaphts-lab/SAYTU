
create table public.absence_requests(
  id bigint generated always as identity primary key,
  session_id bigint not null references public.schedule_sessions(id) on delete cascade,
  teacher_id bigint not null references public.teachers(id),
  reason text not null check (length(reason) between 2 and 300),
  proposal text check (length(proposal) <= 300),
  status text not null default 'en_attente' check (status in ('en_attente','annulee','reportee','refusee','retiree')),
  answer text,
  created_at timestamptz not null default now(),
  decided_at timestamptz,
  decided_by uuid);
create unique index absence_requests_one_pending on public.absence_requests(session_id) where status = 'en_attente';
alter table public.absence_requests enable row level security;
create policy absence_requests_select on public.absence_requests for select to authenticated
  using (teacher_id = (select public.current_teacher_id()) or (select public.is_planner()) or (select public.has_role('direction')));
create trigger trg_audit_absence_requests after insert or update on public.absence_requests for each row execute function public.audit_trigger();

create or replace function public.request_absence(p_session bigint, p_reason text, p_proposal text) returns bigint
language plpgsql security definer set search_path to '' as $$
declare s public.schedule_sessions; t bigint := public.current_teacher_id(); r bigint;
begin
  if t is null then raise exception 'Réservé aux professeurs.'; end if;
  select * into s from public.schedule_sessions where id = p_session;
  if s.id is null or s.teacher_id <> t then raise exception 'Cette séance ne vous est pas attribuée.'; end if;
  if s.status = 'annulee' then raise exception 'Cette séance est déjà annulée.'; end if;
  if (s.session_date + s.start_time) <= (now() at time zone 'Africa/Dakar') then raise exception 'Cette séance a déjà commencé.'; end if;
  if exists (select 1 from public.absence_requests where session_id = p_session and status = 'en_attente') then raise exception 'Une demande est déjà en attente pour cette séance.'; end if;
  insert into public.absence_requests(session_id,teacher_id,reason,proposal) values (p_session,t,trim(p_reason),nullif(trim(coalesce(p_proposal,'')),'')) returning id into r;
  return r;
end $$;

create or replace function public.withdraw_absence(p_id bigint) returns void
language plpgsql security definer set search_path to '' as $$
begin
  update public.absence_requests set status = 'retiree', decided_at = now()
   where id = p_id and teacher_id = public.current_teacher_id() and status = 'en_attente';
  if not found then raise exception 'Demande introuvable ou déjà traitée.'; end if;
end $$;

create or replace function public.refuse_absence(p_id bigint, p_answer text) returns void
language plpgsql security definer set search_path to '' as $$
begin
  if not public.is_planner() then raise exception 'Action non autorisée.'; end if;
  update public.absence_requests set status = 'refusee', answer = nullif(trim(coalesce(p_answer,'')),''), decided_at = now(), decided_by = auth.uid()
   where id = p_id and status = 'en_attente';
  if not found then raise exception 'Demande introuvable ou déjà traitée.'; end if;
end $$;

-- une séance annulée ou déplacée règle automatiquement la demande en attente
create or replace function public.absence_follow_session() returns trigger
language plpgsql security definer set search_path to '' as $$
begin
  if new.status = 'annulee' and old.status <> 'annulee' then
    update public.absence_requests set status='annulee', answer=coalesce(answer,new.note), decided_at=now(), decided_by=auth.uid() where session_id=new.id and status='en_attente';
  elsif new.session_date <> old.session_date or new.start_time <> old.start_time then
    update public.absence_requests set status='reportee', answer=coalesce(answer,new.note), decided_at=now(), decided_by=auth.uid() where session_id=new.id and status='en_attente';
  end if;
  return new;
end $$;
create trigger trg_absence_follow after update on public.schedule_sessions for each row execute function public.absence_follow_session();

