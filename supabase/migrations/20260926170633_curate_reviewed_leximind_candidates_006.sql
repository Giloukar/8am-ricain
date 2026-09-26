-- Reviewed LexiMind curation batch 006.

update public.lexicon
set definition='Anatomie. Bassin osseux, partie inférieure du tronc reliant la colonne vertébrale aux membres inférieurs.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/pelvis',
    content_status='ready',curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/pelvis',
    curated_at=now()
where lower(word)='pelvis' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Chimie. Ion positif NH₄⁺, présent notamment dans de nombreux sels d’ammonium.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/ammonium',
    content_status='ready',curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/ammonium',
    curated_at=now()
where lower(word)='ammonium' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Jeune femme ou demoiselle italienne ; équivalent de « mademoiselle ».',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/signorina',
    content_status='ready',curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/signorina',
    curated_at=now()
where lower(word)='signorina' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/beluga',curated_at=now()
where lower(word)='beluga' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/beluga',curated_at=now()
where lower(word)='beluga' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/chateaubriand',curated_at=now()
where lower(word)='chateaubriand' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='regional_low_value',
    curation_source_url='https://fr.wiktionary.org/wiki/pensionn%C3%A9',curated_at=now()
where lower(word)='pensionné' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/s%C3%A9mite',curated_at=now()
where lower(word)='sémite' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;
