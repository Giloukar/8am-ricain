-- Reviewed LexiMind curation batch 009.

update public.lexicon
set definition='Hongrois ; relatif aux Magyars ou à la Hongrie.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/magyar',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/magyar',
    curated_at=now()
where lower(word)='magyar' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/hawaiien',
    curated_at=now()
where lower(word)='hawaiien' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/hawaiien',
    curated_at=now()
where lower(word)='hawaiien' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/b%C3%AAta-bloquant',
    curated_at=now()
where lower(word)='bêtabloquant' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;
