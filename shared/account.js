(function(){let sb=null,user=null,session=null,initPromise=null;const listeners=[];function emit(){listeners.forEach(f=>f(user,session))}
window.SalonAccount={
 init:function(){if(initPromise)return initPromise;initPromise=(async()=>{if(!window.supabase||!SALON_CONFIG.SUPABASE_URL||!SALON_CONFIG.SUPABASE_PUBLISHABLE_KEY){emit();return null}sb=window.supabase.createClient(SALON_CONFIG.SUPABASE_URL,SALON_CONFIG.SUPABASE_PUBLISHABLE_KEY);let r=await sb.auth.getSession();session=r.data.session;user=session?.user||null;sb.auth.onAuthStateChange(async(e,s)=>{session=s;user=s?.user||null;emit();if(e==="SIGNED_IN"&&user){try{let p=await sb.from("profiles").select("last_welcome_email_at").eq("id",user.id).maybeSingle();if(!p.data?.last_welcome_email_at)await sb.functions.invoke("welcome-email")}catch(_){}}});emit();return user})();return initPromise},
 user:()=>user,session:()=>session,onChange:f=>listeners.push(f),db:()=>sb,
 google:async()=>{if(!sb)throw Error("Supabase non configuré");return sb.auth.signInWithOAuth({provider:"google",options:{redirectTo:location.origin+location.pathname}})},
 magic:async email=>{if(!sb)throw Error("Supabase non configuré");return sb.auth.signInWithOtp({email,options:{emailRedirectTo:location.origin+location.pathname}})},
 logout:()=>sb?.auth.signOut()
};})();