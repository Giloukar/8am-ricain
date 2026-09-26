# LexiMind advanced corpus

Candidate selection is built from Lexique (New, Pallier et al.), distributed under CC BY-SA 4.0.

The builder keeps lemma forms only, restricts the corpus to nouns/adjectives/verbs/adverbs, removes very common vocabulary, and computes a reproducible native-level score from corpus frequency and lexical length. Candidates are not exposed to learners until their definition has been hydrated and their `content_status` becomes `ready`.

Run:

`python scripts/build_advanced_lexicon.py --limit 8000`

Source: https://www.lexique.org/ (Lexique 4, 2026, CC BY-SA 4.0)

Hydration:

`python scripts/hydrate_wiktionary.py data/leximind-advanced-candidates.json --output data/leximind-hydrated.json`

Wiktionary-derived definitions retain source URLs and attribution. Hydrated rows remain candidates when no usable French definition is extracted. Do not publish a bulk batch without checking corpus quality metrics.
