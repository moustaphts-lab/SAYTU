alter table public.teacher_availability drop constraint teacher_availability_no_overlap;
alter table public.teacher_availability add constraint teacher_availability_no_overlap
  exclude using gist (teacher_id with =, week_start with =, day_of_week with =,
    tsrange(('2000-01-01'::date + start_time), ('2000-01-01'::date + end_time)) with &&);
