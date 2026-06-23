-- Run this once in Supabase SQL Editor for the task-board project.
-- These tables store shared project tags, team members, task comments,
-- status update times, and pinned weekly notices for the public team board.

alter table public.tasks
  add column if not exists date_time text,
  add column if not exists deadline date,
  add column if not exists deadline_time text,
  add column if not exists assignee text,
  add column if not exists author text,
  add column if not exists collab text,
  add column if not exists note text,
  add column if not exists tags text[] not null default '{}',
  add column if not exists done boolean not null default false;

alter table public.tasks enable row level security;
alter table public.important_events enable row level security;

drop policy if exists "public read tasks" on public.tasks;
drop policy if exists "public insert tasks" on public.tasks;
drop policy if exists "public update tasks" on public.tasks;
drop policy if exists "public delete tasks" on public.tasks;
create policy "public read tasks" on public.tasks for select using (true);
create policy "public insert tasks" on public.tasks for insert with check (true);
create policy "public update tasks" on public.tasks for update using (true) with check (true);
create policy "public delete tasks" on public.tasks for delete using (true);

drop policy if exists "public read important_events" on public.important_events;
drop policy if exists "public insert important_events" on public.important_events;
drop policy if exists "public update important_events" on public.important_events;
drop policy if exists "public delete important_events" on public.important_events;
create policy "public read important_events" on public.important_events for select using (true);
create policy "public insert important_events" on public.important_events for insert with check (true);
create policy "public update important_events" on public.important_events for update using (true) with check (true);
create policy "public delete important_events" on public.important_events for delete using (true);

create table if not exists public.members (
  name text primary key,
  created_at timestamptz not null default now()
);

create table if not exists public.project_tags (
  name text primary key,
  created_at timestamptz not null default now()
);

create table if not exists public.task_meta (
  task_id uuid primary key references public.tasks(id) on delete cascade,
  status_updated_at timestamptz
);

create table if not exists public.task_comments (
  id text primary key,
  task_id uuid not null references public.tasks(id) on delete cascade,
  author text,
  text text not null,
  created_at timestamptz not null default now()
);

create index if not exists task_comments_task_id_created_at_idx
  on public.task_comments (task_id, created_at);

create table if not exists public.pinned_notices (
  id text primary key,
  text text not null,
  created_at timestamptz not null default now()
);

alter table public.members enable row level security;
alter table public.project_tags enable row level security;
alter table public.task_meta enable row level security;
alter table public.task_comments enable row level security;
alter table public.pinned_notices enable row level security;

drop policy if exists "public read members" on public.members;
drop policy if exists "public insert members" on public.members;
drop policy if exists "public update members" on public.members;
drop policy if exists "public delete members" on public.members;
create policy "public read members" on public.members for select using (true);
create policy "public insert members" on public.members for insert with check (true);
create policy "public update members" on public.members for update using (true) with check (true);
create policy "public delete members" on public.members for delete using (true);

drop policy if exists "public read project_tags" on public.project_tags;
drop policy if exists "public insert project_tags" on public.project_tags;
drop policy if exists "public update project_tags" on public.project_tags;
drop policy if exists "public delete project_tags" on public.project_tags;
create policy "public read project_tags" on public.project_tags for select using (true);
create policy "public insert project_tags" on public.project_tags for insert with check (true);
create policy "public update project_tags" on public.project_tags for update using (true) with check (true);
create policy "public delete project_tags" on public.project_tags for delete using (true);

drop policy if exists "public read task_meta" on public.task_meta;
drop policy if exists "public insert task_meta" on public.task_meta;
drop policy if exists "public update task_meta" on public.task_meta;
drop policy if exists "public delete task_meta" on public.task_meta;
create policy "public read task_meta" on public.task_meta for select using (true);
create policy "public insert task_meta" on public.task_meta for insert with check (true);
create policy "public update task_meta" on public.task_meta for update using (true) with check (true);
create policy "public delete task_meta" on public.task_meta for delete using (true);

drop policy if exists "public read task_comments" on public.task_comments;
drop policy if exists "public insert task_comments" on public.task_comments;
drop policy if exists "public update task_comments" on public.task_comments;
drop policy if exists "public delete task_comments" on public.task_comments;
create policy "public read task_comments" on public.task_comments for select using (true);
create policy "public insert task_comments" on public.task_comments for insert with check (true);
create policy "public update task_comments" on public.task_comments for update using (true) with check (true);
create policy "public delete task_comments" on public.task_comments for delete using (true);

drop policy if exists "public read pinned_notices" on public.pinned_notices;
drop policy if exists "public insert pinned_notices" on public.pinned_notices;
drop policy if exists "public update pinned_notices" on public.pinned_notices;
drop policy if exists "public delete pinned_notices" on public.pinned_notices;
create policy "public read pinned_notices" on public.pinned_notices for select using (true);
create policy "public insert pinned_notices" on public.pinned_notices for insert with check (true);
create policy "public update pinned_notices" on public.pinned_notices for update using (true) with check (true);
create policy "public delete pinned_notices" on public.pinned_notices for delete using (true);
