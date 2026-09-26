(function(){let cache=[];
function shape(x){return {id:x.id,word:x.word,pos:x.pos||"",definition:x.definition,example:x.example||"",difficulty:x.difficulty||3,keywords:[]}}
async function news(n=20,min=1,max=5){let db=SalonAccount.db?.();if(!db)return [];let r=await db.rpc("lexi_new_words",{p_limit:n,p_min_difficulty:min,p_max_difficulty:max});if(r.error)return [];cache=(r.data||[]).map(shape);return cache}
async function due(n=30){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return [];let r=await db.rpc("lexi_due_words",{p_limit:n});return r.error?[]:(r.data||[]).map(shape)}
async function search(q,n=30){let db=SalonAccount.db?.();if(!db||!q?.trim())return [];let r=await db.rpc("lexi_search",{p_query:q,p_limit:n});return r.error?[]:(r.data||[]).map(shape)}
window.LexiconAPI={newWords:news,due,search,cache:()=>cache};
})();