
create table public.faculties(
  id bigint generated always as identity primary key,
  code text not null unique check (length(trim(code)) between 1 and 15),
  name text not null check (length(trim(name)) between 2 and 120),
  short_name text,
  logo text,
  pdf_header text not null default '',
  timetable_mode text not null default 'hebdomadaire' check (timetable_mode in ('hebdomadaire','fixe')),
  payroll_visa boolean not null default true,
  sort int not null default 100,
  created_at timestamptz not null default now());
alter table public.faculties enable row level security;
create policy faculties_select on public.faculties for select to authenticated using (true);
create policy faculties_admin on public.faculties for all to authenticated using ((select public.has_role('admin'))) with check ((select public.has_role('admin')));
create trigger trg_audit_faculties after insert or update or delete on public.faculties for each row execute function public.audit_trigger();
insert into public.faculties(code,name,short_name,sort) values ('FSRC','Faculté des sciences religieuses et civilisations','Sciences religieuses et civilisations',10);

alter table public.departments add column faculty_id bigint references public.faculties(id);
update public.departments set faculty_id = (select id from public.faculties where code='FSRC');
alter table public.departments alter column faculty_id set not null;

alter table public.rooms add column faculty_id bigint references public.faculties(id);
update public.rooms set faculty_id = (select id from public.faculties where code='FSRC');
alter table public.rooms alter column faculty_id set not null;
alter table public.rooms drop constraint rooms_code_key;
alter table public.rooms add constraint rooms_faculty_code_key unique (faculty_id, code);

alter table public.semesters add column faculty_id bigint references public.faculties(id);
update public.semesters set faculty_id = (select id from public.faculties where code='FSRC');
alter table public.semesters alter column faculty_id set not null;
alter table public.semesters drop constraint semesters_academic_year_id_label_key;
alter table public.semesters add constraint semesters_year_faculty_label_key unique (academic_year_id, faculty_id, label);

alter table public.school_schedule drop constraint school_schedule_id_check;
alter table public.school_schedule add column faculty_id bigint references public.faculties(id);
update public.school_schedule set faculty_id = (select id from public.faculties where code='FSRC');
alter table public.school_schedule alter column faculty_id set not null;
alter table public.school_schedule add constraint school_schedule_faculty_key unique (faculty_id);

alter table public.calendar_closures add column faculty_id bigint references public.faculties(id);
comment on column public.calendar_closures.faculty_id is 'null = toute l''université';

