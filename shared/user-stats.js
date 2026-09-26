(function(){
const fmt=s=>{s=Number(s||0);let h=Math.floor(s/3600),m=Math.floor(s%3600/60);return h?h+" h "+m+" min":m+" min"};
async function get(){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return null;await SalonUsage?.flush?.();let r=await db.rpc("user_stats");return r.error?null:r.data}
async function activity(days=30){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return [];let r=await db.rpc("user_activity",{p_days:days});return r.error?[]:r.data||[]}
function streak(rows){let active=new Set(rows.filter(x=>Number(x.active_seconds)>0).map(x=>String(x.day).slice(0,10))),d=new Date(),n=0;for(let i=0;i<365;i++){let k=d.toISOString().slice(0,10);if(active.has(k))n++;else if(i===0){d.setDate(d.getDate()-1);continue}else break;d.setDate(d.getDate()-1)}return n}
function cards(s){return [['Temps actif',fmt(s.active_seconds)],['Visites',s.visits],['Jours actifs',s.active_days],['Moyenne / visite',s.avg_visit_minutes+' min'],['Temps LexiMind',fmt(s.lexi_seconds)],['Mots parcourus',s.seen||0],['Mots appris',s.learned],['Mots / heure',s.words_per_hour],['Rétention',s.retention+'%'],['Temps La Table',fmt(s.table_seconds)],['Parties',s.games],['Victoires',s.wins],['Taux de victoire',s.win_rate+'%']]}
window.SalonStats={get,activity,streak,cards,formatTime:fmt};
})();