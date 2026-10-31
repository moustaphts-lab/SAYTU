
create table public.teacher_statuses (
  id bigint generated always as identity primary key,
  code text not null unique,
  label text not null
);
alter table public.teachers add column status_id bigint references public.teacher_statuses(id);

create table public.hourly_rates (
  id bigint generated always as identity primary key,
  status_id bigint references public.teacher_statuses(id),
  teacher_id bigint references public.teachers(id),
  rate_fcfa int not null check (rate_fcfa > 0),
  effective_from date not null,
  note text,
  created_by uuid references public.profiles(id) default auth.uid(),
  created_at timestamptz not null default now(),
  check ((status_id is null) <> (teacher_id is null))
);
create unique index hourly_rates_status_uq on public.hourly_rates (status_id, effective_from) where status_id is not null;
create unique index hourly_rates_teacher_uq on public.hourly_rates (teacher_id, effective_from) where teacher_id is not null;

create type public.pay_period_status as enum ('ouverte','en_verification','approuvee','payee');
create table public.pay_periods (
  id bigint generated always as identity primary key,
  name text not null,
  start_date date not null,
  end_date date not null,
  attendance_deadline date,
  regularization_deadline date,
  manager_id uuid references public.profiles(id),
  status public.pay_period_status not null default 'ouverte',
  calculated_at timestamptz,
  approved_by uuid references public.profiles(id),
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  check (end_date >= start_date)
);
alter table public.attendance_records
  add constraint attendance_pay_period_fk foreign key (pay_period_id) references public.pay_periods(id);

create table public.payroll_items (
  id bigint generated always as identity primary key,
  pay_period_id bigint not null references public.pay_periods(id) on delete cascade,
  attendance_id bigint not null unique references public.attendance_records(id),
  teacher_id bigint not null references public.teachers(id),
  session_date date not null,
  course_label text not null,
  group_code text not null,
  minutes int not null check (minutes >= 0),
  rate_fcfa int not null,
  rate_source text not null,
  rate_id bigint references public.hourly_rates(id),
  amount_fcfa int not null,
  is_catch_up boolean not null default false
);
create index on public.payroll_items (pay_period_id, teacher_id);

create type public.payslip_status as enum ('approuve','partiellement_paye','paye');
create sequence public.payslip_seq;
create table public.payslips (
  id bigint generated always as identity primary key,
  number text not null unique,
  pay_period_id bigint not null references public.pay_periods(id),
  teacher_id bigint not null references public.teachers(id),
  total_minutes int not null,
  gross_fcfa int not null,
  deductions_fcfa int not null default 0,
  net_fcfa int not null,
  status public.payslip_status not null default 'approuve',
  snapshot jsonb not null,
  generated_at timestamptz not null default now(),
  unique (pay_period_id, teacher_id)
);

create table public.payments (
  id bigint generated always as identity primary key,
  payslip_id bigint not null references public.payslips(id),
  amount_fcfa int not null check (amount_fcfa > 0),
  paid_on date not null,
  method text not null default 'virement',
  reference text,
  recorded_by uuid references public.profiles(id) default auth.uid(),
  recorded_at timestamptz not null default now()
);
