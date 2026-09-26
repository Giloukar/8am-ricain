-- Le Salon: shared account, LexiMind and Games schema
create extension if not exists pgcrypto;
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique check (char_length(username) between 3 and 24),
  display_name text, avatar_url text, created_at timestamptz default now()
);
create table if not exists public.lexicon (
  id bigserial primary key, word text not null, lemma text, pos text, definition text not null,
  example text, difficulty smallint default 3 check (difficulty between 1 and 5),
  frequency_rank integer, register text, source text default 'Wiktionary', source_url text,
  unique(word,pos,definition)
);
create index if not exists lexicon_word_idx on public.lexicon(lower(word));
create index if not exists lexicon_frequency_idx on public.lexicon(frequency_rank);
create table if not exists public.lexi_progress (
  user_id uuid references auth.users(id) on delete cascade, word_id bigint references public.lexicon(id) on delete cascade,
  level smallint default 0, stability real default 0, difficulty real default 5, due_at timestamptz default now(),
  reviews integer default 0, lapses integer default 0, known boolean default false, favorite boolean default false,
  last_rating smallint, updated_at timestamptz default now(), primary key(user_id,word_id)
);
create table if not exists public.lexi_reviews (
  id bigserial primary key, user_id uuid references auth.users(id) on delete cascade, word_id bigint references public.lexicon(id),
  exercise text not null, rating smallint check(rating between 0 and 3), response_ms integer, created_at timestamptz default now()
);
create table if not exists public.game_results (
  id bigserial primary key, game_key text not null, winner_id uuid references auth.users(id), created_at timestamptz default now(),
  metadata jsonb default '{}'::jsonb
);
create table if not exists public.game_players (
  result_id bigint references public.game_results(id) on delete cascade, user_id uuid references auth.users(id) on delete cascade,
  placement integer, score integer default 0, primary key(result_id,user_id)
);
create table if not exists public.achievements (
  key text primary key, title text not null, description text not null, icon text default '🏆', xp integer default 0
);
create table if not exists public.user_achievements (
  user_id uuid references auth.users(id) on delete cascade, achievement_key text references public.achievements(key),
  unlocked_at timestamptz default now(), primary key(user_id,achievement_key)
);
create or replace view public.game_leaderboard as
select p.id,p.username,p.display_name,
 count(distinct gp.result_id)::int games,
 count(distinct case when gr.winner_id=p.id then gp.result_id end)::int wins,
 case when count(distinct gp.result_id)=0 then 0 else round(100.0*count(distinct case when gr.winner_id=p.id then gp.result_id end)/count(distinct gp.result_id),1) end win_rate
from public.profiles p left join public.game_players gp on gp.user_id=p.id left join public.game_results gr on gr.id=gp.result_id group by p.id;
alter table public.profiles enable row level security; alter table public.lexi_progress enable row level security;
alter table public.lexi_reviews enable row level security; alter table public.game_results enable row level security;
alter table public.game_players enable row level security; alter table public.user_achievements enable row level security;
create policy "profiles readable" on public.profiles for select using(true);
create policy "own profile update" on public.profiles for update using(auth.uid()=id);
create policy "own lexi progress" on public.lexi_progress for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own reviews" on public.lexi_reviews for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "achievements readable" on public.user_achievements for select using(true);
grant select on public.lexicon,public.profiles,public.achievements,public.user_achievements,public.game_leaderboard to anon,authenticated;
grant select,insert,update,delete on public.lexi_progress,public.lexi_reviews to authenticated;
