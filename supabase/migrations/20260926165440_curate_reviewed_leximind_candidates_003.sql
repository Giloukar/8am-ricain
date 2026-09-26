-- Reviewed hydration batch 003: standalone French lemmas with matching POS.
update public.lexicon
set definition='Tuer, dans un emploi vieilli.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/escoffier',
    content_status='ready',curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',curated_at=now()
where lower(word)='escoffier' and upper(pos)='VER'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='En argot, recel ou personne qui reçoit et revend des objets volés.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/fourgue',
    content_status='ready',curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',curated_at=now()
where lower(word)='fourgue' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Séduction, notamment dans l’expression « faire du gringue ».',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/gringue',
    content_status='ready',curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',curated_at=now()
where lower(word)='gringue' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Figure géométrique, souvent fondée sur un pentagramme, portant des inscriptions à valeur ésotérique.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/pentacle',
    content_status='ready',curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',curated_at=now()
where lower(word)='pentacle' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Boue épaisse et liquide, souvent mêlée de neige fondue ou d’eau.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/bouillasse',
    content_status='ready',curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',curated_at=now()
where lower(word)='bouillasse' and upper(pos)='NOM'
  and source='Lexique 4' and content_status='hidden'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null;

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',curated_at=now()
where content_status='hidden' and source='Lexique 4'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null
  and (lower(word),upper(pos)) in (
    ('co-exister','VER'),('reservir','VER'),('iodler','VER'),('tocade','NOM')
  );

update public.lexicon
set curation_state='rejected',curation_reason='pronominal_mismatch',curated_at=now()
where content_status='hidden' and source='Lexique 4'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null
  and lower(word)='cuiter' and upper(pos)='VER';

update public.lexicon
set curation_state='rejected',curation_reason='pos_mismatch',curated_at=now()
where content_status='hidden' and source='Lexique 4'
  and curation_state='pending_source' and nullif(btrim(definition),'') is null
  and (lower(word),upper(pos)) in (('rétracteur','NOM'),('isolationniste','NOM'));
