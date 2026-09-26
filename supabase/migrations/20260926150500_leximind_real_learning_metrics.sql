-- A word being encountered is not the same as being learned.
-- seen: any lexi_progress row
-- learned: >=3 reviews, >=2 net successes, level >=2
-- mastered: >=5 reviews, >=4 net successes, level >=4, limited lapses
create or replace function public.lexi_dashboard()
returns jsonb language sql stable as $$
with p as (
 select *, (reviews >= 3 and (reviews-lapses) >= 2 and level >= 2) learned_ok,
 (reviews >= 5 and (reviews-lapses) >= 4 and level >= 4 and lapses <= greatest(1,reviews/4)) mastered_ok
 from public.lexi_progress where user_id=auth.uid()
)
select jsonb_build_object('seen',count(*),'learned',count(*) filter(where learned_ok),
'due',count(*) filter(where not mastered_ok and due_at<=now()),'mastered',count(*) filter(where mastered_ok),
'reviews',coalesce(sum(reviews),0),'lapses',coalesce(sum(lapses),0),
'avg_stability',round(coalesce(avg(stability),0)::numeric,2),
'retention',round((100*coalesce(sum(reviews-lapses),0)/greatest(coalesce(sum(reviews),0),1))::numeric,1)) from p $$;