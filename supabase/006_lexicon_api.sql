-- Server-side LexiMind dictionary API
create index if not exists lexicon_word_lower_idx on public.lexicon(lower(word));
create index if not exists lexicon_rank_idx on public.lexicon(frequency_rank nulls last);
create index if not exists lexicon_difficulty_idx on public.lexicon(difficulty);

create or replace function public.lexi_new_words(p_limit integer default 20,p_min_difficulty integer default 1,p_max_difficulty integer default 5)
returns setof public.lexicon language sql stable security invoker as $$
 select l.* from public.lexicon l
 where l.difficulty between greatest(1,p_min_difficulty) and least(5,p_max_difficulty)
 and (auth.uid() is null or not exists(select 1 from public.lexi_progress p where p.user_id=auth.uid() and p.word_id=l.id))
 order by random() limit least(greatest(p_limit,1),50)
$$;

create or replace function public.lexi_due_words(p_limit integer default 30)
returns table(id bigint,word text,pos text,definition text,example text,difficulty smallint,level smallint,stability real,user_difficulty real,due_at timestamptz,lapses integer,last_rating smallint)
language sql stable security invoker as $$
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,p.level,p.stability,p.difficulty,p.due_at,p.lapses,p.last_rating
 from public.lexi_progress p join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid() and not p.known and p.due_at<=now()
 order by p.due_at asc,p.lapses desc limit least(greatest(p_limit,1),100)
$$;

create or replace function public.lexi_search(p_query text,p_limit integer default 30)
returns setof public.lexicon language sql stable security invoker as $$
 select * from public.lexicon
 where lower(word) like lower(trim(p_query))||'%' or lower(definition) like '%'||lower(trim(p_query))||'%'
 order by case when lower(word)=lower(trim(p_query)) then 0 else 1 end,frequency_rank nulls last
 limit least(greatest(p_limit,1),50)
$$;
grant execute on function public.lexi_new_words(integer,integer,integer) to anon,authenticated;
grant execute on function public.lexi_due_words(integer) to authenticated;
grant execute on function public.lexi_search(text,integer) to anon,authenticated;