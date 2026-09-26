alter table public.lexicon add column if not exists learning_value real;
alter table public.lexicon add column if not exists contextual_diversity real;
create index if not exists lexicon_learning_value_idx on public.lexicon(content_status,learning_value desc,native_score desc);
-- Discovery RPCs in production order unseen ready words by learning_value, then native_score.
