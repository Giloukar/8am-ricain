create or replace function public.lexi_answer_reference(p_word_id bigint)
returns table(word text,definition text,pos text) language sql stable security invoker as $$
 select l.word,l.definition,l.pos from public.lexicon l
 where l.id=p_word_id and (auth.uid() is null or exists(select 1 from public.lexi_progress p where p.user_id=auth.uid() and p.word_id=l.id))
 limit 1
$$;
grant execute on function public.lexi_answer_reference(bigint) to anon,authenticated;