-- Keep future imports from publishing rows that cannot be safely served.
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname='lexicon_ready_quality_guard'
      and conrelid='public.lexicon'::regclass
  ) then
    alter table public.lexicon
      add constraint lexicon_ready_quality_guard
      check (
        content_status <> 'ready'
        or (
          nullif(btrim(definition),'') is not null
          and upper(btrim(pos)) in ('NOM','VER','ADJ','ADV')
        )
      );
  end if;
end
$$;
