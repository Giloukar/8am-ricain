alter table public.lexicon
  add column if not exists curation_state text,
  add column if not exists curation_reason text,
  add column if not exists curated_at timestamptz;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname='lexicon_curation_state_check'
      and conrelid='public.lexicon'::regclass
  ) then
    alter table public.lexicon
      add constraint lexicon_curation_state_check
      check (
        curation_state is null
        or curation_state in ('pending_source','approved','rejected')
      );
  end if;
end
$$;

create index if not exists lexicon_curation_queue_idx
  on public.lexicon (curation_state, learning_value desc, native_score desc)
  where content_status='hidden'
    and source='Lexique 4'
    and nullif(btrim(definition),'') is null;
