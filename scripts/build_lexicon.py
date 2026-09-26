#!/usr/bin/env python3
"""Kaikki/Wiktextract French JSONL -> compact LexiMind CSV.
Usage: python scripts/build_lexicon.py input.jsonl output.csv --limit 150000
"""
import argparse,csv,json,re,sys
p=argparse.ArgumentParser();p.add_argument("input");p.add_argument("output");p.add_argument("--limit",type=int,default=150000);a=p.parse_args()
allowed={"noun","verb","adj","adv","name","phrase","interj"}
bad_tags={"obsolete","archaic","historical","misspelling","alt-of","form-of"}
seen=set();n=0
with open(a.input,encoding="utf8") as src,open(a.output,"w",newline="",encoding="utf8") as dst:
 w=csv.writer(dst);w.writerow(["word","lemma","pos","definition","example","difficulty","source","source_url"])
 for line in src:
  try:o=json.loads(line)
  except:continue
  if o.get("lang_code") not in (None,"fr"):continue
  word=(o.get("word") or "").strip()
  if not 2<=len(word)<=40 or re.search(r"[0-9_=\\/]",word):continue
  pos=o.get("pos") or ""; 
  if pos and pos not in allowed:continue
  senses=o.get("senses") or []
  for s in senses:
   tags=set(s.get("tags") or [])
   if tags & bad_tags:continue
   glosses=s.get("glosses") or s.get("raw_glosses") or []
   if not glosses:continue
   definition=str(glosses[0]).strip()
   if not 8<=len(definition)<=500:continue
   key=(word.lower(),pos,definition.lower())
   if key in seen:continue
   seen.add(key)
   examples=s.get("examples") or [];ex=""
   if examples and isinstance(examples[0],dict):ex=(examples[0].get("text") or "")[:350]
   forms=o.get("forms") or [];lemma=word
   source_url="https://fr.wiktionary.org/wiki/"+word.replace(" ","_")
   # heuristic difficulty until frequency corpus is joined
   difficulty=3+(len(word)>11)+(len(word)>16)
   w.writerow([word,lemma,pos,definition,ex,min(5,difficulty),"Wiktionary / Kaikki",source_url]);n+=1
   if n>=a.limit:print("written",n,file=sys.stderr);sys.exit(0)
print("written",n,file=sys.stderr)
