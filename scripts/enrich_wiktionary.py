#!/usr/bin/env python3
import argparse,json,re,time,urllib.parse,urllib.request,pathlib,html
API="https://fr.wiktionary.org/w/api.php"
BAD=("forme de ","pluriel de ","féminin de ","masculin de ","participe passé de ","conjugaison de ","variante de ","orthographe de ")
def clean(s):
 s=re.sub(r"<!--.*?-->","",s);s=re.sub(r"<ref[^>]*>.*?</ref>","",s,flags=re.S)
 s=re.sub(r"\{\{lien\|([^|}]+).*?\}\}",r"\1",s);s=re.sub(r"\{\{w\|([^|}]+).*?\}\}",r"\1",s)
 s=re.sub(r"\[\[([^]|]+)\|([^]]+)\]\]",r"\2",s);s=re.sub(r"\[\[([^]]+)\]\]",r"\1",s)
 s=re.sub(r"\{\{[^{}]*\}\}","",s);s=re.sub(r"'{2,5}","",s);s=re.sub(r"<[^>]+>","",s)
 return html.unescape(re.sub(r"\s+"," ",s)).strip(" ;:.")+"."
def definition(wikitext):
 m=re.search(r"==\s*\{\{langue\|fr\}\}\s*==(?P<x>.*?)(?=
==[^=]|\Z)",wikitext,re.S)
 if not m:return None
 for line in m.group("x").splitlines():
  if not re.match(r"^#(?![:*#])\s+",line):continue
  d=clean(re.sub(r"^#\s+","",line))
  low=d.lower()
  if 18<=len(d)<=360 and not any(x in low for x in BAD) and not d.startswith("."):return d
 return None
def fetch(words):
 params={"action":"query","format":"json","formatversion":"2","prop":"revisions","rvprop":"content","rvslots":"main","redirects":"1","titles":"|".join(words)}
 payload=urllib.parse.urlencode(params).encode("utf-8")
 req=urllib.request.Request(API,data=payload,headers={"User-Agent":"LeSalon-LexiMind/1.0 (educational vocabulary corpus)","Content-Type":"application/x-www-form-urlencoded"})
 data=json.load(urllib.request.urlopen(req,timeout=60));out={}
 for p in data.get("query",{}).get("pages",[]):
  if p.get("missing"):continue
  raw=((p.get("revisions")or[{}])[0].get("slots")or{}).get("main",{}).get("content","")
  d=definition(raw)
  if d:out[p["title"].lower()]=d
 return out
def main():
 ap=argparse.ArgumentParser();ap.add_argument("--input",required=True);ap.add_argument("--output",required=True);ap.add_argument("--batch",type=int,default=40);a=ap.parse_args()
 rows=json.loads(pathlib.Path(a.input).read_text());good=[]
 for i in range(0,len(rows),a.batch):
  batch=rows[i:i+a.batch]
  try:defs=fetch([x["word"] for x in batch])
  except Exception as e:print("batch error",i,e);time.sleep(2);continue
  for x in batch:
   d=defs.get(x["word"].lower())
   if d:
    x.update(definition=d,example=None,source="Lexique 4 + Wiktionnaire",source_url="https://fr.wiktionary.org/wiki/"+urllib.parse.quote(x["word"]),content_status="ready");good.append(x)
  print(i+len(batch),"/",len(rows),"ready",len(good),flush=True);time.sleep(.12)
 pathlib.Path(a.output).write_text(json.dumps(good,ensure_ascii=False),encoding="utf-8")
 ratio=len(good)/max(1,len(rows));print("READY",len(good),"RATIO",round(ratio,3))
 if len(good)<1500 or ratio<.25:raise SystemExit("quality gate failed")
if __name__=="__main__":main()
