#!/usr/bin/env python3
import argparse,csv,json,math,re,urllib.request,pathlib
URL="https://lexique.org/databases/Lexique400/Lexique400.tsv"
KEEP={"NOM","ADJ","VER","ADV"}

def num(x):
    try:return float(str(x or "0").replace(",","."))
    except:return 0.0

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--input")
    ap.add_argument("--output",default="data/leximind-candidates.json")
    ap.add_argument("--limit",type=int,default=9000)
    a=ap.parse_args()
    src=a.input or "/tmp/Lexique400.tsv"
    if not a.input:
        req=urllib.request.Request(URL,headers={"User-Agent":"LeSalon-LexiMind/1.0"})
        with urllib.request.urlopen(req,timeout=120) as r,open(src,"wb") as f:f.write(r.read())

    with open(src,encoding="utf-8-sig") as h:
        rows=list(csv.DictReader(h,delimiter="\t"))

    other_form={}
    lemma_pos={}
    for r in rows:
        word=(r.get("1_Mot") or "").strip().lower()
        lemma=(r.get("4_Lemme") or "").strip().lower()
        pos=(r.get("5_Cgram") or "").strip().upper()
        fm=num(r.get("10_FreqMot")); fl=num(r.get("12_FreqLemme"))
        if not word or not lemma:continue
        if word!=lemma:other_form[word]=max(other_form.get(word,0),fm)
        if word==lemma and pos in KEEP:
            lemma_pos.setdefault(word,{})[pos]=max(lemma_pos.setdefault(word,{}).get(pos,0),fl)

    best={}
    for r in rows:
        word=(r.get("1_Mot") or "").strip().lower()
        lemma=(r.get("4_Lemme") or "").strip().lower()
        pos=(r.get("5_Cgram") or "").strip().upper()
        if pos not in KEEP or not word or word!=lemma or len(word)<5 or len(word)>24:continue
        if str(r.get("14_IsLem") or "").strip()!="1":continue
        if not re.fullmatch(r"[a-zàâäçéèêëîïôöùûüÿœæ-]+",word,re.I):continue
        freq=num(r.get("12_FreqLemme")); cd=num(r.get("13_CDOrtho")); prev=num(r.get("33_Preval"))
        if freq<0.03 or freq>12:continue
        if prev and (prev<12 or prev>92):continue
        if cd and cd<0.006:continue
        if other_form.get(word,0)>max(1.2,freq*3.5):continue
        other_pos=max((f for p,f in lemma_pos.get(word,{}).items() if p!=pos),default=0)
        if other_pos>max(1.2,freq*4):continue

        prevalence=prev or 65
        challenge=100-prevalence
        rarity=max(0,min(45,18*math.log10(12/max(freq,.03))))
        length_bonus=min(10,max(0,len(word)-7))
        native=max(0,min(100,40+challenge*.45+rarity*.55+length_bonus))
        prev_utility=max(0,min(1,1-abs(prevalence-62)/50))
        breadth=max(0,min(1,math.log10(1+cd*30)/math.log10(151))) if cd else .35
        freq_utility=max(0,min(1,math.log10(1+freq*5)/math.log10(61)))
        value=max(0,min(100,native*.48+prev_utility*20+breadth*22+freq_utility*10))
        if value<48:continue
        difficulty=5 if native>=80 else 4 if native>=65 else 3
        x={"word":word,"lemma":word,"pos":pos,"frequency":round(freq,5),"contextual_diversity":round(cd,5) if cd else None,"prevalence":round(prev,5) if prev else None,"native_score":round(native,2),"learning_value":round(value,2),"difficulty":difficulty}
        key=(word,pos)
        if key not in best or value>best[key]["learning_value"]:best[key]=x

    out=sorted(best.values(),key=lambda x:(-x["learning_value"],-x["native_score"],x["word"]))[:a.limit]
    pathlib.Path(a.output).parent.mkdir(parents=True,exist_ok=True)
    with open(a.output,"w",encoding="utf-8") as f:json.dump(out,f,ensure_ascii=False,separators=(",",":"))
    print("eligible",len(best),"selected",len(out),"difficulty", {d:sum(x["difficulty"]==d for x in out) for d in (3,4,5)})
    print("sample",[x["word"] for x in out[:30]])

if __name__=="__main__":main()
