(function(){
const fmt=s=>{s=Number(s||0);let h=Math.floor(s/3600),m=Math.floor(s%3600/60);return h?h+" h "+m+" min":m+" min"};
async function get(){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return null;await SalonUsage?.flush?.();let r=await db.rpc("user_stats");return r.error?null:r.data}
function cards(s){return [['Temps actif',fmt(s.active_seconds)],['Visites',s.visits],['Jours actifs',s.active_days],['Moyenne / visite',s.avg_visit_minutes+' min'],['Temps LexiMind',fmt(s.lexi_seconds)],['Mots appris',s.learned],['Mots / heure',s.words_per_hour],['Rétention',s.retention+'%'],['Temps La Table',fmt(s.table_seconds)],['Parties',s.games],['Victoires',s.wins],['Taux de victoire',s.win_rate+'%']]}
window.SalonStats={get,cards,formatTime:fmt};
})();