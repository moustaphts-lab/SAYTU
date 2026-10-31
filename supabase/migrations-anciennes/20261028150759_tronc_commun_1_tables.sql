-- Matière commune à plusieurs filières
create table public.course_programs (
  course_id bigint not null references public.courses(id) on delete cascade,
  program_id bigint not null references public.programs(id) on delete cascade,
  primary key (course_id, program_id)
);
insert into public.course_programs(course_id, program_id) select id, program_id from public.courses where program_id is not null;
alter table public.course_programs enable row level security;
create policy course_programs_select on public.course_programs for select to authenticated using (true);
create policy course_programs_planner on public.course_programs for all to authenticated using ((select public.is_planner())) with check ((select public.is_planner()));
create trigger trg_audit_course_programs after insert or update or delete on public.course_programs for each row execute function public.audit_trigger();

-- Regroupement : groupes supplémentaires qui suivent le même cours (même professeur, même salle, même moment)
create table public.assignment_groups (
  assignment_id bigint not null references public.teaching_assignments(id) on delete cascade,
  group_id bigint not null references public.student_groups(id),
  primary key (assignment_id, group_id)
);
create index assignment_groups_group_idx on public.assignment_groups(group_id);
alter table public.assignment_groups enable row level security;
create policy assignment_groups_select on public.assignment_groups for select to authenticated using (true);
create policy assignment_groups_planner on public.assignment_groups for all to authenticated using ((select public.is_planner())) with check ((select public.is_planner()));
create trigger trg_audit_assignment_groups after insert or update or delete on public.assignment_groups for each row execute function public.audit_trigger();

create or replace function public.assignment_group_check()
returns trigger language plpgsql set search_path to '' as $$
begin
  if exists (select 1 from public.teaching_assignments where id = new.assignment_id and group_id = new.group_id) then
    raise exception 'Ce groupe est déjà le groupe principal de ce cours.';
  end if;
  return new;
end $$;
create trigger trg_assignment_group_check before insert or update on public.assignment_groups for each row execute function public.assignment_group_check();

-- Tous les groupes d'une affectation (groupe principal + groupes du regroupement)
create or replace function public.asg_groups(p_assignment bigint)
returns bigint[] language sql stable set search_path to '' as $$
  select array[ta.group_id] || coalesce((select array_agg(ag.group_id order by ag.group_id) from public.assignment_groups ag where ag.assignment_id = ta.id), '{}')
  from public.teaching_assignments ta where ta.id = p_assignment
$$;
