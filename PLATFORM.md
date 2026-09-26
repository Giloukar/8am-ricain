# Le Salon — plateforme commune

## Architecture
- index.html: portail
- jeux.html: La Table de jeux
- leximind.html: LexiMind
- shared/: compte Supabase commun
- supabase/schema.sql: profils, progression lexicale, résultats de jeux, leaderboard et achievements
- scripts/: pipeline futur d'import Wiktionary/Kaikki

## Activation des comptes
1. Créer un projet Supabase.
2. Exécuter supabase/schema.sql.
3. Mettre URL + publishable key dans shared/config.js. Ne jamais mettre service_role dans le navigateur.
4. Ajouter l'URL GitHub Pages aux redirect URLs Auth.

Le mode local continue de fonctionner tant que Supabase n'est pas configuré.

## Corpus
Le corpus cible est Wiktionary via Kaikki/Wiktextract. Ne pas committer le dump brut multi-Go.
Prétraiter en lemmes utiles, conserver attribution/source_url et charger dans Postgres par lots.

## Prochaine phase
Brancher LexiMind sur lexicon/lexi_progress, migrer localStorage au premier login, puis enregistrer les fins de parties dans game_results/game_players.
