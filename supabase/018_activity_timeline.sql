create or replace function public.user_activity(p_days integer default 30)
returns table(day date,active_seconds bigint,visits bigint,lexi_seconds bigint,table_seconds bigint)
language sql stable security invoker as $$
 select d.day,coalesce(sum(u.active_seconds),0),coalesce(sum(u.visits),0),
 coalesce(sum(u.active_seconds) filter(where u.area='leximind'),0),
 coalesce(sum(u.active_seconds) filter(where u.area='table'),0)
 from generate_series(current_date-least(greatest(p_days,1),365)+1,current_date,'1 day') d(day)
 left join user_usage_daily u on u.day=d.day and u.user_id=auth.uid()
 group by d.day order by d.day
$$;
grant execute on function public.user_activity(integer) to authenticated;