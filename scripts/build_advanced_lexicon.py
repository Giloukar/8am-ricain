#!/usr/bin/env python3
import argparse,csv,json,math,re,urllib.request,pathlib
URL="https://www.lexique.org/databases/Lexique400/Lexique400.tsv"
KEEP={"NOM","ADJ","VER","ADV"}
def num(x):
 try:return float(str(x or "0").replace(",","."))
 except:return 0.0
def main():
 p=argparse.ArgumentParser();p.add_argument("--input");p.add_argument("--output",default="data/leximind-advanced-candidates.json");p.add_argument("--limit",type=int,default=8000);a=p.parse_args()
 src=a.input or "/tmp/Lexique400.tsv"
 if not a.input:
  req=urllib.request.Request(URL,headers={"User-Agent":"LeSalon-LexiMind/1.0"});pathlib.Path(src).write_bytes(urllib.request.urlopen(req,timeout=90).read())
 best={}
 with open(src,encoding="utf-8-sig") as h:
  reader=csv.DictReader(h,delimiter="\t")
  for r in reader:
   lemma=(r.get("4_Lemme") or r.get("lemme") or "").strip().lower();word=(r.get("1_Mot") or r.get("ortho") or "").strip().lower();pos=(r.get("5_Cgram") or r.get("cgram") or "").strip().upper()
   if pos not in KEEP or not lemma or word!=lemma or not 5<=len(lemma)<=24 or not re.fullmatch(r"[a-zàâäçéèêëîïôöùûüÿœæ-]+",lemma):continue
   freq=num(r.get("12_FreqLemme") or r.get("freqlemfilms2") or r.get("freqlemlivres"));cd=num(r.get("13_CD") or r.get("CD"));prev=num(r.get("prevalence") or r.get("Prevalence"))
   if not 0<freq<=18:continue
   difficulty_score=max(0,min(100,52+11*math.log10(18/max(freq,.01))+min(12,max(0,len(lemma)-7)*1.2)))
   breadth=min(1,cd/8) if cd else min(1,freq/3); prevalence=min(1,prev/0.65) if prev else .55
   value=max(0,min(100,difficulty_score*.52+breadth*30+prevalence*18))
   difficulty=5 if difficulty_score>=78 else 4 if difficulty_score>=64 else 3
   row=dict(word=lemma,lemma=lemma,pos=pos,frequency=round(freq,4),native_score=round(difficulty_score,2),learning_value=round(value,2),contextual_diversity=round(cd,4) if cd else None,prevalence=round(prev,4) if prev else None,difficulty=difficulty)
   if lemma not in best or value>best[lemma]["learning_value"]:best[lemma]=row
 rows=sorted(best.values(),key=lambda x:(-x["learning_value"],-x["native_score"],x["frequency"],x["word"]))[:a.limit]
 pathlib.Path(a.output).parent.mkdir(parents=True,exist_ok=True);pathlib.Path(a.output).write_text(json.dumps(rows,ensure_ascii=False),encoding="utf-8");print("candidates",len(rows))
if __name__=="__main__":main()
