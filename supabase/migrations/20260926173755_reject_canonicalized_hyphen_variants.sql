-- Automatically reject orthographic variants when a clean, sourced canonical form is already ready.
-- Equivalence is deliberately narrow: same POS and identical spelling after removing hyphens.

with choices as (
  select p.id,
         (
           select r.source_url
           from public.lexicon r
           where r.content_status='ready'
             and nullif(btrim(r.definition),'') is not null
             and r.source_url like 'https://fr.wiktionary.org/wiki/%'
             and upper(r.pos)=upper(p.pos)
             and lower(replace(r.word,'-',''))=lower(replace(p.word,'-',''))
             and lower(r.word)<>lower(p.word)
           order by
             case r.source
               when 'Le Salon starter lexicon' then 0
               when 'Wiktionnaire fr + Lexique 4' then 1
               when 'Lexique 4 + Wiktionnaire' then 2
               else 3
             end,
             coalesce(r.learning_value,r.native_score,r.difficulty*20) desc nulls last,
             r.id
           limit 1
         ) as evidence_url
  from public.lexicon p
  where p.curation_state='pending_source'
    and p.source='Lexique 4'
    and p.content_status='hidden'
    and nullif(btrim(p.definition),'') is null
    and exists (
      select 1
      from public.lexicon r
      where r.content_status='ready'
        and nullif(btrim(r.definition),'') is not null
        and r.source_url like 'https://fr.wiktionary.org/wiki/%'
        and upper(r.pos)=upper(p.pos)
        and lower(replace(r.word,'-',''))=lower(replace(p.word,'-',''))
        and lower(r.word)<>lower(p.word)
    )
)
update public.lexicon p
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url=c.evidence_url,
    curated_at=now()
from choices c
where p.id=c.id;
