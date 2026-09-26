-- Learning evidence must come from active recall, not discovery/familiarity clicks.
-- Learned: >=2 strong successes across >=2 active exercise types.
-- Mastered: >=4 strong successes, >=2 exercise types, high level, limited lapses,
-- and evidence spread over at least 12 hours.
-- Also indexes evidence lookup and pins function search_path.
create index if not exists lexi_reviews_user_word_evidence_idx on public.lexi_reviews(user_id,word_id,created_at) include (exercise,rating);
create index if not exists lexi_progress_word_id_idx on public.lexi_progress(word_id);
create index if not exists lexi_reviews_word_id_idx on public.lexi_reviews(word_id);
alter function public.lexi_dashboard() set search_path = '';
alter function public.lexi_evidence(bigint) set search_path = '';
