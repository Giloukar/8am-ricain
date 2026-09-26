-- Reviewed LexiMind curation batch 011: remove sourced variants and POS mismatches.

update public.lexicon
set curation_state='rejected',
    curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/ladite',
    curated_at=now()
where lower(word)='ladite' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/petit-enfant',
    curated_at=now()
where lower(word)='petit-enfant' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/outre-tombe',
    curated_at=now()
where lower(word)='outre-tombe' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/hippy',
    curated_at=now()
where lower(word)='hippy' and upper(pos) in ('ADJ','NOM')
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/class',
    curated_at=now()
where lower(word)='class' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;
