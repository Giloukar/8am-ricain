-- Reviewed LexiMind curation batch 012: sourced inflected forms and spelling variants.

update public.lexicon
set curation_state='rejected',
    curation_reason='inflected_form',
    curation_source_url='https://fr.wiktionary.org/wiki/petit-bourgeois',
    curated_at=now()
where lower(word)='petite-bourgeoise' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='inflected_form',
    curation_source_url='https://fr.wiktionary.org/wiki/sacrifiable',
    curated_at=now()
where lower(word)='sacrifiables' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='inflected_form',
    curation_source_url='https://fr.wiktionary.org/wiki/subspatial',
    curated_at=now()
where lower(word)='subspatiaux' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/hydro%C3%A9lectrique',
    curated_at=now()
where lower(word)='hydro-électrique' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/ultraviolet',
    curated_at=now()
where lower(word)='ultra-violet' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;
