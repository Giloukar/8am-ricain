# Import du gros lexique LexiMind

Source cible : export français Kaikki/Wiktextract (JSONL), dérivé du Wiktionnaire.

## 1. Construire le CSV
```
python scripts/build_lexicon.py kaikki-fr.jsonl lexicon.csv --limit 150000
```

Le script filtre les entrées inutilisables, formes obsolètes/variantes, définitions trop pauvres, doublons, et conserve mot, lemme, catégorie grammaticale, définition, exemple, difficulté et URL d'attribution.

## 2. Importer dans PostgreSQL/Supabase
Pour un gros corpus, utiliser psql/COPY plutôt que le navigateur :
```
\copy public.lexicon(word,lemma,pos,definition,example,difficulty,source,source_url) FROM 'lexicon.csv' WITH (FORMAT csv,HEADER true,ENCODING 'UTF8')
```

## 3. Après import
```
analyze public.lexicon;
select count(*) from public.lexicon;
```

Ne jamais envoyer le dump Kaikki complet au navigateur ni le committer dans GitHub.

## Architecture runtime
LexiMind -> fonctions RPC SQL -> quelques mots -> navigateur.
La table lexicon reste sur PostgreSQL et constitue la source de vérité.
