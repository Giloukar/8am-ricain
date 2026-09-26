(function(){let cache=[];
function shape(x){return {id:x.id,word:x.word,pos:x.pos||"",definition:x.definition,example:x.example||"",difficulty:x.difficulty||3,keywords:[]}}
async function page(seed,offset=0,n=25,min=1,max=5){let db=SalonAccount.db?.();if(!db)return [];let r=await db.rpc("lexi_session_page",{p_seed:seed,p_offset:offset,p_limit:Math.min(n,100),p_min_difficulty:min,p_max_difficulty:max});return r.error?[]:(r.data||[]).map(shape)}
async function session(total=20,opts={}){total=Math.max(1,Math.min(Number(total)||20,1000));let seed=opts.seed||Math.floor(Date.now()/1000),out=[],offset=0,batch=Math.min(50,total);while(out.length<total){let rows=await page(seed,offset,Math.min(batch,total-out.length),opts.min||1,opts.max||5);if(!rows.length)break;out.push(...rows);offset+=rows.length;if(rows.length<Math.min(batch,total-out.length+rows.length))break}cache=out;return {words:out,seed,total:out.length,requested:total}}
async function news(n=20,min=1,max=5){return (await session(n,{min,max})).words}
async function due(n=30){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return [];let r=await db.rpc("lexi_due_words",{p_limit:Math.min(Math.max(n,1),100)});return r.error?[]:(r.data||[]).map(shape)}
async function search(q,n=30){let db=SalonAccount.db?.();if(!db||!q?.trim())return [];let r=await db.rpc("lexi_search",{p_query:q,p_limit:Math.min(Math.max(n,1),50)});return r.error?[]:(r.data||[]).map(shape)}
window.LexiconAPI={page,session,newWords:news,due,search,cache:()=>cache};
})();