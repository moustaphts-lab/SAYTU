create table public.teacher_availability (
  id bigint generated always as identity primary key,
  teacher_id bigint not null references public.teachers(id) on delete cascade,
  day_of_week smallint not null check (day_of_week between 1 and 6),
  start_time time not null,
  end_time time not null,
  note text,
  created_at timestamptz not null default now(),
  constraint availability_time_order check (end_time > start_time),
  constraint teacher_availability_no_overlap exclude using gist (
    teacher_id with =, day_of_week with =,
    tsrange(('2000-01-01'::date + start_time), ('2000-01-01'::date + end_time)) with &&)
);
create index teacher_availability_teacher_idx on public.teacher_availability (teacher_id);
alter table public.teacher_availability enable row level security;
revoke all on public.teacher_availability from anon;
