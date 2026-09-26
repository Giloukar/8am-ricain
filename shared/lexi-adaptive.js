(function(){
const DAY=86400000;
function next(p,rating){
 p=Object.assign({stability:.35,difficulty:5,level:0,reviews:0,lapses:0},p||{});
 let q=Math.max(0,Math.min(3,Number(rating)||0));p.reviews++;
 if(q===0){p.lapses++;p.level=Math.max(0,p.level-1);p.stability=Math.max(.15,p.stability*.45);p.difficulty=Math.min(10,p.difficulty+.7)}
 else{p.level++;let mult=q===1?1.25:q===2?2.05:2.8;p.stability=Math.max(.4,p.stability*mult+(10-p.difficulty)*.08);p.difficulty=Math.max(1,Math.min(10,p.difficulty+(2-q)*.12))}
 let days=q===0?10/1440:q===1?Math.max(.5,p.stability*.7):q===2?Math.max(1,p.stability):Math.max(2,p.stability*1.55);
 p.due_at=new Date(Date.now()+days*DAY).toISOString();p.last_rating=q;p.updated_at=new Date().toISOString();return p
}
function priority(p){if(!p)return 1e9;let overdue=(Date.now()-new Date(p.due_at||0))/DAY;return overdue*12+(p.lapses||0)*4+(10-(p.stability||0))*2-(p.level||0)}
function choose(items,n=10){return [...items].sort((a,b)=>priority(b.progress)-priority(a.progress)).slice(0,n)}
window.LexiAdaptive={next,priority,choose};
})();