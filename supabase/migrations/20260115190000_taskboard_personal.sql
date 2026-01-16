-- TaskBoard Personal - esquema mínimo para persistencia (local o cloud)
-- Nota: para pruebas locales puedes dejar RLS desactivado. En producción, habilitar Auth + RLS.

create table if not exists public.projects (
  id integer primary key,
  title text not null,
  description text not null default '',
  status text not null default 'planning',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists projects_status_idx on public.projects (status);

create table if not exists public.tasks (
  id integer primary key,
  project_id integer not null references public.projects(id) on delete cascade,
  title text not null,
  description text not null default '',
  status text not null default 'pending',
  due_date timestamptz null,
  kanban_position double precision not null default 1.0,
  estimated_hours integer null,
  complexity text not null default 'simple',
  tags text[] not null default '{}',
  subtasks jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists tasks_project_id_idx on public.tasks (project_id);
create index if not exists tasks_status_idx on public.tasks (status);
create index if not exists tasks_project_status_pos_idx
  on public.tasks (project_id, status, kanban_position);

-- Si vas a usar RLS, descomenta y crea políticas.
-- alter table public.projects enable row level security;
-- alter table public.tasks enable row level security;
-- create policy "public read projects" on public.projects for select using (true);
-- create policy "public write projects" on public.projects for all using (true) with check (true);
-- create policy "public read tasks" on public.tasks for select using (true);
-- create policy "public write tasks" on public.tasks for all using (true) with check (true);

