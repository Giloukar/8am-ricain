(function(){
async function list({offset=0,limit=50,query="",filter="all"}={}){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return [];let r=await db.rpc("lexi_library",{p_offset:offset,p_limit:limit,p_query:query||null,p_filter:filter});return r.error?[]:r.data||[]}
async function favorite(wordId,value){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return false;let r=await db.from("lexi_progress").update({favorite:!!value,updated_at:new Date().toISOString()}).eq("user_id",u.id).eq("word_id",wordId);return !r.error}
async function dashboard(){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return null;let [d,a]=await Promise.all([db.rpc("lexi_dashboard"),db.rpc("lexi_activity",{p_days:30})]);return {summary:d.data||null,activity:a.data||[]}}
window.LexiLibrary={list,favorite,dashboard};
})();