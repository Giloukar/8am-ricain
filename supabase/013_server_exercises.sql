-- Server-generated MCQ packs: one target + plausible distractors.
create or replace function public.lexi_mcq(p_word_id bigint,p_seed bigint default 1)
returns table(id bigint,word text,pos text,definition text,example text,difficulty smallint,is_answer boolean)
language sql stable security invoker as $$
 with target as (select * from public.lexicon where lexicon.id=p_word_id limit 1),
 distractors as (
   select l.* from public.lexicon l,target t
   where l.id<>t.id and l.pos=t.pos and abs(l.difficulty-t.difficulty)<=1
   order by md5(l.id::text||':'||p_seed::text) limit 3
 )
 select t.id,t.word,t.pos,t.definition,t.example,t.difficulty,true from target t
 union all
 select d.id,d.word,d.pos,d.definition,d.example,d.difficulty,false from distractors d
$$;

create or replace function public.lexi_next_review()
returns table(id bigint,word text,pos text,definition text,example text,difficulty smallint,level smallint,stability real,due_at timestamptz)
language sql stable security invoker as $$
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,p.level,p.stability,p.due_at
 from public.lexi_progress p join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid() and not p.known and p.due_at<=now()
 order by p.due_at asc,p.lapses desc limit 1
$$;
grant execute on function public.lexi_mcq(bigint,bigint) to anon,authenticated;
grant execute on function public.lexi_next_review() to authenticated;