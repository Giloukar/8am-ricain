create or replace view public.global_leaderboard with (security_invoker=true) as
select p.id,p.username,p.display_name,p.avatar_url,p.total_xp,p.level,p.lexi_xp,p.game_xp,
coalesce(g.games,0)::int games,coalesce(g.wins,0)::int wins,coalesce(g.win_rate,0) win_rate
from public.profiles p left join public.game_leaderboard g on g.id=p.id;
grant select on public.global_leaderboard to anon,authenticated;