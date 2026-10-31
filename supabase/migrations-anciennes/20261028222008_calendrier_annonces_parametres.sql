
create table public.calendar_closures(
  id bigint generated always as identity primary key,
  date_from date not null, date_to date not null,
  part text not null default 'jour' check (part in ('jour','matin','apres_midi')),
  kind text not null default 'ferie' check (kind in ('ferie','vacances','examens','evenement')),
  label text not null,
  created_at timestamptz not null default now(),
  check (date_to >= date_from));
alter table public.calendar_closures enable row level security;
create policy calendar_closures_select on public.calendar_closures for select to authenticated using (true);
create policy calendar_closures_write on public.calendar_closures for all to authenticated using ((select public.is_planner())) with check ((select public.is_planner()));
create trigger trg_audit_calendar_closures after insert or update or delete on public.calendar_closures for each row execute function public.audit_trigger();

create table public.announcements(
  id bigint generated always as identity primary key,
  message text not null check (length(message) between 1 and 500),
  audience text not null default 'professeurs' check (audience in ('professeurs','tous')),
  starts_on date not null default current_date, ends_on date,
  created_by uuid default auth.uid() references public.profiles(id),
  created_at timestamptz not null default now());
alter table public.announcements enable row level security;
create policy announcements_select on public.announcements for select to authenticated using (true);
create policy announcements_write on public.announcements for all to authenticated
  using ((select public.is_planner()) or (select public.has_role('admin'))) with check ((select public.is_planner()) or (select public.has_role('admin')));
create trigger trg_audit_announcements after insert or update or delete on public.announcements for each row execute function public.audit_trigger();

create table public.app_settings(
  id int primary key default 1 check (id = 1),
  name text not null default 'UCAB Touba',
  subtitle text not null default 'Enseignements',
  pdf_header text not null default '',
  pdf_footer text not null default '',
  logo text,
  updated_at timestamptz not null default now());
insert into public.app_settings(id) values (1);
alter table public.app_settings enable row level security;
create policy app_settings_select on public.app_settings for select to anon, authenticated using (true);
create policy app_settings_update on public.app_settings for update to authenticated using ((select public.has_role('admin'))) with check ((select public.has_role('admin')));
create trigger trg_audit_app_settings after update on public.app_settings for each row execute function public.audit_trigger();
grant select on public.app_settings to anon;

-- fermetures dans le contrôle des créneaux
create or replace function public.closure_for(p_date date, p_start time, p_end time) returns text
language sql stable security definer set search_path to '' as $$
  select c.label from public.calendar_closures c, public.school_schedule sc
  where p_date between c.date_from and c.date_to
    and (c.part = 'jour' or (c.part = 'matin' and p_start < sc.lunch_start) or (c.part = 'apres_midi' and p_end > sc.lunch_end))
  order by c.id limit 1 $$;

create or replace function public.check_slot_closure() returns trigger
language plpgsql security definer set search_path to '' as $$
declare v text; d date;
begin
  if tg_op = 'UPDATE' and new.day_of_week = old.day_of_week and new.start_time = old.start_time and new.end_time = old.end_time and new.week_start = old.week_start then return new; end if;
  d := new.week_start + (new.day_of_week - 1);
  v := public.closure_for(d, new.start_time, new.end_time);
  if v is not null then raise exception 'Pas de cours le % à cette heure : %.', to_char(d,'DD/MM/YYYY'), v; end if;
  return new;
end $$;
create trigger trg_slot_closure before insert or update on public.timetable_slots for each row execute function public.check_slot_closure();

