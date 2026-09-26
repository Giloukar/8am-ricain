-- Paginated lexicon sessions: supports 10, 20, 50, 100+ words without loading the corpus.
create or replace function public.lexi_session_page(
 p_seed bigint default 1,p_offset integer default 0,p_limit integer default 25,
 p_min_difficulty integer default 1,p_max_difficulty integer default 5)
returns setof public.lexicon language sql stable security invoker as $$
 select l.* from public.lexicon l
 where l.difficulty between greatest(1,p_min_difficulty) and least(5,p_max_difficulty)
 and (auth.uid() is null or not exists(select 1 from public.lexi_progress p where p.user_id=auth.uid() and p.word_id=l.id))
 order by md5(l.id::text||':'||p_seed::text)
 offset greatest(p_offset,0) limit least(greatest(p_limit,1),100)
$$;
grant execute on function public.lexi_session_page(bigint,integer,integer,integer,integer) to anon,authenticated;