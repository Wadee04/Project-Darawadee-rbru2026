-- ============================================================
-- Supabase Schema — Project Darawadee (DentBook)
-- วิธีใช้: คัดลอก SQL ทั้งหมดนี้ไปวางใน
--          Supabase Dashboard → SQL Editor → แล้วกด Run
-- ============================================================

-- ============================================================
-- 1. USERS — ข้อมูลผู้ใช้ (ต่อจาก auth.users)
-- ============================================================
create table if not exists public.users (
  id          uuid references auth.users(id) on delete cascade primary key,
  full_name   text,
  email       text,
  phone       text,
  birth_date  date,
  gender      text check (gender in ('male', 'female', 'other')),
  profile_image_url text,
  pin_hash    text,
  pin_enabled boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Auto-update updated_at
create or replace function public.handle_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger on_users_updated
  before update on public.users
  for each row execute procedure public.handle_updated_at();

-- Auto-insert row เมื่อ user สมัคร
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.users (id, email, full_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', '')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- RLS
alter table public.users enable row level security;

create policy "users: read own"  on public.users
  for select using (auth.uid() = id);

create policy "users: update own" on public.users
  for update using (auth.uid() = id);


-- ============================================================
-- 2. CLINICS — ข้อมูลคลินิก
-- ============================================================
create table if not exists public.clinics (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  address     text,
  province    text,
  district    text,
  zip_code    text,
  phone       text,
  email       text,
  map_link    text,
  image_url   text,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);

alter table public.clinics enable row level security;

-- ทุกคนดูคลินิกได้ (ไม่ต้อง login)
create policy "clinics: read all" on public.clinics
  for select using (true);


-- ============================================================
-- 3. DOCTORS — ทันตแพทย์
-- ============================================================
create table if not exists public.doctors (
  id          uuid primary key default gen_random_uuid(),
  clinic_id   uuid not null references public.clinics(id) on delete cascade,
  full_name   text not null,
  specialty   text,
  image_url   text,
  available   boolean not null default true,
  created_at  timestamptz not null default now()
);

alter table public.doctors enable row level security;

create policy "doctors: read all" on public.doctors
  for select using (true);


-- ============================================================
-- 4. SERVICES — บริการทันตกรรม
-- ============================================================
create table if not exists public.services (
  id               uuid primary key default gen_random_uuid(),
  clinic_id        uuid not null references public.clinics(id) on delete cascade,
  name             text not null,
  name_en          text,
  description      text,
  price            numeric(10,2) not null default 0,
  deposit_amount   numeric(10,2) not null default 0,
  duration_minutes int not null default 30,
  icon_name        text,
  is_active        boolean not null default true,
  created_at       timestamptz not null default now()
);

alter table public.services enable row level security;

create policy "services: read all" on public.services
  for select using (true);


-- ============================================================
-- 5. AVAILABLE_SLOTS — ช่วงเวลาว่าง
-- ============================================================
create table if not exists public.available_slots (
  id          uuid primary key default gen_random_uuid(),
  doctor_id   uuid not null references public.doctors(id) on delete cascade,
  clinic_id   uuid not null references public.clinics(id) on delete cascade,
  slot_date   date not null,
  slot_time   time not null,
  is_booked   boolean not null default false,
  created_at  timestamptz not null default now(),
  unique (doctor_id, slot_date, slot_time)
);

alter table public.available_slots enable row level security;

create policy "slots: read all" on public.available_slots
  for select using (true);


-- ============================================================
-- 6. BOOKINGS — การจองนัดหมาย (ตารางหลัก)
-- ============================================================
create table if not exists public.bookings (
  id               uuid primary key default gen_random_uuid(),
  booking_code     text unique not null,
  user_id          uuid not null references public.users(id) on delete cascade,
  clinic_id        uuid not null references public.clinics(id),
  doctor_id        uuid not null references public.doctors(id),
  service_id       uuid not null references public.services(id),
  slot_id          uuid references public.available_slots(id),
  appointment_date date not null,
  appointment_time time not null,
  status           text not null default 'waiting_payment'
                   check (status in (
                     'waiting_payment',
                     'confirmed',
                     'in_progress',
                     'completed',
                     'cancelled'
                   )),
  deposit_amount   numeric(10,2) not null default 0,
  deposit_paid     boolean not null default false,
  slip_url         text,
  note             text,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

create trigger on_bookings_updated
  before update on public.bookings
  for each row execute procedure public.handle_updated_at();

-- Auto-generate booking_code ถ้าไม่ได้ส่งมา
create or replace function public.generate_booking_code()
returns trigger language plpgsql as $$
begin
  if new.booking_code is null or new.booking_code = '' then
    new.booking_code := 'BK' || to_char(now(), 'YYMMDD') || '-' ||
                        lpad(floor(random() * 9999)::text, 4, '0');
  end if;
  return new;
end;
$$;

create trigger set_booking_code
  before insert on public.bookings
  for each row execute procedure public.generate_booking_code();

-- Mark slot เป็น booked เมื่อจอง
create or replace function public.mark_slot_booked()
returns trigger language plpgsql as $$
begin
  if new.slot_id is not null then
    update public.available_slots
    set is_booked = true
    where id = new.slot_id;
  end if;
  return new;
end;
$$;

create trigger on_booking_created
  after insert on public.bookings
  for each row execute procedure public.mark_slot_booked();

alter table public.bookings enable row level security;

create policy "bookings: read own" on public.bookings
  for select using (auth.uid() = user_id);

create policy "bookings: insert own" on public.bookings
  for insert with check (auth.uid() = user_id);

create policy "bookings: update own" on public.bookings
  for update using (auth.uid() = user_id);


-- ============================================================
-- 7. NOTIFICATIONS — การแจ้งเตือน
-- ============================================================
create table if not exists public.notifications (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.users(id) on delete cascade,
  type       text check (type in ('appointment', 'promotion', 'treatment_tip', 'feedback')),
  title      text not null,
  body       text,
  is_read    boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.notifications enable row level security;

create policy "notifications: read own" on public.notifications
  for select using (auth.uid() = user_id);

create policy "notifications: update own" on public.notifications
  for update using (auth.uid() = user_id);


-- ============================================================
-- 8. REVIEWS — คะแนนรีวิวแอป
-- ============================================================
create table if not exists public.reviews (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.users(id) on delete cascade,
  rating     int not null check (rating between 1 and 5),
  comment    text,
  created_at timestamptz not null default now()
);

alter table public.reviews enable row level security;

create policy "reviews: read own" on public.reviews
  for select using (auth.uid() = user_id);

create policy "reviews: insert own" on public.reviews
  for insert with check (auth.uid() = user_id);


-- ============================================================
-- 9. USER_NOTIFICATION_SETTINGS — ตั้งค่าการแจ้งเตือน
-- ============================================================
create table if not exists public.user_notification_settings (
  user_id          uuid primary key references public.users(id) on delete cascade,
  all_enabled      boolean not null default true,
  appointment      boolean not null default true,
  promotion        boolean not null default true,
  treatment_tip    boolean not null default true,
  feedback         boolean not null default true,
  updated_at       timestamptz not null default now()
);

create trigger on_notification_settings_updated
  before update on public.user_notification_settings
  for each row execute procedure public.handle_updated_at();

alter table public.user_notification_settings enable row level security;

create policy "notif_settings: read own" on public.user_notification_settings
  for select using (auth.uid() = user_id);

create policy "notif_settings: upsert own" on public.user_notification_settings
  for all using (auth.uid() = user_id);


-- ============================================================
-- STORAGE BUCKETS — สำหรับเก็บไฟล์รูปภาพ/สลิป
-- ============================================================
-- รัน SQL นี้แยก หรือสร้างผ่าน Dashboard → Storage

insert into storage.buckets (id, name, public)
values
  ('avatars',       'avatars',       true),
  ('slips',         'slips',         false),
  ('clinic-images', 'clinic-images', true)
on conflict (id) do nothing;

-- Policy สำหรับ avatars (user อัปโหลดรูปตัวเองได้)
create policy "avatars: upload own" on storage.objects
  for insert with check (
    bucket_id = 'avatars' and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "avatars: read all" on storage.objects
  for select using (bucket_id = 'avatars');

-- Policy สำหรับ slips (user อัปโหลด/ดูสลิปตัวเองได้)
create policy "slips: upload own" on storage.objects
  for insert with check (
    bucket_id = 'slips' and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "slips: read own" on storage.objects
  for select using (
    bucket_id = 'slips' and auth.uid()::text = (storage.foldername(name))[1]
  );
