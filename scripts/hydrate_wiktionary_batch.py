#!/usr/bin/env python3
import argparse,json,re,time,urllib.parse,urllib.request,html,pathlib
API="https://fr.wiktionary.org/w/api.php"
POS={"NOM":"nom","ADJ":"adjectif","VER":"verbe","ADV":"adverbe"}
def clean(s):
 s=re.sub(r"<!--.*?-->","",s,flags=re.S);s=re.sub(r"<ref[^>]*>.*?</ref>","",s,flags=re.S);s=re.sub(r"<ref[^>]*/>","",s)
 s=re.sub(r"\{\{lien\|([^|}]+).*?\}\}",r"\1",s);s=re.sub(r"\{\{(?:term|m|l)\|[^|}]+\|([^|}]+).*?\}\}",r"\1",s)
 s=re.sub(r"\{\{[^{}]*\}\}","",s);s=re.sub(r"\[\[([^]|]+)\|([^]]+)\]\]",r"\2",s);s=re.sub(r"\[\[([^]]+)\]\]",r"\1",s)
 s=re.sub(r"''+","",s);s=re.sub(r"<[^>]+>","",s);s=html.unescape(s);s=re.sub(r"\s+"," ",s).strip(" ;:–-")
 return s
def extract(wikitext,pos):
 m=re.search(r"==\s*\{\{langue\|fr\}\}\s*==(.*?)(?=\n==[^=]|\Z)",wikitext,re.S|re.I)
 if not m:return None
 fr=m.group(1);target=POS.get(pos,"")
 sections=re.split(r"(?=^===)",fr,flags=re.M)
 preferred=[s for s in sections if re.search(r"\{\{S\|"+re.escape(target)+r"(?:\||\}\})",s,re.I)]
 for sec in preferred+sections:
  for line in sec.splitlines():
   if re.match(r"^#(?![:*#])\s*\S",line):
    d=clean(re.sub(r"^#\s*","",line))
    if 18<=len(d)<=360 and not re.match(r"^(forme|variante|pluriel|féminin|masculin|participe)\b",d,re.I):return d
 return None
def fetch(titles):
 q=urllib.parse.urlencode({"action":"query","prop":"revisions","titles":"|".join(titles),"rvprop":"content","rvslots":"main","formatversion":"2","format":"json"})
 req=urllib.request.Request(API+"?"+q,headers={"User-Agent":"LeSalon-LexiMind/1.0 (educational vocabulary corpus)"})
 return json.load(urllib.request.urlopen(req,timeout=90))
def main():
 ap=argparse.ArgumentParser();ap.add_argument("input");ap.add_argument("--output",default="data/leximind-production.json");ap.add_argument("--target",type=int,default=4000);a=ap.parse_args()
 cand=json.load(open(a.input,encoding="utf-8"));out=[]
 for i in range(0,len(cand),50):
  batch=cand[i:i+50]
  try:data=fetch([x["word"] for x in batch])
  except Exception as e: print("batch failed",i,e);time.sleep(2);continue
  pages={p.get("title","").lower():p for p in data.get("query",{}).get("pages",[])}
  for x in batch:
   p=pages.get(x["word"].lower()); rev=(p or {}).get("revisions") or []
   if not rev:continue
   wt=rev[0].get("slots",{}).get("main",{}).get("content","");d=extract(wt,x["pos"])
   if d:
    y=dict(x);y.update({"definition":d,"source":"Lexique 4 + Wiktionnaire","source_url":"https://fr.wiktionary.org/wiki/"+urllib.parse.quote(x["word"]),"content_status":"ready"});out.append(y)
  print(i+len(batch),"checked",len(out),"ready")
  if len(out)>=a.target:break
  time.sleep(.12)
 out=out[:a.target];pathlib.Path(a.output).parent.mkdir(parents=True,exist_ok=True);json.dump(out,open(a.output,"w",encoding="utf-8"),ensure_ascii=False,indent=2)
 print("READY",len(out),"sample",[x["word"] for x in out[:25]])
 if len(out)<min(1500,a.target):raise SystemExit("quality gate: insufficient definitions")
if __name__=="__main__":main()
