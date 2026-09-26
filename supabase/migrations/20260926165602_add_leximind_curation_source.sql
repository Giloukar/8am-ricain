alter table public.lexicon
  add column if not exists curation_source_url text;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname='lexicon_curation_source_url_check'
      and conrelid='public.lexicon'::regclass
  ) then
    alter table public.lexicon
      add constraint lexicon_curation_source_url_check
      check (
        curation_source_url is null
        or curation_source_url like 'https://fr.wiktionary.org/wiki/%'
      );
  end if;
end
$$;

update public.lexicon
set curation_source_url=source_url
where curation_state='approved'
  and source_url like 'https://fr.wiktionary.org/wiki/%'
  and curation_source_url is null;

update public.lexicon
set curation_source_url=case lower(word)
  when 'anti-terroriste' then 'https://fr.wiktionary.org/wiki/anti-terroriste'
  when 'terre-à-terre' then 'https://fr.wiktionary.org/wiki/terre-%C3%A0-terre'
  when 'vioque' then 'https://fr.wiktionary.org/wiki/vioque'
  when 'extrascolaire' then 'https://fr.wiktionary.org/wiki/extrascolaire'
  when 'socioéconomique' then 'https://fr.wiktionary.org/wiki/socio%C3%A9conomique'
  when 'contreproductif' then 'https://fr.wiktionary.org/wiki/contreproductif'
  when 'récrire' then 'https://fr.wiktionary.org/wiki/r%C3%A9crire'
  when 'désaouler' then 'https://fr.wiktionary.org/wiki/d%C3%A9saouler'
  when 'béqueter' then 'https://fr.wiktionary.org/wiki/b%C3%A9queter'
  when 'gratouiller' then 'https://fr.wiktionary.org/wiki/gratouiller'
  when 'jodler' then 'https://fr.wiktionary.org/wiki/jodler'
  when 'courre' then 'https://fr.wiktionary.org/wiki/courre'
  when 'neuroscientifique' then 'https://fr.wiktionary.org/wiki/neuroscientifique'
  when 'ressouvenir' then 'https://fr.wiktionary.org/wiki/ressouvenir'
  when 'co-exister' then 'https://fr.wiktionary.org/wiki/co-exister'
  when 'reservir' then 'https://fr.wiktionary.org/wiki/reservir'
  when 'iodler' then 'https://fr.wiktionary.org/wiki/iodler'
  when 'tocade' then 'https://fr.wiktionary.org/wiki/tocade'
  when 'cuiter' then 'https://fr.wiktionary.org/wiki/cuiter'
  when 'rétracteur' then 'https://fr.wiktionary.org/wiki/r%C3%A9tracteur'
  when 'isolationniste' then 'https://fr.wiktionary.org/wiki/isolationniste'
  else curation_source_url
end
where curation_state='rejected'
  and curation_source_url is null;
