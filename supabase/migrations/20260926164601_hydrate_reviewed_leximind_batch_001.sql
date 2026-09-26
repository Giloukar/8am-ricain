-- First manually reviewed hydration batch from French Wiktionary.
-- Match by lexical identity, never by generated IDs.

update public.lexicon
set definition='Qui provoque un fort étonnement par son caractère incroyable ou stupéfiant.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/ahurissant',
    content_status='ready'
where lower(word)='ahurissant' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Qui atténue ou combat la douleur.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/antalgique',
    content_status='ready'
where lower(word)='antalgique' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Extrêmement brillant ou remarquable, à un très haut degré.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/brillantissime',
    content_status='ready'
where lower(word)='brillantissime' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Par contrat, conformément aux stipulations contractuelles.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/contractuellement',
    content_status='ready'
where lower(word)='contractuellement' and upper(pos)='ADV'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Dans le fond, d’une manière profonde ou essentielle.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/fonci%C3%A8rement',
    content_status='ready'
where lower(word)='foncièrement' and upper(pos)='ADV'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Avec fougue, avec ardeur et impétuosité.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/fougueusement',
    content_status='ready'
where lower(word)='fougueusement' and upper(pos)='ADV'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Directement, en affrontant ou en abordant quelque chose de face.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/frontalement',
    content_status='ready'
where lower(word)='frontalement' and upper(pos)='ADV'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Avec majesté, d’une manière imposante et digne.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/majestueusement',
    content_status='ready'
where lower(word)='majestueusement' and upper(pos)='ADV'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;

update public.lexicon
set definition='Qui exprime une protestation ou manifeste une opposition.',
    source='Wiktionnaire fr + Lexique 4',
    source_url='https://fr.wiktionary.org/wiki/protestataire',
    content_status='ready'
where lower(word)='protestataire' and upper(pos)='ADJ'
  and source='Lexique 4' and content_status='hidden'
  and nullif(btrim(definition),'') is null;
