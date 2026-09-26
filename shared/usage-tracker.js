(function(){
let area=document.documentElement.dataset.area||({"/leximind.html":"leximind","/jeux.html":"table"}[location.pathname]||"portal"),last=Date.now(),pending=0,visited=false,sending=false;
async function send(visit=false){let db=SalonAccount.db?.(),u=SalonAccount.user?.();if(!db||!u||sending)return;let sec=Math.min(120,Math.floor(pending/1000));if(!visit&&!sec)return;let sentMs=sec*1000;pending=Math.max(0,pending-sentMs);sending=true;try{let r=await db.rpc("track_usage",{p_area:area,p_visit:visit,p_active_seconds:sec});if(r.error)throw r.error}catch(_){pending+=sentMs;if(visit)visited=false}finally{sending=false}}
function tick(){let now=Date.now();if(!document.hidden&&document.hasFocus())pending+=Math.min(now-last,15000);last=now}
setInterval(()=>{tick();send(false)},30000);document.addEventListener("visibilitychange",()=>{tick();if(document.hidden)send(false)});window.addEventListener("pagehide",()=>{tick();send(false)});
SalonAccount.onChange(u=>{if(u&&!visited){visited=true;send(true)}});
window.SalonUsage={flush:()=>{tick();return send(false)},area};
})();