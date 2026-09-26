#!/usr/bin/env python3
import argparse,csv,json,math,re,urllib.request,pathlib
URL="https://lexique.org/databases/Lexique400/Lexique400.tsv"
KEEP={"NOM","ADJ","VER","ADV"}
def num(x):
 try:return float(str(x or "0").replace(",","."))
 except:return 0.0
def pick(row,*names):
 for n in names:
  if row.get(n) not in (None,""): return row[n]
 return ""
def main():
 ap=argparse.ArgumentParser();ap.add_argument("--input");ap.add_argument("--output",default="data/leximind-candidates.json");ap.add_argument("--limit",type=int,default=7000);a=ap.parse_args()
 src=a.input or "/tmp/Lexique400.tsv"
 if not a.input:
  req=urllib.request.Request(URL,headers={"User-Agent":"LeSalon-LexiMind/1.0"});open(src,"wb").write(urllib.request.urlopen(req,timeout=120).read())
 with open(src,encoding="utf-8-sig") as h:
  rd=csv.DictReader(h,delimiter="\t"); best={}
  for r in rd:
   word=pick(r,"1_Mot","ortho").strip().lower();lemma=pick(r,"4_Lemme","lemme").strip().lower();pos=pick(r,"5_Cgram","cgram").strip().upper()
   if not lemma: lemma=word
   if pos not in KEEP or word!=lemma or len(word)<6 or len(word)>24 or not re.fullmatch(r"[a-zàâäçéèêëîïôöùûüÿœæ-]+",word):continue
   freq=num(pick(r,"12_FreqLemme","freqlemfilms2","freqlemlivres"));cd=num(pick(r,"13_CD","CD","cd"));prev=num(pick(r,"14_Prevalence","Prevalence","prevalence"))
   if freq<=0 or freq>22:continue
   rarity=max(0,min(100,48+12*math.log10(22/max(freq,.01))+min(12,max(0,len(word)-7)*1.1)))
   breadth=min(1,cd/8) if cd else min(1,freq/3); prevalence=min(1,prev/0.65) if prev else .5
   value=max(0,min(100,rarity*.55+breadth*28+prevalence*17))
   difficulty=5 if rarity>=80 else 4 if rarity>=65 else 3
   x={"word":word,"lemma":lemma,"pos":pos,"frequency":round(freq,5),"contextual_diversity":round(cd,5) if cd else None,"prevalence":round(prev,5) if prev else None,"native_score":round(rarity,2),"learning_value":round(value,2),"difficulty":difficulty}
   if word not in best or value>best[word]["learning_value"]:best[word]=x
 rows=sorted(best.values(),key=lambda x:(-x["learning_value"],-x["native_score"],x["frequency"],x["word"]))[:a.limit]
 pathlib.Path(a.output).parent.mkdir(parents=True,exist_ok=True);json.dump(rows,open(a.output,"w",encoding="utf-8"),ensure_ascii=False)
 print("candidates",len(rows),"sample",[x["word"] for x in rows[:20]])
if __name__=="__main__":main()
