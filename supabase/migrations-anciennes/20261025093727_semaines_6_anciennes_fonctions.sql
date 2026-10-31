create or replace function public.save_availability(p_ranges jsonb)
returns void language plpgsql security definer set search_path to '' as $$
begin raise exception 'Fonction remplacée : les disponibilités se déclarent maintenant semaine par semaine.'; end $$;
create or replace function public.reset_availability()
returns void language plpgsql security definer set search_path to '' as $$
begin raise exception 'Fonction remplacée : les disponibilités se déclarent maintenant semaine par semaine.'; end $$;
create or replace function public.generate_sessions(p_from date, p_to date)
returns table(created integer, conflicts jsonb) language plpgsql security definer set search_path to '' as $$
begin raise exception 'Fonction remplacée : les séances sont créées en publiant la semaine.'; end $$;
