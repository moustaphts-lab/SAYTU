-- Créneaux datés par semaine (lundi de la semaine)
alter table public.timetable_slots add column week_start date;
update public.timetable_slots set week_start = date '2026-10-26' where week_start is null;
alter table public.timetable_slots alter column week_start set not null;
alter table public.timetable_slots add constraint slot_week_monday check (extract(isodow from week_start) = 1);
create index timetable_slots_week_idx on public.timetable_slots(week_start);

-- Semaines publiées
create table public.published_weeks (
  week_start date primary key check (extract(isodow from week_start) = 1),
  published_at timestamptz not null default now(),
  published_by uuid default auth.uid() references public.profiles(id)
);
alter table public.published_weeks enable row level security;
create policy published_weeks_select on public.published_weeks for select to authenticated using (true);
create policy published_weeks_planner on public.published_weeks for all to authenticated using ((select public.is_planner())) with check ((select public.is_planner()));
create trigger trg_audit_published_weeks after insert or update or delete on public.published_weeks for each row execute function public.audit_trigger();

-- Disponibilités par semaine
alter table public.teacher_availability add column week_start date;
alter table public.teacher_availability alter column week_start set not null;
alter table public.teacher_availability add constraint availability_week_monday check (extract(isodow from week_start) = 1);
create index teacher_availability_week_idx on public.teacher_availability(teacher_id, week_start);

-- Réponse du professeur pour une semaine (même sans aucune plage = indisponible toute la semaine)
create table public.availability_weeks (
  teacher_id bigint not null references public.teachers(id) on delete cascade,
  week_start date not null check (extract(isodow from week_start) = 1),
  declared_at timestamptz not null default now(),
  declared_by uuid default auth.uid() references public.profiles(id),
  by_planner boolean not null default false,
  primary key (teacher_id, week_start)
);
alter table public.availability_weeks enable row level security;
create policy availability_weeks_select on public.availability_weeks for select to authenticated
  using (teacher_id = (select public.current_teacher_id()) or (select public.is_planner()));
create trigger trg_audit_availability_weeks after insert or update or delete on public.availability_weeks for each row execute function public.audit_trigger();
