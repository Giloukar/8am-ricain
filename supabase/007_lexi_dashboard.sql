create or replace function public.lexi_dashboard()
returns jsonb language sql stable security invoker as $$
 select jsonb_build_object(
 'learned',count(*),
 'due',count(*) filter(where not known and due_at<=now()),
 'mastered',count(*) filter(where known or level>=4),
 'reviews',coalesce(sum(reviews),0),
 'lapses',coalesce(sum(lapses),0),
 'avg_stability',round(coalesce(avg(stability),0)::numeric,2),
 'retention',round((100*coalesce(sum(reviews-lapses),0)/greatest(coalesce(sum(reviews),0),1))::numeric,1)
 ) from public.lexi_progress where user_id=auth.uid()
$$;
grant execute on function public.lexi_dashboard() to authenticated;