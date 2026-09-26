(function(){
let area=document.documentElement.dataset.area||({"/leximind.html":"leximind","/jeux.html":"table"}[location.pathname]||"portal"),last=Date.now(),pending=0,visited=false;
async function send(visit=false){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u)return;let sec=Math.min(120,Math.floor(pending/1000));if(!visit&&!sec)return;pending=0;await db.rpc("track_usage",{p_area:area,p_visit:visit,p_active_seconds:sec})}
function tick(){let now=Date.now();if(!document.hidden&&document.hasFocus())pending+=Math.min(now-last,15000);last=now}
setInterval(()=>{tick();send(false)},30000);document.addEventListener("visibilitychange",()=>{tick();if(document.hidden)send(false)});window.addEventListener("pagehide",()=>{tick();send(false)});
SalonAccount.onChange(u=>{if(u&&!visited){visited=true;send(true)}});
window.SalonUsage={flush:()=>{tick();return send(false)},area};
})();