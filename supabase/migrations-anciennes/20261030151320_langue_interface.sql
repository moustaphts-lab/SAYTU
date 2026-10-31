alter table public.profiles add column if not exists lang text not null default 'fr';
alter table public.profiles drop constraint if exists profiles_lang_check;
alter table public.profiles add constraint profiles_lang_check check (lang in ('fr','ar'));
create or replace function public.set_my_lang(p_lang text) returns void language plpgsql security definer set search_path to ''
as $$ begin
  if p_lang not in ('fr','ar') then raise exception 'Langue inconnue.'; end if;
  update public.profiles set lang = p_lang where id = auth.uid();
end $$;
create or replace function public.my_lang() returns text language sql stable security definer set search_path to ''
as $$ select lang from public.profiles where id = auth.uid() $$;
revoke execute on function public.set_my_lang(text), public.my_lang() from anon;
