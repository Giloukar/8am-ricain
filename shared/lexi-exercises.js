(function(){
const shape=x=>({id:x.id,word:x.word,pos:x.pos||"",definition:x.definition,example:x.example||"",difficulty:x.difficulty||3,keywords:[]});
async function mcq(target){let db=SalonAccount.db?.();if(!db||!target?.id)return null;let r=await db.rpc("lexi_mcq",{p_word_id:target.id,p_seed:Date.now()});if(r.error||!r.data?.length)return null;let options=r.data.map(x=>({...shape(x),is_answer:x.is_answer})).sort(()=>Math.random()-.5);return {target:options.find(x=>x.is_answer),options}}
async function review(){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return null;let r=await db.rpc("lexi_next_review");return r.error||!r.data?.length?null:shape(r.data[0])}
function exerciseLabel(key){return ({mcq_definition:"QCM de définition",free_recall:"Rappel libre",spaced_review:"Révision espacée",familiarity:"Familiarité",discovery:"Découverte"})[key]||key}
window.LexiExercises={mcq,review,exerciseLabel};
})();