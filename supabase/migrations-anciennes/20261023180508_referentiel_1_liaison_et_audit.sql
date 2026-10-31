
-- Lier automatiquement un enseignant à un compte existant portant le même e-mail
create or replace function public.link_teacher_profile()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if new.profile_id is null then
    select p.id into new.profile_id from public.profiles p where lower(p.email) = lower(new.email) limit 1;
  end if;
  return new;
end $$;
create trigger trg_link_teacher before insert or update of email on public.teachers
  for each row execute function public.link_teacher_profile();
revoke execute on function public.link_teacher_profile() from public, anon, authenticated;

-- Journal d'audit sur le référentiel
do $$ declare t text;
begin
  foreach t in array array['academic_years','semesters','departments','programs','student_groups','courses','rooms']
  loop
    execute format('create trigger trg_audit_%1$s after insert or update or delete on public.%1$I for each row execute function public.audit_trigger()', t);
  end loop;
end $$;
