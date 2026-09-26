-- Standard LexiMind discovery is now native-speaker advanced vocabulary only.
create or replace function public.lexi_new_words(p_limit integer default 20,p_min_difficulty integer default 4,p_max_difficulty integer default 5)
returns setof public.lexicon language sql stable security invoker set search_path='' as $$
 select l.* from public.lexicon l
 where l.content_status='ready'
 and l.difficulty between greatest(4,p_min_difficulty) and least(5,p_max_difficulty)
 and (auth.uid() is null or not exists(select 1 from public.lexi_progress p where p.user_id=auth.uid() and p.word_id=l.id))
 order by coalesce(l.learning_value,l.native_score,l.difficulty*20) desc,md5(l.id::text||':'||extract(doy from current_date)::text)
 limit least(greatest(p_limit,1),50) $$;

create or replace function public.lexi_session_page(p_seed bigint default 1,p_offset integer default 0,p_limit integer default 25,p_min_difficulty integer default 4,p_max_difficulty integer default 5)
returns setof public.lexicon language sql stable security invoker set search_path='' as $$
 select l.* from public.lexicon l
 where l.content_status='ready'
 and l.difficulty between greatest(4,p_min_difficulty) and least(5,p_max_difficulty)
 and (auth.uid() is null or not exists(select 1 from public.lexi_progress p where p.user_id=auth.uid() and p.word_id=l.id))
 order by coalesce(l.learning_value,l.native_score,l.difficulty*20) desc,md5(l.id::text||':'||p_seed::text)
 offset greatest(p_offset,0) limit least(greatest(p_limit,1),100) $$;
