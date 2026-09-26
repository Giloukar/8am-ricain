-- Reviewed LexiMind curation batch 005.

update public.lexicon
set definition='Familier. Mou, ramolli ; qui manque de fermeté ou d’énergie.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/ramollo',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/ramollo',
    curated_at=now()
where lower(word)='ramollo' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/maous',curated_at=now()
where lower(word)='maous' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/chnoque',curated_at=now()
where lower(word)='chnoque' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/schnoque',curated_at=now()
where lower(word)='schnoque' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/flicard',curated_at=now()
where lower(word)='flicard' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/donnant-donnant',curated_at=now()
where lower(word)='donnant-donnant' and upper(pos)='ADV'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='no_stable_lexical_entry',
    curation_source_url='https://fr.wiktionary.org/wiki/nonsense',curated_at=now()
where lower(word)='nonsense' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='regional_low_value',
    curation_source_url='https://fr.wiktionary.org/wiki/poter',curated_at=now()
where lower(word)='poter' and upper(pos)='VER'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;
