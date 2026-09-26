# LexiMind advanced corpus

Candidate selection is built from Lexique (New, Pallier et al.), distributed under CC BY-SA 4.0.

The builder keeps lemma forms only, restricts the corpus to nouns/adjectives/verbs/adverbs, removes very common vocabulary, and computes a reproducible native-level score from corpus frequency and lexical length. Candidates are not exposed to learners until their definition has been hydrated and their `content_status` becomes `ready`.

Run:

`python scripts/build_advanced_lexicon.py --limit 8000`

Source: https://www.lexique.org/
