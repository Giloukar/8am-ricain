#!/usr/bin/env python3
import csv,json,math,pathlib,sys

def num(v):
    try:return float(str(v or '').replace(',','.'))
    except:return None

def q(s): return "'" + str(s).replace("'","''") + "'"

def main(src,outdir,batch=500):
    best={}
    with open(src,encoding='utf-8-sig',newline='') as f:
        rd=csv.DictReader(f,delimiter='\t')
        for r in rd:
            w=(r.get('1_Mot') or '').strip().lower()
            lemma=(r.get('4_Lemme') or '').strip().lower()
            pos=(r.get('5_Cgram') or '').strip().upper()
            if not w or w!=lemma or pos not in {'NOM','ADJ','VER','ADV'}: continue
            prev=num(r.get('33_Preval')); n=num(r.get('34_PrevalNb')); freq=num(r.get('12_FreqLemme')); cd=num(r.get('13_CDOrtho'))
            if prev is None or n is None or n < 20 or freq is None or freq<=0: continue
            prev=max(0,min(100,prev))
            unknown=100-prev
            usefulness=max(0,min(100,50+25*math.log10(max(freq,0.0001)/0.05)))
            score=max(0,min(100,0.75*unknown+0.25*usefulness))
            difficulty=5 if prev<=30 else 4 if prev<=65 else 3
            row={'word':w,'prevalence':round(prev,3),'preval_nb':int(n),'frequency':round(freq,6),'cd':round(cd or 0,6),'native_score':round(unknown,2),'learning_value':round(score,2),'difficulty':difficulty}
            old=best.get(w)
            if old is None or row['preval_nb']>old['preval_nb'] or (row['preval_nb']==old['preval_nb'] and row['frequency']>old['frequency']): best[w]=row
    rows=sorted(best.values(),key=lambda x:x['word'])
    out=pathlib.Path(outdir);out.mkdir(parents=True,exist_ok=True)
    manifest={'mapped_words':len(rows),'difficulty':{str(d):sum(1 for x in rows if x['difficulty']==d) for d in (3,4,5)},'prevalence_le_65':sum(1 for x in rows if x['prevalence']<=65),'prevalence_le_50':sum(1 for x in rows if x['prevalence']<=50)}
    (out/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
    for start in range(0,len(rows),batch):
        vals=[]
        for x in rows[start:start+batch]:
            vals.append(f"({q(x['word'])},{x['prevalence']},{x['cd']},{x['native_score']},{x['learning_value']},{x['difficulty']})")
        sql="WITH v(word,prevalence,contextual_diversity,native_score,learning_value,difficulty) AS (VALUES\n"+",\n".join(vals)+"\n)\nUPDATE public.lexicon l SET prevalence=v.prevalence,contextual_diversity=v.contextual_diversity,native_score=v.native_score,learning_value=v.learning_value,difficulty=v.difficulty FROM v WHERE lower(l.word)=v.word;\n"
        (out/f'batch_{start//batch+1:03}.sql').write_text(sql,encoding='utf-8')
    print(json.dumps(manifest,ensure_ascii=False))
if __name__=='__main__':
    main(sys.argv[1],sys.argv[2])
