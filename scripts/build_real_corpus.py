#!/usr/bin/env python3
import csv,gzip,json,math,re,sys,urllib.parse,pathlib
from collections import Counter

LEX_POS={"NOM":"noun","ADJ":"adjective","VER":"verb","ADV":"adverb"}
OUT_POS={"noun":"NOM","adjective":"ADJ","verb":"VER","adverb":"ADV"}
WORD_RE=re.compile(r"^[a-zàâäçéèêëîïôöùûüÿœæ-]+$",re.I)
BAD_TAGS={"obsolete","archaic","historical","dated","form-of","alt-of","misspelling","nonstandard"}
BAD_GLOSS_PREFIX=("forme de ","flexion de ","variante de ","orthographe de ","participe ","pluriel de ","féminin de ","masculin de ")

def num(v):
    try:return float(str(v or 0).replace(",","."))
    except:return 0.0

def lexique_candidates(path, cap=30000):
    best={}
    with open(path,encoding="utf-8-sig",newline="") as f:
        rd=csv.DictReader(f,delimiter="\t")
        for r in rd:
            w=(r.get("1_Mot") or r.get("ortho") or "").strip().lower()
            lemma=(r.get("4_Lemme") or r.get("lemme") or "").strip().lower()
            pos=(r.get("5_Cgram") or r.get("cgram") or "").strip().upper()
            if pos not in LEX_POS or not w or w!=lemma or not WORD_RE.fullmatch(w) or not (5<=len(w)<=24):continue
            freq=num(r.get("12_FreqLemme") or r.get("freqlemfilms2") or r.get("freqlemlivres"))
            if not (0.02<=freq<=5.0):continue
            rarity=max(0,min(100,58+16*math.log10(5.0/max(freq,.02))))
            usefulness=max(0,100-24*abs(math.log10(freq)-math.log10(.45)))
            length_bonus=min(8,max(0,len(w)-7)*1.1)
            learning=max(0,min(100,.56*rarity+.44*usefulness+length_bonus))
            difficulty=5 if freq<.10 else 4 if freq<.85 else 3
            row={"word":w,"lemma":lemma,"pos":LEX_POS[pos],"frequency":freq,"native_score":round(rarity,2),"learning_value":round(learning,2),"difficulty":difficulty}
            prev=best.get(w)
            if prev is None or row["learning_value"]>prev["learning_value"]:best[w]=row
    rows=sorted(best.values(),key=lambda x:(-x["learning_value"],-x["native_score"],x["word"]))[:cap]
    return {r["word"]:r for r in rows}

def clean_gloss(s):
    return re.sub(r"\s+"," ",str(s or "")).strip()

def usable_sense(s):
    glosses=[clean_gloss(x) for x in (s.get("glosses") or []) if clean_gloss(x)]
    if not glosses:return None
    tags={str(x).lower() for x in (s.get("tags") or [])}
    if tags & BAD_TAGS:return None
    if s.get("topics"):return None
    g=glosses[0]
    if not (12<=len(g)<=360):return None
    lo=g.lower().lstrip("([{ ")
    if lo.startswith(BAD_GLOSS_PREFIX):return None
    return g

def process(raw_gz,candidates,target=6000):
    found={}
    with gzip.open(raw_gz,"rt",encoding="utf-8",errors="ignore") as f:
        for i,line in enumerate(f,1):
            if i%500000==0:print(f"scan {i:,} lines, {len(found):,} matches",flush=True)
            try:r=json.loads(line)
            except:continue
            if str(r.get("lang_code") or "") not in ("fr","fra"):continue
            w=str(r.get("word") or "").strip().lower()
            c=candidates.get(w)
            if not c or w in found:continue
            pos=str(r.get("pos") or "").lower()
            if pos not in OUT_POS or pos!=c["pos"]:continue
            definition=None
            for s in (r.get("senses") or []):
                definition=usable_sense(s)
                if definition:break
            if not definition:continue
            found[w]={**c,"pos":OUT_POS[pos],"definition":definition,"example":None,
                      "register":None,"source":"Wiktionnaire fr + Lexique 4",
                      "source_url":"https://fr.wiktionary.org/wiki/"+urllib.parse.quote(w,safe=""),
                      "content_status":"ready"}
    return sorted(found.values(),key=lambda x:(-x["learning_value"],-x["native_score"],x["word"]))[:target]

def sqlq(v):
    if v is None:return "NULL"
    return "'"+str(v).replace("'","''")+"'"

def write_outputs(rows,outdir,batch=200):
    out=pathlib.Path(outdir);out.mkdir(parents=True,exist_ok=True)
    (out/"corpus.json").write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding="utf-8")
    manifest={"ready":len(rows),"difficulty":dict(Counter(str(r["difficulty"]) for r in rows)),"sources":dict(Counter(r["source"] for r in rows)),"min_learning_value":min((r["learning_value"] for r in rows),default=0),"max_learning_value":max((r["learning_value"] for r in rows),default=0)}
    (out/"manifest.json").write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding="utf-8")
    cols="word,lemma,pos,definition,example,difficulty,register,source,source_url,native_score,learning_value,content_status"
    for start in range(0,len(rows),batch):
        vals=[]
        for r in rows[start:start+batch]:
            vals.append("("+",".join([sqlq(r["word"]),sqlq(r["lemma"]),sqlq(r["pos"]),sqlq(r["definition"]),"NULL",str(r["difficulty"]),"NULL",sqlq(r["source"]),sqlq(r["source_url"]),str(r["native_score"]),str(r["learning_value"]),"'ready'"])+")")
        sql=f"WITH v({cols}) AS (VALUES\n"+",\n".join(vals)+f"\n)\nINSERT INTO public.lexicon({cols})\nSELECT {cols} FROM v\nWHERE NOT EXISTS (SELECT 1 FROM public.lexicon l WHERE lower(l.word)=lower(v.word));\n"
        (out/f"batch_{start//batch+1:03}.sql").write_text(sql,encoding="utf-8")
    print(json.dumps(manifest,ensure_ascii=False),flush=True)

if __name__=="__main__":
    if len(sys.argv)<4:raise SystemExit("usage: build_real_corpus.py Lexique400.tsv raw-wiktextract-data.jsonl.gz outdir [target]")
    target=int(sys.argv[4]) if len(sys.argv)>4 else 6000
    c=lexique_candidates(sys.argv[1]);print(f"Lexique candidates: {len(c):,}",flush=True)
    rows=process(sys.argv[2],c,target)
    if len(rows)<3000:raise SystemExit(f"quality gate: only {len(rows)} ready rows")
    write_outputs(rows,sys.argv[3])
