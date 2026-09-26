-- Reviewed LexiMind curation batch 004.

update public.lexicon
set definition='Déçu, dépité ou décontenancé par un revers ou une contrariété.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/d%C3%A9confit',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/d%C3%A9confit',
    curated_at=now()
where lower(word)='déconfit' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Advenu ; surtout employé dans des expressions négatives comme « non avenu ».',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/avenu',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curation_source_url='https://fr.wiktionary.org/wiki/avenu',
    curated_at=now()
where lower(word)='avenu' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='inflected_form',
    curation_source_url='https://fr.wiktionary.org/wiki/converse',
    curated_at=now()
where lower(word)='converse' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='orthographic_variant',
    curation_source_url='https://fr.wiktionary.org/wiki/bipartite',
    curated_at=now()
where lower(word)='bipartite' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/%C3%A9poxy',
    curated_at=now()
where lower(word)='époxy' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='pos_mismatch',
    curation_source_url='https://fr.wiktionary.org/wiki/staccato',
    curated_at=now()
where lower(word)='staccato' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',
    curation_reason='inflected_form',
    curation_source_url='https://fr.wiktionary.org/wiki/occis',
    curated_at=now()
where lower(word)='occis' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source'
  and nullif(btrim(definition),'') is null;
