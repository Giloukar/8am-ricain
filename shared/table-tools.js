(function(){
const K="salon_table_tools_v1";let state=JSON.parse(localStorage.getItem(K)||'{"favorites":[],"recent":[]}');
function save(){localStorage.setItem(K,JSON.stringify(state))}
function fav(id){let i=state.favorites.indexOf(id);i>=0?state.favorites.splice(i,1):state.favorites.unshift(id);save();render()}
function recent(id,name){state.recent=state.recent.filter(x=>x.id!==id);state.recent.unshift({id,name,at:Date.now()});state.recent=state.recent.slice(0,8);save();render()}
function render(){let old=document.getElementById("salonQuick");if(old)old.remove();let p=document.createElement("div");p.id="salonQuick";p.style.cssText="position:fixed;left:14px;bottom:14px;z-index:99990;background:#172019ef;border:1px solid #536846;border-radius:14px;padding:9px 12px;color:#eef5e8;max-width:280px;font:12px system-ui";let r=state.recent[0];p.innerHTML='<b>♟ La Table</b>'+(r?'<div style="margin-top:5px">Récent : '+r.name+'</div>':'<div style="margin-top:5px;opacity:.7">Tes favoris et parties récentes apparaîtront ici.</div>');document.body.appendChild(p)}
window.SalonTableTools={favorite:fav,markRecent:recent,state:()=>state};if(document.readyState==="loading")document.addEventListener("DOMContentLoaded",render);else render();
})();