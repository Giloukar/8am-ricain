-- Automatically reject clear nominal plurals when a sourced canonical singular is already ready.
-- Conservative guard: NOM only, length >= 7, exact spelling canonical + "s".

with choices as (
  select p.id,r.source_url as evidence_url
  from public.lexicon p
  join public.lexicon r
    on r.content_status='ready'
   and upper(r.pos)='NOM'
   and nullif(btrim(r.definition),'') is not null
   and r.source_url like 'https://fr.wiktionary.org/wiki/%'
   and lower(p.word)=lower(r.word)||'s'
  where p.curation_state='pending_source'
    and p.source='Lexique 4'
    and p.content_status='hidden'
    and nullif(btrim(p.definition),'') is null
    and upper(p.pos)='NOM'
    and length(p.word)>=7
    and right(lower(p.word),1)='s'
)
update public.lexicon p
set curation_state='rejected',
    curation_reason='inflected_form',
    curation_source_url=c.evidence_url,
    curated_at=now()
from choices c
where p.id=c.id;
