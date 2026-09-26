#!/usr/bin/env python3
"""Build an advanced French lemma corpus from Lexique 3/4-compatible TSV.
Source: Lexique 4 (CC BY-SA 4.0), released in 2026.
Output contains candidates only; definitions are hydrated separately before publication.
"""
import argparse,csv,json,math,re,urllib.request
URL="https://www.lexique.org/databases/Lexique400/Lexique400.tsv"
KEEP={"NOM","ADJ","VER","ADV"}
def f(x):
 try:return float(x or 0)
 except:return 0.0
def main():
 ap=argparse.ArgumentParser();ap.add_argument("--input");ap.add_argument("--output",default="data/leximind-advanced-candidates.json");ap.add_argument("--limit",type=int,default=8000);a=ap.parse_args()
 src=a.input
 if not src:
  src="/tmp/Lexique383.tsv";urllib.request.urlretrieve(URL,src)
 best={}
 with open(src,encoding="utf-8") as h:
  for r in csv.DictReader(h,delimiter="\t"):
   lemma=(r.get("lemme") or "").strip().lower(); ortho=(r.get("ortho") or "").strip().lower(); pos=(r.get("cgram") or "").strip()
   if pos not in KEEP or not lemma or ortho!=lemma or len(lemma)<5 or len(lemma)>24 or not re.fullmatch(r"[a-zàâäçéèêëîïôöùûüÿœæ-]+",lemma):continue
   freq=max(f(r.get("freqlemfilms2")),f(r.get("freqlemlivres")))
   # Exclude extremely common vocabulary and ultra-obscure/no-attestation noise.
   if freq>18 or freq<=0:continue
   # Low frequency + length gives a reproducible native challenge score.
   score=max(0,min(100,55+12*math.log10(18/max(freq,.01))+min(14,max(0,len(lemma)-7)*1.4)))
   difficulty=5 if score>=78 else 4 if score>=64 else 3
   row={"word":lemma,"lemma":lemma,"pos":pos,"frequency":round(freq,4),"native_score":round(score,2),"difficulty":difficulty,"source":"Lexique4","source_url":URL,"content_status":"candidate"}
   if lemma not in best or row["native_score"]>best[lemma]["native_score"]:best[lemma]=row
 rows=sorted(best.values(),key=lambda x:(-x["native_score"],x["frequency"],x["word"]))[:a.limit]
 import pathlib;pathlib.Path(a.output).parent.mkdir(parents=True,exist_ok=True)
 with open(a.output,"w",encoding="utf-8") as h:json.dump(rows,h,ensure_ascii=False,separators=(",",":"))
 print(f"{len(rows)} advanced lemma candidates -> {a.output}")
if __name__=="__main__":main()
