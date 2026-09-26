#!/usr/bin/env python3
"""Convert hydrated LexiMind JSON into idempotent SQL batches for Supabase."""
import argparse,json,pathlib
def q(v):
 if v is None:return "null"
 return "'" + str(v).replace("'","''") + "'"
def main():
 ap=argparse.ArgumentParser();ap.add_argument("input");ap.add_argument("--out",default="data/generated");ap.add_argument("--batch",type=int,default=250);a=ap.parse_args()
 rows=[r for r in json.load(open(a.input,encoding="utf-8")) if r.get("content_status")=="ready" and r.get("definition")]
 pathlib.Path(a.out).mkdir(parents=True,exist_ok=True)
 for n in range(0,len(rows),a.batch):
  vals=[]
  for r in rows[n:n+a.batch]:
   vals.append("(" + ",".join([q(r.get("word")),q(r.get("lemma") or r.get("word")),q(r.get("pos")),q(r.get("definition")),q(r.get("example")),str(int(r.get("difficulty",3))),"null",q(r.get("register")),q(r.get("source")),q(r.get("source_url")),str(float(r.get("native_score",0))),str(float(r.get("prevalence",0))) if r.get("prevalence") is not None else "null",q("ready")]) + ")")
  sql="""insert into public.lexicon(word,lemma,pos,definition,example,difficulty,frequency_rank,register,source,source_url,native_score,prevalence,content_status) values\n""" + ",\n".join(vals) + """\non conflict(word,pos,definition) do update set lemma=excluded.lemma,example=coalesce(excluded.example,public.lexicon.example),difficulty=excluded.difficulty,register=coalesce(excluded.register,public.lexicon.register),source=excluded.source,source_url=excluded.source_url,native_score=excluded.native_score,prevalence=excluded.prevalence,content_status='ready';\n"""
  open(f"{a.out}/lexicon_{n//a.batch+1:03}.sql","w",encoding="utf-8").write(sql)
 print(len(rows),"ready entries,",((len(rows)+a.batch-1)//a.batch),"batches")
if __name__=="__main__":main()
