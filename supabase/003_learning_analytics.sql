-- Advanced learning analytics, computed from review history
create or replace view public.lexi_user_stats as
select user_id,
 count(*)::int reviews,
 count(distinct word_id)::int reviewed_words,
 round(100.0*avg(case when rating>=2 then 1 else 0 end),1) accuracy,
 round(avg(response_ms))::int avg_response_ms,
 count(*) filter(where created_at>=now()-interval '7 days')::int reviews_7d,
 count(distinct date(created_at)) filter(where created_at>=now()-interval '30 days')::int active_days_30d
from public.lexi_reviews group by user_id;
grant select on public.lexi_user_stats to authenticated;
