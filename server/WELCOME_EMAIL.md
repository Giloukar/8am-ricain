# Welcome / sign-in email

After a successful Supabase authentication, the client may call a protected server endpoint `POST /api/auth/welcome`.
The endpoint must validate the Supabase access token and derive the recipient email from that token; never accept an arbitrary recipient address from the browser.

## Message
Subject: Bienvenue sur Le Salon 🎉

Bonjour,

Vous êtes bien connecté au site avec votre adresse e-mail.

Vous êtes un gros BG.

Merci pour votre confiance et bienvenue sur Le Salon !

— Le Salon

## Anti-spam rule
Store a `last_welcome_email_at` timestamp on the profile. Do not send repeatedly on refresh. Recommended behavior: send on first successful account creation, or at most once per new authenticated session if that behavior is deliberately enabled.

## Server secrets
Use an email provider only server-side. Never put its API key in `config.js` or any public HTML/JavaScript.
