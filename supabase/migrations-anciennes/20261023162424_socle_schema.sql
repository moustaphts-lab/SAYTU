
create extension if not exists btree_gist with schema extensions;

-- Rôles
create type public.app_role as enum ('admin','planificateur','professeur','responsable','finance','direction');

-- Profils utilisateurs
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

-- Référentiel
create table public.academic_years (
  id bigint generated always as identity primary key,
  label text not null unique,
  start_date date not null,
  end_date date not null,
  is_current boolean not null default false,
  check (end_date > start_date)
);

create table public.semesters (
  id bigint generated always as identity primary key,
  academic_year_id bigint not null references public.academic_years(id),
  label text not null,
  start_date date not null,
  end_date date not null,
  unique (academic_year_id, label),
  check (end_date > start_date)
);

create table public.departments (
  id bigint generated always as identity primary key,
  code text not null unique,
  name text not null
);

create table public.user_roles (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role public.app_role not null,
  department_id bigint references public.departments(id),
  unique nulls not distinct (user_id, role, department_id)
);

create table public.programs (
  id bigint generated always as identity primary key,
  department_id bigint not null references public.departments(id),
  code text not null unique,
  name text not null,
  level text not null
);

create table public.student_groups (
  id bigint generated always as identity primary key,
  program_id bigint not null references public.programs(id),
  code text not null unique,
  name text not null,
  size int not null default 0 check (size >= 0)
);

create table public.courses (
  id bigint generated always as identity primary key,
  department_id bigint not null references public.departments(id),
  code text not null unique,
  name text not null,
  course_type text not null default 'CM' check (course_type in ('CM','TD','TP')),
  total_hours numeric(6,2) not null default 0
);

create table public.rooms (
  id bigint generated always as identity primary key,
  code text not null unique,
  name text not null,
  capacity int not null check (capacity > 0),
  room_type text not null default 'standard'
);

create table public.teachers (
  id bigint generated always as identity primary key,
  profile_id uuid unique references public.profiles(id) on delete set null,
  first_name text not null,
  last_name text not null,
  email text not null unique,
  phone text,
  department_id bigint references public.departments(id),
  grade text,
  active boolean not null default true
);

create table public.teaching_assignments (
  id bigint generated always as identity primary key,
  semester_id bigint not null references public.semesters(id),
  teacher_id bigint not null references public.teachers(id),
  course_id bigint not null references public.courses(id),
  group_id bigint not null references public.student_groups(id),
  planned_hours numeric(6,2) not null check (planned_hours > 0),
  unique (semester_id, course_id, group_id, teacher_id)
);

-- Créneaux hebdomadaires (emploi du temps type)
create table public.timetable_slots (
  id bigint generated always as identity primary key,
  assignment_id bigint not null references public.teaching_assignments(id) on delete cascade,
  day_of_week smallint not null check (day_of_week between 1 and 7), -- 1 = lundi
  start_time time not null,
  end_time time not null,
  room_id bigint not null references public.rooms(id),
  published boolean not null default false,
  check (end_time > start_time)
);

-- Séances datées
create type public.session_status as enum ('planifiee','annulee','reportee','effectuee');

create table public.schedule_sessions (
  id bigint generated always as identity primary key,
  assignment_id bigint not null references public.teaching_assignments(id),
  slot_id bigint references public.timetable_slots(id) on delete set null,
  teacher_id bigint not null references public.teachers(id),
  group_id bigint not null references public.student_groups(id),
  room_id bigint not null references public.rooms(id),
  session_date date not null,
  start_time time not null,
  end_time time not null,
  status public.session_status not null default 'planifiee',
  note text,
  created_at timestamptz not null default now(),
  check (end_time > start_time),
  -- Anti-conflits au niveau de la base (hors séances annulées)
  constraint no_room_overlap exclude using gist (
    room_id with =, tsrange(session_date + start_time, session_date + end_time) with &&
  ) where (status <> 'annulee'),
  constraint no_teacher_overlap exclude using gist (
    teacher_id with =, tsrange(session_date + start_time, session_date + end_time) with &&
  ) where (status <> 'annulee'),
  constraint no_group_overlap exclude using gist (
    group_id with =, tsrange(session_date + start_time, session_date + end_time) with &&
  ) where (status <> 'annulee')
);
create index on public.schedule_sessions (teacher_id, session_date);
create index on public.schedule_sessions (session_date);

-- Émargements
create type public.attendance_status as enum ('soumis','valide','rejete','correction_demandee');

create table public.attendance_records (
  id bigint generated always as identity primary key,
  session_id bigint not null unique references public.schedule_sessions(id), -- un seul émargement par séance
  teacher_id bigint not null references public.teachers(id),
  planned_minutes int not null,
  declared_start time not null,
  declared_end time not null,
  declared_minutes int not null check (declared_minutes > 0),
  retained_minutes int check (retained_minutes >= 0),
  teacher_comment text,
  status public.attendance_status not null default 'soumis',
  submitted_by uuid not null references public.profiles(id),
  submitted_at timestamptz not null default now(),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  review_reason text,
  pay_period_id bigint, -- rattachement futur au module paie
  check (declared_end > declared_start)
);
create index on public.attendance_records (teacher_id);
create index on public.attendance_records (status);

-- Journal d'audit
create table public.audit_logs (
  id bigint generated always as identity primary key,
  occurred_at timestamptz not null default now(),
  actor uuid,
  action text not null,
  table_name text not null,
  record_id text,
  old_data jsonb,
  new_data jsonb
);
create index on public.audit_logs (occurred_at desc);
