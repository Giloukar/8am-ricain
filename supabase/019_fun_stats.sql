alter table public.user_settings add column if not exists fun_puff_enabled boolean not null default true;
create table if not exists public.fun_stats(user_id uuid primary key references auth.users(id) on delete cascade,virtual_puffs bigint not null default 0,updated_at timestamptz default now());
alter table public.fun_stats enable row level security;
create policy "own fun stats read" on public.fun_stats for select using(auth.uid()=user_id);
create or replace function public.add_virtual_puff() returns bigint language plpgsql security definer set search_path=public as $$
declare n bigint; begin if auth.uid() is null then return 0; end if;
insert into fun_stats(user_id,virtual_puffs) values(auth.uid(),1)
on conflict(user_id) do update set virtual_puffs=fun_stats.virtual_puffs+1,updated_at=now()
returning virtual_puffs into n; return n; end $$;
grant execute on function public.add_virtual_puff() to authenticated;