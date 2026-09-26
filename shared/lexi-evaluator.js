(function(){
function tokens(s){return (s||"").toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g,"").replace(/[^a-z0-9 ]/g," ").split(/\s+/).filter(x=>x.length>3)}
async function evaluate(item,answer){let db=SalonAccount.db?.();if(!item?.id)return {score:0,ok:false,feedback:"Réponse non évaluée."};let ref=item.definition;if(db){let r=await db.rpc("lexi_answer_reference",{p_word_id:item.id});if(!r.error&&r.data?.[0])ref=r.data[0].definition}let a=new Set(tokens(answer)),r=tokens(ref),hits=r.filter(x=>a.has(x)).length,ratio=hits/Math.max(2,Math.min(8,r.length));let score=ratio>=.35?2:ratio>=.15?1:0;return {score,ok:score>=1,feedback:score===2?"Sens global reconnu.":score===1?"Réponse partielle : idée proche.":"À revoir.",reference:ref}}
window.LexiEvaluator={evaluate};
})();