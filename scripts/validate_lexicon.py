#!/usr/bin/env python3
import json,re,sys,collections
rows=json.load(open(sys.argv[1],encoding="utf-8"));ready=[r for r in rows if r.get("content_status")=="ready"]
bad=[];seen=set()
for r in ready:
 w=(r.get("word") or "").strip().lower();d=(r.get("definition") or "").strip()
 reasons=[]
 if not re.fullmatch(r"[a-zàâäçéèêëîïôöùûüÿœæ-]{4,30}",w):reasons.append("word")
 if len(d)<12 or len(d)>420:reasons.append("definition_length")
 if w in seen:reasons.append("duplicate")
 if r.get("difficulty",0)<3:reasons.append("difficulty")\n if not r.get("word") or r.get("word") != r.get("lemma"): reasons.append("lemma")
 if not r.get("source_url"):reasons.append("provenance")
 seen.add(w)
 if reasons:bad.append((w,reasons))
print({"rows":len(rows),"ready":len(ready),"invalid":len(bad),"difficulty":dict(collections.Counter(r.get("difficulty") for r in ready))})
if bad:
 print("sample invalid",bad[:20]);sys.exit(1)
if len(ready)<max(100,int(len(rows)*.25)):
 print("Too few hydrated entries; refusing bulk publication.");sys.exit(2)
