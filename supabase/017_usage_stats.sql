create table if not exists public.user_usage_daily(
 user_id uuid not null references auth.users(id) on delete cascade,
 day date not null default current_date,
 area text not null check(area in ('portal','leximind','table')),
 visits integer not null default 0,
 active_seconds integer not null default 0,
 primary key(user_id,day,area)
);
alter table public.user_usage_daily enable row level security;
create policy "own usage read" on public.user_usage_daily for select using(auth.uid()=user_id);
grant select on public.user_usage_daily to authenticated;

create or replace function public.track_usage(p_area text,p_visit boolean default false,p_active_seconds integer default 0)
returns void language plpgsql security definer set search_path=public as $$
begin
 if auth.uid() is null or p_area not in ('portal','leximind','table') then return; end if;
 insert into user_usage_daily(user_id,day,area,visits,active_seconds)
 values(auth.uid(),current_date,p_area,case when p_visit then 1 else 0 end,least(greatest(p_active_seconds,0),120))
 on conflict(user_id,day,area) do update set
 visits=user_usage_daily.visits+excluded.visits,
 active_seconds=user_usage_daily.active_seconds+excluded.active_seconds;
end $$;
grant execute on function public.track_usage(text,boolean,integer) to authenticated;

create or replace function public.user_stats()
returns jsonb language sql stable security invoker as $$
 with u as (
  select coalesce(sum(visits),0) visits,coalesce(sum(active_seconds),0) seconds,count(distinct day) filter(where active_seconds>0) active_days,
  max(day) last_day,
  coalesce(sum(active_seconds) filter(where area='leximind'),0) lexi_seconds,
  coalesce(sum(active_seconds) filter(where area='table'),0) table_seconds,
  coalesce(sum(active_seconds) filter(where area='portal'),0) portal_seconds
  from user_usage_daily where user_id=auth.uid()
 ),l as (
  select count(*) learned,coalesce(sum(reviews),0) reviews,coalesce(sum(lapses),0) lapses from lexi_progress where user_id=auth.uid()
 ),g as (
  select count(*) games,count(*) filter(where r.winner_id=auth.uid()) wins
  from game_players p join game_results r on r.id=p.result_id where p.user_id=auth.uid()
 )
 select jsonb_build_object(
 'visits',u.visits,'active_seconds',u.seconds,'active_days',u.active_days,'last_day',u.last_day,
 'lexi_seconds',u.lexi_seconds,'table_seconds',u.table_seconds,'portal_seconds',u.portal_seconds,
 'learned',l.learned,'reviews',l.reviews,'retention',round((100*(l.reviews-l.lapses)/greatest(l.reviews,1))::numeric,1),
 'words_per_hour',round((l.learned*3600.0/greatest(u.lexi_seconds,1))::numeric,1),
 'games',g.games,'wins',g.wins,'win_rate',round((100.0*g.wins/greatest(g.games,1))::numeric,1),
 'games_per_hour',round((g.games*3600.0/greatest(u.table_seconds,1))::numeric,1),
 'avg_visit_minutes',round((u.seconds/60.0/greatest(u.visits,1))::numeric,1)
 ) from u,l,g
$$;
grant execute on function public.user_stats() to authenticated;