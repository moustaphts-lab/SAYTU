create or replace function public.view_fac() returns bigint language sql stable set search_path to ''
as $$ select case when v ~ '^[0-9]{1,12}$' then v::bigint end
      from (select coalesce(current_setting('request.headers', true)::json ->> 'x-saytu-fac',
                            current_setting('request.headers', true)::json ->> 'x-ucab-fac') v) h $$;
