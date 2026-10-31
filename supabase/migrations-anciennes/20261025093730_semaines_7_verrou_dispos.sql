alter policy availability_insert on public.teacher_availability
  with check (teacher_id = (select public.current_teacher_id())
              and not exists (select 1 from public.published_weeks p where p.week_start = teacher_availability.week_start));
alter policy availability_update on public.teacher_availability
  using (teacher_id = (select public.current_teacher_id())
         and not exists (select 1 from public.published_weeks p where p.week_start = teacher_availability.week_start))
  with check (teacher_id = (select public.current_teacher_id())
              and not exists (select 1 from public.published_weeks p where p.week_start = teacher_availability.week_start));
alter policy availability_delete on public.teacher_availability
  using (teacher_id = (select public.current_teacher_id())
         and not exists (select 1 from public.published_weeks p where p.week_start = teacher_availability.week_start));
