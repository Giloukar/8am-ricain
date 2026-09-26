-- Default discovery is aimed at native French speakers: difficulty 3-5 only,
-- with difficulty 5 then 4 prioritized. Existing learned/due words remain unaffected.
-- Production also exposes lexi_native_challenge() for strict difficulty 4-5 discovery.
alter function public.lexi_new_words(integer,integer,integer) set search_path='';
alter function public.lexi_session_page(bigint,integer,integer,integer,integer) set search_path='';
