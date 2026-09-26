(function(){
const LOW=8,BATCH=30;let queue=[],offset=0,seed=Date.now(),loading=null;
async function refill(){if(queue.length>=LOW)return queue;if(loading)return loading;loading=(async()=>{let rows=await LexiconAPI.page(seed,offset,BATCH,4,5);if(rows.length){queue.push(...rows);offset+=rows.length}else{seed=Date.now();offset=0}return queue})();try{return await loading}finally{loading=null}}
async function next(){if(!queue.length)await refill();let x=queue.shift()||null;if(queue.length<LOW)refill();return x}
async function quiz(n=20){let db=SalonAccount.db?.(),u=SalonAccount.user?.(),seed=Date.now();if(!db)return [];if(u){let r=await db.rpc("lexi_quiz_pack",{p_limit:n,p_seed:seed});if(!r.error&&r.data?.length>=4)return r.data.map(x=>({id:x.id,word:x.word,pos:x.pos||"",definition:x.definition,example:x.example||"",difficulty:x.difficulty||3,keywords:[]}))}return LexiconAPI.page(seed,0,Math.max(4,Math.min(n,100)),4,5)}
function reset(){queue=[];offset=0;seed=Date.now();return refill()}
window.LexiFeed={next,quiz,reset,refill,size:()=>queue.length};refill();
})();