create table public.school_schedule (
  id int primary key default 1 check (id = 1),
  days int[] not null default '{1,2,3,4,5}',
  day_start time not null default '08:00',
  day_end time not null default '18:00',
  slot_minutes int not null default 120 check (slot_minutes between 30 and 300),
  lunch_start time,
  lunch_end time,
  updated_at timestamptz not null default now(),
  constraint school_schedule_days_ok check (cardinality(days) between 1 and 6 and days <@ array[1,2,3,4,5,6]),
  constraint school_schedule_day_order check (day_end > day_start),
  constraint school_schedule_lunch_ok check ((lunch_start is null and lunch_end is null) or (lunch_start is not null and lunch_end is not null and lunch_end > lunch_start))
);
insert into public.school_schedule (id) values (1);
alter table public.school_schedule enable row level security;
create policy school_schedule_select on public.school_schedule for select to authenticated using (true);
create policy school_schedule_update on public.school_schedule for update to authenticated using ((select is_planner())) with check ((select is_planner()));
create trigger trg_audit_school_schedule after insert or delete or update on public.school_schedule for each row execute function audit_trigger();
