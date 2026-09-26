-- Infinite feed + server-side quiz pools. The browser never needs the whole learned corpus.
create or replace function public.lexi_learned_sample(p_limit integer default 20,p_seed bigint default 1)
returns table(id bigint,word text,pos text,definition text,example text,difficulty smallint,level smallint,stability real,due_at timestamptz)
language sql stable security invoker as $$
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,p.level,p.stability,p.due_at
 from public.lexi_progress p join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid()
 order by md5(l.id::text||':'||p_seed::text)
 limit least(greatest(p_limit,1),100)
$$;

create or replace function public.lexi_quiz_pack(p_limit integer default 20,p_seed bigint default 1)
returns table(id bigint,word text,pos text,definition text,example text,difficulty smallint,level smallint,stability real,due_at timestamptz)
language sql stable security invoker as $$
 (select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,p.level,p.stability,p.due_at
  from public.lexi_progress p join public.lexicon l on l.id=p.word_id
  where p.user_id=auth.uid() and not p.known and p.due_at<=now()
  order by p.due_at asc limit greatest(1,least(p_limit,100)/2))
 union all
 (select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,p.level,p.stability,p.due_at
  from public.lexi_progress p join public.lexicon l on l.id=p.word_id
  where p.user_id=auth.uid()
  order by md5(l.id::text||':'||p_seed::text)
  limit greatest(1,least(p_limit,100)/2))
 limit least(greatest(p_limit,1),100)
$$;
grant execute on function public.lexi_learned_sample(integer,bigint) to authenticated;
grant execute on function public.lexi_quiz_pack(integer,bigint) to authenticated;