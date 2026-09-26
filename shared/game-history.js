(function(){
async function list(offset=0,limit=30){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return [];let r=await db.rpc("game_history",{p_offset:offset,p_limit:limit});return r.error?[]:r.data||[]}
window.SalonGameHistory={list};
})();