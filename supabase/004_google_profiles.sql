create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.profiles(id,username,display_name,avatar_url)
 values(new.id,'user_'||substr(new.id::text,1,8),coalesce(new.raw_user_meta_data->>'full_name',new.raw_user_meta_data->>'name'),new.raw_user_meta_data->>'avatar_url')
 on conflict(id) do update set display_name=coalesce(excluded.display_name,profiles.display_name),avatar_url=coalesce(excluded.avatar_url,profiles.avatar_url);
 insert into public.user_settings(user_id) values(new.id) on conflict(user_id) do nothing;
 return new;
end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();