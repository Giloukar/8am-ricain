(function(){
let queue=[];
async function flush(){let u=SalonAccount.user(),db=SalonAccount.db();if(!u||!db||!queue.length)return;let batch=queue.splice(0);for(let job of batch){let r=await db.from(job.table).upsert(job.rows,{onConflict:job.conflict});if(r.error)queue.push(job)}}
window.SalonCloud={
 saveProgress:async rows=>{let u=SalonAccount.user(),db=SalonAccount.db();if(!u||!db)return false;rows=(rows||[]).map(x=>Object.assign({},x,{user_id:u.id,updated_at:new Date().toISOString()}));let r=await db.from("lexi_progress").upsert(rows,{onConflict:"user_id,word_id"});if(r.error){queue.push({table:"lexi_progress",rows,conflict:"user_id,word_id"});return false}return true},
 review:async data=>{let u=SalonAccount.user(),db=SalonAccount.db();if(!u||!db)return false;let r=await db.from("lexi_reviews").insert(Object.assign({},data,{user_id:u.id}));return !r.error},
 stats:async()=>{let u=SalonAccount.user(),db=SalonAccount.db();if(!u||!db)return null;let r=await db.from("lexi_user_stats").select("*").eq("user_id",u.id).maybeSingle();return r.data||null},
 flush
};
window.addEventListener("online",flush);SalonAccount.onChange(u=>{if(u)flush()});
})();