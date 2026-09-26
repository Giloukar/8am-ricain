-- Reviewed LexiMind curation batch 008.

update public.lexicon
set definition='Qui gaspille, dépense ou consomme sans mesure.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/gaspilleur',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/gaspilleur',
    curated_at=now()
where lower(word)='gaspilleur' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Qui est inconvenant, inapproprié ou contraire aux convenances.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/inconvenable',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/inconvenable',
    curated_at=now()
where lower(word)='inconvenable' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/cardio-respiratoire',
    curated_at=now()
where lower(word)='cardio-respiratoire' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='inflected_form',
    curation_source_url='https://fr.wiktionary.org/wiki/Conjugaison%3Afran%C3%A7ais/pr%C3%A9enregistrer',
    curated_at=now()
where lower(word)='préenregistré' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='inflected_form',
    curation_source_url='https://fr.wiktionary.org/wiki/surjouer',
    curated_at=now()
where lower(word)='surjoué' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;
