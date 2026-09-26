create index if not exists lexi_progress_user_due_idx on public.lexi_progress(user_id,due_at);
create index if not exists lexi_reviews_user_created_idx on public.lexi_reviews(user_id,created_at desc);
create index if not exists game_players_user_idx on public.game_players(user_id);

create or replace function public.lexi_library(p_offset integer default 0,p_limit integer default 50,p_query text default null,p_filter text default 'all')
returns table(id bigint,word text,pos text,definition text,level smallint,stability real,due_at timestamptz,known boolean,favorite boolean,reviews integer,lapses integer)
language sql stable security invoker as $$
 select l.id,l.word,l.pos,l.definition,p.level,p.stability,p.due_at,p.known,p.favorite,p.reviews,p.lapses
 from public.lexi_progress p join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid()
 and (p_query is null or trim(p_query)='' or lower(l.word) like '%'||lower(trim(p_query))||'%' or lower(l.definition) like '%'||lower(trim(p_query))||'%')
 and (p_filter='all' or (p_filter='favorites' and p.favorite) or (p_filter='due' and not p.known and p.due_at<=now()) or (p_filter='mastered' and (p.known or p.level>=4)))
 order by case when p.favorite then 0 else 1 end,p.updated_at desc
 offset greatest(p_offset,0) limit least(greatest(p_limit,1),100)
$$;

create or replace function public.game_history(p_offset integer default 0,p_limit integer default 30)
returns table(result_id bigint,game_key text,created_at timestamptz,placement integer,score integer,won boolean)
language sql stable security invoker as $$
 select r.id,r.game_key,r.created_at,p.placement,p.score,(r.winner_id=auth.uid())
 from public.game_players p join public.game_results r on r.id=p.result_id
 where p.user_id=auth.uid() order by r.created_at desc
 offset greatest(p_offset,0) limit least(greatest(p_limit,1),100)
$$;
grant execute on function public.lexi_library(integer,integer,text,text) to authenticated;
grant execute on function public.game_history(integer,integer) to authenticated;