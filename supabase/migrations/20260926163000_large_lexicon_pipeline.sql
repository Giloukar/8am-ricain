-- Corpus pipeline: candidate rows may omit definitions, but only ready rows are served.
alter table public.lexicon add column if not exists native_score real;
alter table public.lexicon add column if not exists prevalence real;
alter table public.lexicon add column if not exists content_status text not null default 'ready';
alter table public.lexicon alter column definition drop not null;
create index if not exists lexicon_native_discovery_idx on public.lexicon(content_status,difficulty,native_score desc,frequency_rank);
