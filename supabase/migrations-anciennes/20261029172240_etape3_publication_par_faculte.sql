
alter table public.published_weeks add column if not exists faculty_id bigint references public.faculties(id) on delete cascade;
update public.published_weeks set faculty_id = (select id from public.faculties where code='FSRC') where faculty_id is null;
alter table public.published_weeks alter column faculty_id set not null;
alter table public.published_weeks drop constraint published_weeks_pkey;
alter table public.published_weeks add constraint published_weeks_pkey primary key (week_start, faculty_id);
alter policy published_weeks_planner on public.published_weeks using ((select public.is_planner_for(faculty_id))) with check ((select public.is_planner_for(faculty_id)));
alter policy published_weeks_select on public.published_weeks using ((select public.sees_fac(faculty_id)) or faculty_id = (select public.fac_of_teacher(public.current_teacher_id())));
alter policy availability_insert on public.teacher_availability with check ((teacher_id = (select public.current_teacher_id())) and not exists (select 1 from public.published_weeks p where p.week_start = teacher_availability.week_start and p.faculty_id = public.fac_of_teacher(teacher_availability.teacher_id)));
alter policy availability_update on public.teacher_availability using ((teacher_id = (select public.current_teacher_id())) and not exists (select 1 from public.published_weeks p where p.week_start = teacher_availability.week_start and p.faculty_id = public.fac_of_teacher(teacher_availability.teacher_id)))
  with check ((teacher_id = (select public.current_teacher_id())) and not exists (select 1 from public.published_weeks p where p.week_start = teacher_availability.week_start and p.faculty_id = public.fac_of_teacher(teacher_availability.teacher_id)));
alter policy availability_delete on public.teacher_availability using ((teacher_id = (select public.current_teacher_id())) and not exists (select 1 from public.published_weeks p where p.week_start = teacher_availability.week_start and p.faculty_id = public.fac_of_teacher(teacher_availability.teacher_id)));

