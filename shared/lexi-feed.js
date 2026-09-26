(function(){
const LOW=8,BATCH=30;let queue=[],offset=0,seed=Date.now(),loading=false;
async function refill(){if(loading||queue.length>=LOW)return;loading=true;try{let rows=await LexiconAPI.page(seed,offset,BATCH,1,5);if(rows.length){queue.push(...rows);offset+=rows.length}else{seed=Date.now();offset=0}}finally{loading=false}}
async function next(){if(!queue.length)await refill();let x=queue.shift()||null;if(queue.length<LOW)refill();return x}
async function quiz(n=20){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return [];let r=await db.rpc("lexi_quiz_pack",{p_limit:n,p_seed:Date.now()});return r.error?[]:(r.data||[]).map(x=>({id:x.id,word:x.word,pos:x.pos||"",definition:x.definition,example:x.example||"",difficulty:x.difficulty||3,keywords:[]}))}
function reset(){queue=[];offset=0;seed=Date.now();refill()}
window.LexiFeed={next,quiz,reset,refill,size:()=>queue.length};refill();
})();