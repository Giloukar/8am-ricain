alter table public.profiles add column if not exists last_welcome_email_at timestamptz;
alter table public.profiles add column if not exists lexi_xp integer default 0;
alter table public.profiles add column if not exists game_xp integer default 0;
alter table public.profiles add column if not exists last_seen_at timestamptz default now();
create table if not exists public.user_settings (
 user_id uuid primary key references auth.users(id) on delete cascade,
 daily_word_goal integer default 10 check(daily_word_goal between 1 and 100),
 public_profile boolean default true,
 updated_at timestamptz default now()
);
alter table public.user_settings enable row level security;
create policy "own settings" on public.user_settings for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
grant select,insert,update,delete on public.user_settings to authenticated;
