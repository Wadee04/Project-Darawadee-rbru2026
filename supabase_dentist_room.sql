-- Dentist / examination-room management migration
-- Run once in Supabase Dashboard -> SQL Editor.

-- Canonical clinic ownership used by admin services and RLS.
alter table public.clinics
  add column if not exists admin_id uuid references auth.users(id),
  add column if not exists status text not null default 'pending',
  add column if not exists registration_number text,
  add column if not exists operating_hours text;

create index if not exists clinics_admin_id_idx on public.clinics(admin_id);

-- Examination rooms.
create table if not exists public.rooms (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete cascade,
  name text not null check (length(trim(name)) > 0),
  specialty text,
  is_active boolean not null default true,
  display_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (clinic_id, name)
);

alter table public.rooms enable row level security;

-- Clinic owners can update their clinic record.
drop policy if exists "clinics: admin update own" on public.clinics;
create policy "clinics: admin update own" on public.clinics
  for update
  using (admin_id = auth.uid())
  with check (admin_id = auth.uid());

-- Doctor writes are restricted to the owning admin.
drop policy if exists "doctors: admin insert own clinic" on public.doctors;
create policy "doctors: admin insert own clinic" on public.doctors
  for insert with check (
    exists (
      select 1 from public.clinics c
      where c.id = doctors.clinic_id and c.admin_id = auth.uid()
    )
  );

drop policy if exists "doctors: admin update own clinic" on public.doctors;
create policy "doctors: admin update own clinic" on public.doctors
  for update
  using (
    exists (
      select 1 from public.clinics c
      where c.id = doctors.clinic_id and c.admin_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.clinics c
      where c.id = doctors.clinic_id and c.admin_id = auth.uid()
    )
  );

-- Anyone may read room availability; only clinic owner may mutate it.
drop policy if exists "rooms: read all" on public.rooms;
create policy "rooms: read all" on public.rooms
  for select using (true);

drop policy if exists "rooms: admin insert own clinic" on public.rooms;
create policy "rooms: admin insert own clinic" on public.rooms
  for insert with check (
    exists (
      select 1 from public.clinics c
      where c.id = rooms.clinic_id and c.admin_id = auth.uid()
    )
  );

drop policy if exists "rooms: admin update own clinic" on public.rooms;
create policy "rooms: admin update own clinic" on public.rooms
  for update
  using (
    exists (
      select 1 from public.clinics c
      where c.id = rooms.clinic_id and c.admin_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.clinics c
      where c.id = rooms.clinic_id and c.admin_id = auth.uid()
    )
  );

-- Reuse the project's updated_at trigger if available.
drop trigger if exists on_rooms_updated on public.rooms;
create trigger on_rooms_updated
  before update on public.rooms
  for each row execute procedure public.handle_updated_at();
