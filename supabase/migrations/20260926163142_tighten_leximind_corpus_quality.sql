-- LexiMind corpus quality tightening: preserve rows/provenance, improve what can be served.

-- Normalize the four supported POS labels without changing lexical identity.
update public.lexicon
set pos = case lower(btrim(pos))
  when 'nom' then 'NOM'
  when 'ver' then 'VER'
  when 'verbe' then 'VER'
  when 'adj' then 'ADJ'
  when 'adjectif' then 'ADJ'
  when 'adv' then 'ADV'
  when 'adverbe' then 'ADV'
  else pos
end
where lower(btrim(pos)) in ('nom','ver','verbe','adj','adjectif','adv','adverbe')
  and pos is distinct from case lower(btrim(pos))
    when 'nom' then 'NOM'
    when 'ver' then 'VER'
    when 'verbe' then 'VER'
    when 'adj' then 'ADJ'
    when 'adjectif' then 'ADJ'
    when 'adv' then 'ADV'
    when 'adverbe' then 'ADV'
    else pos
  end;

-- Native-speaker calibration: 72+ is advanced, 84+ is expert.
update public.lexicon
set difficulty = case
  when native_score >= 84 then 5
  when native_score >= 72 then 4
  else 3
end
where native_score is not null
  and source in ('Lexique 4','Lexique 4 + Wiktionnaire','Wiktionnaire fr + Lexique 4')
  and difficulty is distinct from case
    when native_score >= 84 then 5
    when native_score >= 72 then 4
    else 3
  end;

-- Hide spelling redirects and terse shortened-form redirects until they have standalone definitions.
update public.lexicon
set content_status='hidden'
where content_status='ready'
  and (
    definition ilike 'Autre orthographe de %'
    or definition ilike 'Ancienne orthographe de %'
    or (
      char_length(btrim(definition)) < 80
      and (
        definition ilike 'Abréviation de %'
        or definition ilike 'Apocope de %'
        or definition ilike 'Ellipse de %'
        or definition ilike 'Nom raccourci %'
      )
    )
  );

-- Audited malformed, circular or wrong-sense definitions.
update public.lexicon
set content_status='hidden'
where id in (22086,22095,22113,22322,22414,23666,24181,24846,25043,25490,25820)
  and content_status='ready';

-- Inspected ready/ready duplicate: keep the curated starter definition.
update public.lexicon
set content_status='hidden'
where lower(word)='conjecture'
  and upper(pos)='NOM'
  and source='Lexique 4 + Wiktionnaire'
  and content_status='ready';

create or replace function public.lexi_new_words(
  p_limit integer default 20,
  p_min_difficulty integer default 4,
  p_max_difficulty integer default 5
)
returns setof public.lexicon
language sql stable security invoker set search_path=''
as $$
with canonical as (
  select distinct on (lower(l.word)) l.*
  from public.lexicon l
  where l.content_status='ready'
    and l.difficulty between greatest(4,p_min_difficulty) and least(5,p_max_difficulty)
    and nullif(btrim(l.definition),'') is not null
    and upper(l.pos) in ('NOM','VER','ADJ','ADV')
  order by lower(l.word),
           case l.source
             when 'Le Salon starter lexicon' then 0
             when 'Wiktionnaire fr + Lexique 4' then 1
             when 'Lexique 4 + Wiktionnaire' then 2
             else 3
           end,
           coalesce(l.learning_value,l.native_score,l.difficulty*20) desc nulls last,
           l.id
)
select c.*
from canonical c
where auth.uid() is null or not exists (
  select 1
  from public.lexi_progress p
  join public.lexicon seen on seen.id=p.word_id
  where p.user_id=auth.uid() and lower(seen.word)=lower(c.word)
)
order by
  case c.source
    when 'Le Salon starter lexicon' then 0
    when 'Wiktionnaire fr + Lexique 4' then 1
    when 'Lexique 4 + Wiktionnaire' then 2
    else 3
  end,
  coalesce(c.learning_value,c.native_score,c.difficulty*20) desc,
  md5(c.id::text||':'||extract(doy from current_date)::text)
limit least(greatest(p_limit,1),50)
$$;

create or replace function public.lexi_session_page(
  p_seed bigint default 1,
  p_offset integer default 0,
  p_limit integer default 25,
  p_min_difficulty integer default 4,
  p_max_difficulty integer default 5
)
returns setof public.lexicon
language sql stable security invoker set search_path=''
as $$
with canonical as (
  select distinct on (lower(l.word)) l.*
  from public.lexicon l
  where l.content_status='ready'
    and l.difficulty between greatest(4,p_min_difficulty) and least(5,p_max_difficulty)
    and nullif(btrim(l.definition),'') is not null
    and upper(l.pos) in ('NOM','VER','ADJ','ADV')
  order by lower(l.word),
           case l.source
             when 'Le Salon starter lexicon' then 0
             when 'Wiktionnaire fr + Lexique 4' then 1
             when 'Lexique 4 + Wiktionnaire' then 2
             else 3
           end,
           coalesce(l.learning_value,l.native_score,l.difficulty*20) desc nulls last,
           l.id
)
select c.*
from canonical c
where auth.uid() is null or not exists (
  select 1
  from public.lexi_progress p
  join public.lexicon seen on seen.id=p.word_id
  where p.user_id=auth.uid() and lower(seen.word)=lower(c.word)
)
order by
  case c.source
    when 'Le Salon starter lexicon' then 0
    when 'Wiktionnaire fr + Lexique 4' then 1
    when 'Lexique 4 + Wiktionnaire' then 2
    else 3
  end,
  coalesce(c.learning_value,c.native_score,c.difficulty*20) desc,
  md5(c.id::text||':'||p_seed::text)
offset greatest(p_offset,0)
limit least(greatest(p_limit,1),100)
$$;

create or replace function public.lexi_native_challenge(p_limit integer default 25,p_seed bigint default 1)
returns setof public.lexicon
language sql stable security invoker set search_path=''
as $$
 select l.* from public.lexicon l
 where l.content_status='ready'
   and l.difficulty between 4 and 5
   and nullif(btrim(l.definition),'') is not null
   and upper(l.pos) in ('NOM','VER','ADJ','ADV')
   and (auth.uid() is null or not exists(
     select 1 from public.lexi_progress p where p.user_id=auth.uid() and p.word_id=l.id
   ))
 order by coalesce(l.learning_value,l.native_score,l.difficulty*20) desc,
          md5(l.id::text||':'||p_seed::text)
 limit least(greatest(p_limit,1),100)
$$;

create or replace function public.lexi_due_words(p_limit integer default 30)
returns table(
  id bigint, word text, pos text, definition text, example text, difficulty smallint,
  level smallint, stability real, user_difficulty real, due_at timestamptz,
  lapses integer, last_rating smallint
)
language sql stable security invoker set search_path=''
as $$
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,
        p.level,p.stability,p.difficulty,p.due_at,p.lapses,p.last_rating
 from public.lexi_progress p
 join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid()
   and not p.known and p.due_at<=now()
   and l.content_status='ready'
   and l.difficulty between 4 and 5
   and nullif(btrim(l.definition),'') is not null
   and upper(l.pos) in ('NOM','VER','ADJ','ADV')
 order by p.due_at asc,p.lapses desc
 limit least(greatest(p_limit,1),100)
$$;

create or replace function public.lexi_next_review()
returns table(
  id bigint, word text, pos text, definition text, example text, difficulty smallint,
  level smallint, stability real, due_at timestamptz
)
language sql stable security invoker set search_path=''
as $$
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,
        p.level,p.stability,p.due_at
 from public.lexi_progress p
 join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid()
   and not p.known and p.due_at<=now()
   and l.content_status='ready'
   and l.difficulty between 4 and 5
   and nullif(btrim(l.definition),'') is not null
   and upper(l.pos) in ('NOM','VER','ADJ','ADV')
 order by p.due_at asc,p.lapses desc
 limit 1
$$;

create or replace function public.lexi_next_task()
returns table(
  id bigint, word text, pos text, definition text, example text, difficulty smallint,
  level smallint, stability real, due_at timestamptz, recommended_exercise text,
  evidence_types bigint, strong_successes bigint
)
language sql stable security invoker set search_path=''
as $$
with due as (
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,
        p.level,p.stability,p.due_at,p.lapses
 from public.lexi_progress p
 join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid() and p.due_at<=now()
   and l.content_status='ready'
   and l.difficulty between 4 and 5
   and nullif(btrim(l.definition),'') is not null
   and upper(l.pos) in ('NOM','VER','ADJ','ADV')
), ev as (
 select d.*,
   count(distinct r.exercise) filter(where r.rating>=2 and r.exercise in ('mcq_definition','free_recall','spaced_review')) evidence_types,
   count(*) filter(where r.rating>=2 and r.exercise in ('mcq_definition','free_recall','spaced_review')) strong_successes,
   count(*) filter(where r.rating>=2 and r.exercise='mcq_definition') mcq_ok,
   count(*) filter(where r.rating>=2 and r.exercise='free_recall') free_ok,
   count(*) filter(where r.rating>=2 and r.exercise='spaced_review') review_ok
 from due d
 left join public.lexi_reviews r on r.user_id=auth.uid() and r.word_id=d.id
 group by d.id,d.word,d.pos,d.definition,d.example,d.difficulty,
          d.level,d.stability,d.due_at,d.lapses
)
select id,word,pos,definition,example,difficulty,level,stability,due_at,
 case when mcq_ok=0 then 'mcq_definition'
      when free_ok=0 then 'free_recall'
      when review_ok=0 then 'spaced_review'
      when free_ok<=least(mcq_ok,review_ok) then 'free_recall'
      else 'spaced_review' end,
 evidence_types,strong_successes
from ev
order by due_at asc,lapses desc,strong_successes asc
limit 1
$$;

create or replace function public.lexi_quiz_pack(p_limit integer default 20,p_seed bigint default 1)
returns table(
  id bigint, word text, pos text, definition text, example text, difficulty smallint,
  level smallint, stability real, due_at timestamptz
)
language sql stable security invoker set search_path=''
as $$
(
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,
        p.level,p.stability,p.due_at
 from public.lexi_progress p
 join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid() and not p.known and p.due_at<=now()
   and l.content_status='ready'
   and l.difficulty between 4 and 5
   and nullif(btrim(l.definition),'') is not null
   and upper(l.pos) in ('NOM','VER','ADJ','ADV')
 order by p.due_at asc
 limit greatest(1,least(p_limit,100)/2)
)
union all
(
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,
        p.level,p.stability,p.due_at
 from public.lexi_progress p
 join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid()
   and l.content_status='ready'
   and l.difficulty between 4 and 5
   and nullif(btrim(l.definition),'') is not null
   and upper(l.pos) in ('NOM','VER','ADJ','ADV')
 order by md5(l.id::text||':'||p_seed::text)
 limit greatest(1,least(p_limit,100)/2)
)
limit least(greatest(p_limit,1),100)
$$;

create or replace function public.lexi_learned_sample(p_limit integer default 20,p_seed bigint default 1)
returns table(
  id bigint, word text, pos text, definition text, example text, difficulty smallint,
  level smallint, stability real, due_at timestamptz
)
language sql stable security invoker set search_path=''
as $$
 select l.id,l.word,l.pos,l.definition,l.example,l.difficulty,
        p.level,p.stability,p.due_at
 from public.lexi_progress p
 join public.lexicon l on l.id=p.word_id
 where p.user_id=auth.uid()
   and l.content_status='ready'
   and l.difficulty between 4 and 5
   and nullif(btrim(l.definition),'') is not null
   and upper(l.pos) in ('NOM','VER','ADJ','ADV')
 order by md5(l.id::text||':'||p_seed::text)
 limit least(greatest(p_limit,1),100)
$$;

create or replace function public.lexi_mcq(p_word_id bigint,p_seed bigint default 1)
returns table(id bigint,word text,pos text,definition text,example text,difficulty smallint,is_answer boolean)
language sql stable security invoker set search_path=''
as $$
with target as (
  select *
  from public.lexicon
  where id=p_word_id
    and content_status='ready'
    and difficulty between 4 and 5
    and nullif(btrim(definition),'') is not null
    and upper(pos) in ('NOM','VER','ADJ','ADV')
  limit 1
),
distractor_pool as (
  select distinct on (lower(l.word)) l.*
  from public.lexicon l,target t
  where l.content_status='ready'
    and l.difficulty between 4 and 5
    and nullif(btrim(l.definition),'') is not null
    and upper(l.pos) in ('NOM','VER','ADJ','ADV')
    and lower(l.word)<>lower(t.word)
    and upper(l.pos)=upper(t.pos)
    and abs(l.difficulty-t.difficulty)<=1
  order by lower(l.word),
           coalesce(l.learning_value,l.native_score,l.difficulty*20) desc nulls last,
           l.id
),
distractors as (
  select * from distractor_pool
  order by md5(id::text||':'||p_seed::text)
  limit 3
)
select t.id,t.word,t.pos,t.definition,t.example,t.difficulty,true from target t
union all
select d.id,d.word,d.pos,d.definition,d.example,d.difficulty,false from distractors d
$$;

create or replace function public.lexi_answer_reference(p_word_id bigint)
returns table(word text,definition text,pos text)
language sql stable security invoker set search_path=''
as $$
 select l.word,l.definition,l.pos
 from public.lexicon l
 where l.id=p_word_id
   and l.content_status='ready'
   and l.difficulty between 4 and 5
   and nullif(btrim(l.definition),'') is not null
   and upper(l.pos) in ('NOM','VER','ADJ','ADV')
   and (
     auth.uid() is null
     or exists(select 1 from public.lexi_progress p where p.user_id=auth.uid() and p.word_id=l.id)
   )
 limit 1
$$;

create or replace function public.lexi_search(p_query text,p_limit integer default 30)
returns setof public.lexicon
language sql stable security invoker set search_path=''
as $$
with canonical as (
  select distinct on (lower(l.word)) l.*
  from public.lexicon l
  where l.content_status='ready'
    and nullif(btrim(l.definition),'') is not null
    and upper(l.pos) in ('NOM','VER','ADJ','ADV')
  order by lower(l.word),
           case l.source
             when 'Le Salon starter lexicon' then 0
             when 'Wiktionnaire fr + Lexique 4' then 1
             when 'Lexique 4 + Wiktionnaire' then 2
             else 3
           end,
           coalesce(l.learning_value,l.native_score,l.difficulty*20) desc nulls last,
           l.id
)
select c.* from canonical c
where lower(c.word) like lower(trim(p_query))||'%'
   or lower(c.definition) like '%'||lower(trim(p_query))||'%'
order by case when lower(c.word)=lower(trim(p_query)) then 0 else 1 end,
         coalesce(c.learning_value,c.native_score,c.difficulty*20) desc
limit least(greatest(p_limit,1),50)
$$;

create or replace function public.lexicon_quality()
returns jsonb
language sql stable security invoker set search_path=''
as $$
select jsonb_build_object(
 'total',count(*),
 'ready',count(*) filter(where content_status='ready'),
 'candidates',count(*) filter(where content_status='candidate'),
 'hidden',count(*) filter(where content_status='hidden'),
 'advanced_ready',count(*) filter(where content_status='ready' and difficulty between 4 and 5),
 'discovery_ready',count(*) filter(
   where content_status='ready'
     and difficulty between 4 and 5
     and nullif(btrim(definition),'') is not null
     and upper(pos) in ('NOM','VER','ADJ','ADV')
 ),
 'missing_definition',count(*) filter(where content_status='ready' and nullif(btrim(definition),'') is null),
 'duplicate_ready_word_pos',(
   select count(*) from (
     select lower(word),upper(coalesce(pos,'')) from public.lexicon
     where content_status='ready'
     group by 1,2 having count(*)>1
   ) d
 ),
 'avg_native_score',round(coalesce(avg(native_score) filter(where native_score is not null),0)::numeric,1)
) from public.lexicon
$$;
