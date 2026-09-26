-- Seed the remaining advanced blank-definition Lexique rows into the review queue.
update public.lexicon
set curation_state='pending_source',
    curation_reason=null,
    curated_at=null
where content_status='hidden'
  and source='Lexique 4'
  and nullif(btrim(definition),'') is null
  and difficulty between 4 and 5
  and upper(pos) in ('NOM','VER','ADJ','ADV')
  and curation_state is null;

-- Mark the first reviewed hydration batch as explicitly approved.
update public.lexicon
set curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curated_at=now()
where source='Wiktionnaire fr + Lexique 4'
  and content_status='ready'
  and (lower(word),upper(pos)) in (
    ('ahurissant','ADJ'),('antalgique','ADJ'),('brillantissime','ADJ'),
    ('contractuellement','ADV'),('foncièrement','ADV'),('fougueusement','ADV'),
    ('frontalement','ADV'),('majestueusement','ADV'),('protestataire','ADJ')
  );

update public.lexicon
set curation_state='rejected',curation_reason='orthographic_variant',curated_at=now()
where content_status='hidden' and source='Lexique 4'
  and nullif(btrim(definition),'') is null
  and (lower(word),upper(pos)) in (
    ('anti-terroriste','ADJ'),('terre-à-terre','ADJ'),('vioque','ADJ'),
    ('extrascolaire','ADJ'),('socioéconomique','ADJ'),('contreproductif','ADJ'),
    ('récrire','VER'),('désaouler','VER'),('béqueter','VER'),
    ('gratouiller','VER'),('jodler','VER')
  );

update public.lexicon
set curation_state='rejected',curation_reason='archaic_or_redirect_form',curated_at=now()
where content_status='hidden' and source='Lexique 4'
  and nullif(btrim(definition),'') is null
  and lower(word)='courre' and upper(pos)='VER';

update public.lexicon
set curation_state='rejected',curation_reason='pos_mismatch',curated_at=now()
where content_status='hidden' and source='Lexique 4'
  and nullif(btrim(definition),'') is null
  and lower(word)='neuroscientifique' and upper(pos)='ADJ';

update public.lexicon
set curation_state='rejected',curation_reason='pronominal_mismatch',curated_at=now()
where content_status='hidden' and source='Lexique 4'
  and nullif(btrim(definition),'') is null
  and lower(word)='ressouvenir' and upper(pos)='VER';

update public.lexicon
set curation_state='rejected',curation_reason='no_stable_lexical_entry',curated_at=now()
where content_status='hidden' and source='Lexique 4'
  and nullif(btrim(definition),'') is null
  and (lower(word),upper(pos)) in (('hémodynamique','ADJ'),('obsessivement','ADV'));

update public.lexicon
set definition='Par instinct, sous l’impulsion spontanée de l’instinct.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/instinctivement',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curated_at=now()
where lower(word)='instinctivement' and upper(pos)='ADV'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Frapper ; verbe ancien ou littéraire, surtout conservé dans quelques expressions.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/f%C3%A9rir',
    content_status='ready',
    curation_state='approved',
    curation_reason='wiktionary_pos_and_sense_verified',
    curated_at=now()
where lower(word)='férir' and upper(pos)='VER'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;
