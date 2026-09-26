-- Private cross-site game history without exposing game_results through RLS.
create or replace function public.my_game_history(p_limit integer default 20)
returns table(id bigint,game_key text,created_at timestamptz,won boolean)
language plpgsql stable security definer set search_path='public' as $$
begin
 if auth.uid() is null then raise exception 'authentication required'; end if;
 return query select r.id,r.game_key,r.created_at,(r.winner_id=auth.uid())
 from public.game_results r join public.game_players gp on gp.result_id=r.id
 where gp.user_id=auth.uid() order by r.created_at desc limit least(greatest(p_limit,1),50);
end $$;
revoke all on function public.my_game_history(integer) from public,anon;
grant execute on function public.my_game_history(integer) to authenticated;

alter function public.lexi_due_words(integer) set search_path='';
alter function public.lexi_search(text,integer) set search_path='';
alter function public.lexi_learned_sample(integer,bigint) set search_path='';
alter function public.lexi_quiz_pack(integer,bigint) set search_path='';
alter function public.lexi_mcq(bigint,bigint) set search_path='';
alter function public.lexi_next_review() set search_path='';
alter function public.game_history(integer,integer) set search_path='';
