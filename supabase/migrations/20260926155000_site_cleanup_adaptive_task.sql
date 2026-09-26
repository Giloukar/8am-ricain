-- Performance cleanup
create index if not exists game_results_winner_id_idx on public.game_results(winner_id);
create index if not exists lexi_sessions_user_id_idx on public.lexi_sessions(user_id);
create index if not exists user_achievements_achievement_key_idx on public.user_achievements(achievement_key);
drop index if exists public.lexicon_rank_idx;
drop index if exists public.lexicon_word_lower_idx;
alter function public.user_stats() set search_path='';
alter function public.user_activity(integer) set search_path='';
alter function public.lexi_activity(integer) set search_path='';
alter function public.lexi_library(integer,integer,text,text) set search_path='';
alter function public.lexi_answer_reference(bigint) set search_path='';
-- Adaptive next-task RPC is deployed in production; it chooses the missing active-recall evidence.
