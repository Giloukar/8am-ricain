(function(){let sb=null,user=null,session=null;const listeners=[];function emit(){listeners.forEach(f=>f(user,session))}
window.SalonAccount={
 init:async function(){if(!window.supabase||!SALON_CONFIG.SUPABASE_URL||!SALON_CONFIG.SUPABASE_PUBLISHABLE_KEY){emit();return null}sb=window.supabase.createClient(SALON_CONFIG.SUPABASE_URL,SALON_CONFIG.SUPABASE_PUBLISHABLE_KEY);let r=await sb.auth.getSession();session=r.data.session;user=session?.user||null;sb.auth.onAuthStateChange((_e,s)=>{session=s;user=s?.user||null;emit()});emit();return user},
 user:()=>user,session:()=>session,onChange:f=>listeners.push(f),db:()=>sb,
 google:async()=>{if(!sb)throw Error("Supabase non configuré");return sb.auth.signInWithOAuth({provider:"google",options:{redirectTo:location.origin+location.pathname}})},
 magic:async email=>{if(!sb)throw Error("Supabase non configuré");return sb.auth.signInWithOtp({email,options:{emailRedirectTo:location.origin+location.pathname}})},
 logout:()=>sb?.auth.signOut()
};})();