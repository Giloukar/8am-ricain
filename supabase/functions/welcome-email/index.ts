import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
const cors={"Access-Control-Allow-Origin":"*","Access-Control-Allow-Headers":"authorization, x-client-info, apikey, content-type"};
Deno.serve(async req=>{
 if(req.method==="OPTIONS") return new Response("ok",{headers:cors});
 const auth=req.headers.get("Authorization"); if(!auth) return Response.json({error:"unauthorized"},{status:401,headers:cors});
 const url=Deno.env.get("SUPABASE_URL")!, anon=Deno.env.get("SUPABASE_ANON_KEY")!, service=Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
 const client=createClient(url,anon,{global:{headers:{Authorization:auth}}});
 const {data:{user},error}=await client.auth.getUser(); if(error||!user?.email) return Response.json({error:"unauthorized"},{status:401,headers:cors});
 const admin=createClient(url,service); const {data:p}=await admin.from("profiles").select("last_welcome_email_at").eq("id",user.id).maybeSingle();
 if(p?.last_welcome_email_at) return Response.json({sent:false,reason:"already_sent"},{headers:cors});
 const key=Deno.env.get("RESEND_API_KEY"),from=Deno.env.get("WELCOME_FROM_EMAIL"); if(!key||!from) return Response.json({error:"email_not_configured"},{status:503,headers:cors});
 const er=await fetch("https://api.resend.com/emails",{method:"POST",headers:{"Authorization":"Bearer "+key,"Content-Type":"application/json"},body:JSON.stringify({from,to:[user.email],subject:"Bienvenue sur Le Salon 🎉",html:"<div style='font-family:Arial,sans-serif;line-height:1.6'><h2>Bienvenue sur Le Salon 🎉</h2><p>Bonjour,</p><p>Vous êtes bien connecté au site avec votre adresse e-mail.</p><p><strong>Vous êtes un gros BG.</strong></p><p>Merci pour votre confiance et bienvenue sur Le Salon !</p><p>— Le Salon</p></div>"})});
 if(!er.ok) return Response.json({error:"send_failed"},{status:502,headers:cors});
 await admin.from("profiles").update({last_welcome_email_at:new Date().toISOString()}).eq("id",user.id);
 return Response.json({sent:true},{headers:cors});
});