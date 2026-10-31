alter table public.courses add column program_id bigint references public.programs(id);
create index courses_program_idx on public.courses(program_id);
-- jeu d'essai : SREL1xx -> SREL-L1, HIST2xx -> HIST-L2, etc.
update public.courses c set program_id = p.id
  from public.programs p
 where c.program_id is null and c.code ~ '^[A-Z]+[1-9][0-9]{2}$'
   and p.code = regexp_replace(c.code,'^([A-Z]+)([1-9])[0-9]{2}$','\1-L\2');
