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

Normal discovery serves **difficulty 4–5** by default. For Lexique-derived entries, native-speaker difficulty is calibrated at **72+ for difficulty 4** and **84+ for difficulty 5**. Difficulty-3 entries remain in the database for compatibility/search/history but are not part of standard discovery.

Published discovery rows must also have a non-empty definition and one of the supported POS values (`NOM`, `ADJ`, `VER`, `ADV`). Review/quiz RPCs enforce the same publication guard so a word later hidden during corpus QA cannot leak back through an old progress record.

## Current production state

After the 26 September 2026 corpus-quality pass:

- `lexicon`: **14,807** rows total;
- `ready`: **10,780**;
- `hidden`: **4,027**;
- standard advanced discovery (difficulty 4–5, clean definition/POS): **9,442**;
- ready rows with a blank definition: **0**;
- ready same-word + same-POS duplicate groups: **0**.

The source breakdown is:
- `Lexique 4 + Wiktionnaire`: 6,564 ready / 24 hidden;
- `Wiktionnaire fr + Lexique 4`: 4,144 ready / 33 hidden;
- `Lexique 4`: 2,271 hidden rows awaiting a trustworthy definition;
- `Wiktionnaire/DBnary`: 1,691 hidden legacy rows pending selective QA;
- `Le Salon starter lexicon`: 79 ready / 1 hidden.

The QA pass preserves provenance and rows rather than deleting uncertain data. Pure spelling redirects, terse abbreviation/ellipsis redirects, audited malformed definitions and imported duplicates of curated starter entries are hidden until they can be rehydrated from a trustworthy lexical source.

A database constraint now prevents future `ready` rows from being published without both a non-empty definition and a supported POS. Audited extraction fragments are repaired only when the surviving text is already source-backed; otherwise they stay hidden.

## Rebuild

`python scripts/build_advanced_lexicon.py --limit 9000`

Source: https://lexique.org/ (Lexique 4, 2026, CC BY-SA 4.0)

Wiktionary-derived definitions retain source URLs and attribution. Do not bulk-publish a rebuilt corpus without checking duplicate spellings, malformed markup and the distribution of difficulty/prevalence.
