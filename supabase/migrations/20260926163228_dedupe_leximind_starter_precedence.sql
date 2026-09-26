-- Prefer curated starter definitions when an imported row has the same normalized word and POS.
update public.lexicon imported
set content_status='hidden'
where imported.content_status='ready'
  and imported.source <> 'Le Salon starter lexicon'
  and exists (
    select 1
    from public.lexicon starter
    where starter.content_status='ready'
      and starter.source='Le Salon starter lexicon'
      and lower(starter.word)=lower(imported.word)
      and upper(starter.pos)=upper(imported.pos)
      and starter.id<>imported.id
  );
