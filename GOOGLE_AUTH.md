# Google authentication and cloud storage

Google OAuth is the primary sign-in method.

Activation:
1. Create a Supabase project and apply the SQL migrations in supabase/.
2. Create a Web OAuth client in Google Auth Platform.
3. Add the site origin to Authorized JavaScript origins.
4. Add the Supabase Google-provider callback URL to Authorized redirect URIs.
5. Enable Google in Supabase and configure the Client ID and Client Secret there.
6. Put only the Supabase URL and publishable key in shared/config.js.
7. Add the GitHub Pages URL to Supabase redirect URLs.

Never commit Google Client Secret, service-role credentials, or email-provider secrets.

Storage: GitHub stores source/static assets. Supabase PostgreSQL is the source of truth for authenticated user data. Browser storage is only guest/offline cache and is migrated after login.
