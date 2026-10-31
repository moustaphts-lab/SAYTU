alter table public.school_schedule add column group_max_hours numeric not null default 8 check (group_max_hours between 1 and 12);
