-- Reviewed LexiMind curation batch 010: remove sourced variants and POS mismatches from the advanced queue.

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/extra-terrestre',curated_at=now()
where lower(word)='extra-terrestre' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/casse-pieds',curated_at=now()
where lower(word)='casse-pieds' and upper(pos) in ('ADJ','NOM')
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/post-op%C3%A9ratoire',curated_at=now()
where lower(word)='post-opératoire' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/free-lance',curated_at=now()
where lower(word)='free-lance' and upper(pos) in ('ADJ','NOM')
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/agro-alimentaire',curated_at=now()
where lower(word)='agro-alimentaire' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/socio-politique',curated_at=now()
where lower(word)='socio-politique' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/audio-visuel',curated_at=now()
where lower(word)='audio-visuel' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/apr%C3%A8s-rasage',curated_at=now()
where lower(word)='après-rasage' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/premier-n%C3%A9',curated_at=now()
where lower(word)='premier-né' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/vide-grenier',curated_at=now()
where lower(word)='vide-grenier' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;
