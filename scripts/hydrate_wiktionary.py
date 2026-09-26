#!/usr/bin/env python3
"""Hydrate LexiMind candidates from French Wiktionary via MediaWiki Action API.
Stores extracted candidate metadata for review/import; never publishes blindly.
"""
import argparse,json,re,time,urllib.parse,urllib.request
API="https://fr.wiktionary.org/w/api.php"
UA="LeSalon-LexiMind/1.0 (https://github.com/Giloukar/LeSalon)"
HEADERS={"User-Agent":UA,"Api-User-Agent":UA}
POS={"Nom commun":"NOM","Adjectif":"ADJ","Verbe":"VER","Adverbe":"ADV"}
def fetch(word):
 q=urllib.parse.urlencode({"action":"parse","page":word,"prop":"wikitext","format":"json","formatversion":"2","redirects":"1"})
 req=urllib.request.Request(API+"?"+q,headers=HEADERS)
 try:
  with urllib.request.urlopen(req,timeout=20) as r:return json.load(r).get("parse",{}).get("wikitext","")
 except Exception:return ""
def clean(s):
 s=re.sub(r"<!--.*?-->","",s,flags=re.S);s=re.sub(r"\{\{[^{}]*\}\}","",s)
 s=re.sub(r"\[\[([^]|]+)\|([^]]+)\]\]",r"\2",s);s=re.sub(r"\[\[([^]]+)\]\]",r"\1",s)
 s=re.sub(r"'{2,}","",s);return re.sub(r"\s+"," ",s).strip(" :;.")
def extract(word,txt):
 # French section only, then first numbered lexical definition.
 m=re.search(r"==\s*\{\{langue\|fr\}\}\s*==(.+?)(?=\n==\s*\{\{langue\||\Z)",txt,re.S)
 if not m:return None
 fr=m.group(1); pm=re.search(r"===\s*\{\{S\|([^}|]+)",fr)
 pos=POS.get(pm.group(1).strip() if pm else "")
 defs=[]
 for line in fr.splitlines():
  if re.match(r"^#[^:*#]",line):
   d=clean(line[1:])
   if 12<=len(d)<=420 and not d.lower().startswith(("voir ","variante ","forme de ")):defs.append(d)
 return {"word":word,"pos":pos,"definition":defs[0] if defs else None,"source":"Wiktionnaire","source_url":"https://fr.wiktionary.org/wiki/"+urllib.parse.quote(word),"content_status":"ready" if defs else "candidate"}
def main():
 ap=argparse.ArgumentParser();ap.add_argument("input");ap.add_argument("--output",default="data/leximind-hydrated.json");ap.add_argument("--sleep",type=float,default=.12);a=ap.parse_args()
 rows=json.load(open(a.input,encoding="utf-8"));out=[]
 for i,r in enumerate(rows,1):
  x=extract(r["word"],fetch(r["word"]))
  if x:out.append({**r,**x})
  if i%100==0:print(i,len(out))
  time.sleep(a.sleep)
 with open(a.output,"w",encoding="utf-8") as h:json.dump(out,h,ensure_ascii=False,separators=(",",":"))
 print("hydrated",len(out))
if __name__=="__main__":main()
