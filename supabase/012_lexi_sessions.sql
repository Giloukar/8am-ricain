create table if not exists public.lexi_sessions(
 id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,
 started_at timestamptz default now(),last_activity_at timestamptz default now(),words_seen integer default 0,
 answers integer default 0,correct integer default 0,xp_earned integer default 0,ended_at timestamptz
);
alter table public.lexi_sessions enable row level security;
create policy "own sessions" on public.lexi_sessions for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
grant select,insert,update on public.lexi_sessions to authenticated;