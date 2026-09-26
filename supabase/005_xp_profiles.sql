alter table public.profiles add column if not exists total_xp integer default 0;
alter table public.profiles add column if not exists level integer default 1;
create table if not exists public.xp_events(
 id bigserial primary key,user_id uuid references auth.users(id) on delete cascade,
 source text not null,amount integer not null check(amount between 1 and 10000),event_key text,
 created_at timestamptz default now(),unique(user_id,event_key)
);
alter table public.xp_events enable row level security;
create policy "own xp readable" on public.xp_events for select using(auth.uid()=user_id);
create or replace view public.salon_public_profiles as
select p.id,p.username,p.display_name,p.avatar_url,p.total_xp,p.level,
 coalesce(g.games,0) games,coalesce(g.wins,0) wins,coalesce(g.win_rate,0) win_rate,
 coalesce(a.achievements,0) achievements
from public.profiles p
left join public.game_leaderboard g on g.id=p.id
left join (select user_id,count(*)::int achievements from public.user_achievements group by user_id) a on a.user_id=p.id;
grant select on public.salon_public_profiles to anon,authenticated;