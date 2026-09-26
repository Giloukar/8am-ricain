create table if not exists public.lexi_daily_stats(
 user_id uuid not null references auth.users(id) on delete cascade,day date not null default current_date,
 reviews integer default 0,correct integer default 0,new_words integer default 0,xp integer default 0,
 primary key(user_id,day)
);
alter table public.lexi_daily_stats enable row level security;
create policy "own daily stats" on public.lexi_daily_stats for select using(auth.uid()=user_id);
grant select on public.lexi_daily_stats to authenticated;
create or replace function public.lexi_activity(p_days integer default 30)
returns setof public.lexi_daily_stats language sql stable security invoker as $$
 select * from public.lexi_daily_stats where user_id=auth.uid() and day>=current_date-least(greatest(p_days,1),365) order by day
$$;
grant execute on function public.lexi_activity(integer) to authenticated;