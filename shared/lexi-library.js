(function(){
async function list({offset=0,limit=50,query="",filter="all"}={}){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return [];let r=await db.rpc("lexi_library",{p_offset:offset,p_limit:limit,p_query:query||null,p_filter:filter});return r.error?[]:r.data||[]}
async function favorite(wordId,value){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return false;let r=await db.from("lexi_progress").update({favorite:!!value,updated_at:new Date().toISOString()}).eq("user_id",u.id).eq("word_id",wordId);return !r.error}
async function evidence(wordId){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u||!wordId)return null;let r=await db.rpc("lexi_evidence",{p_word_id:Number(wordId)});return r.error?null:r.data}
async function level(){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return null;let r=await db.rpc("lexi_level");return r.error?null:r.data}
async function dashboard(){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return null;let [d,a,l]=await Promise.all([db.rpc("lexi_dashboard"),db.rpc("lexi_activity",{p_days:30}),db.rpc("lexi_level")]);return {summary:d.data||null,activity:a.data||[],level:l.data||null}}
window.LexiLibrary={list,favorite,evidence,level,dashboard};
})();