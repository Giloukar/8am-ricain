# LexiMind advanced corpus

LexiMind uses **Lexique 4** (New, Pallier et al., CC BY-SA 4.0) to rank French lemmas, then hydrates selected entries with definitions from the French Wiktionary.

## Production selection

The native-speaker filter keeps nouns, adjectives, verbs and adverbs only. It rejects:
- non-lemma inflected forms;
- extremely common or ultra-obscure frequency tails;
- orthographic forms that are mainly a frequent inflection of another lemma;
- homographs whose other part of speech is overwhelmingly more frequent;
- very low-context-diversity noise.

The score combines Lexique 4 lemma frequency, contextual diversity (`13_CDOrtho`), prevalence (`33_Preval`), lexical length and homograph penalties.

Normal discovery serves **difficulty 4–5** by default. Difficulty-3 entries may remain in the database for compatibility/review history but are not part of the standard discovery feed.

## Current production import

On 26 September 2026 the mass import produced:
- 6,588 new `ready` entries from Lexique 4 + French Wiktionary;
- 2,271 rejected/hidden candidates with no sufficiently clean definition;
- 1,691 existing Wiktionary/DBnary ready entries retained;
- 80 original starter entries retained.

That leaves **8,359 ready entries** in production, including **7,844 difficulty-4/5 entries**.

Candidates are never exposed until their definition passes the hydration checks.

## Rebuild

`python scripts/build_advanced_lexicon.py --limit 9000`

Source: https://lexique.org/ (Lexique 4, 2026, CC BY-SA 4.0)

Wiktionary-derived definitions retain source URLs and attribution. Do not bulk-publish a rebuilt corpus without checking duplicate spellings, malformed markup and the distribution of difficulty/prevalence.
