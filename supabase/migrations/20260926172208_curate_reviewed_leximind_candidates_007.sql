-- Reviewed LexiMind curation batch 007.

update public.lexicon
set definition='Qui véhicule ou sert à transmettre ; notamment, en linguistique, qui permet la communication entre locuteurs de langues différentes.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/v%C3%A9hiculaire',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/v%C3%A9hiculaire',
    curated_at=now()
where lower(word)='véhiculaire' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Qui émancipe, libère d’une tutelle, d’une dépendance ou d’une contrainte.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/%C3%A9mancipateur',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/%C3%A9mancipateur',
    curated_at=now()
where lower(word)='émancipateur' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Chimie. Qui oxyde ou favorise une réaction d’oxydation.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/oxydant',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/oxydant',
    curated_at=now()
where lower(word)='oxydant' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/optronique',
    curated_at=now()
where lower(word)='optronique' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/apn%C3%A9ique',
    curated_at=now()
where lower(word)='apnéique' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;
