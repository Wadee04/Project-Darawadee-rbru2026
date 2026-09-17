-- ============================================================
-- Mock Data — Project Darawadee (DentBook)
-- วิธีใช้: รัน supabase_schema.sql ก่อน แล้วค่อยรันไฟล์นี้
--          Supabase Dashboard → SQL Editor → วาง → Run
-- หมายเหตุ: ข้อมูล users ต้องสร้างผ่าน Auth ก่อน
--           ไฟล์นี้ใส่แค่ตาราง clinics, doctors, services,
--           available_slots, bookings, notifications, reviews
-- ============================================================


-- ============================================================
-- CLINICS — คลินิก 3 แห่ง
-- ============================================================
insert into public.clinics (id, name, address, province, district, zip_code, phone, email, map_link, image_url)
values
  (
    'c1000000-0000-0000-0000-000000000001',
    'DentBook Clinic สาขาจันทบุรี',
    '123/45 ถนนราชดำเนิน ตำบลหน้าเมือง',
    'จันทบุรี', 'เมืองจันทบุรี', '22000',
    '039-134-456',
    'info@dentbook-chanthaburi.com',
    'https://maps.google.com/?q=DentBook+Chanthaburi',
    null
  ),
  (
    'c1000000-0000-0000-0000-000000000002',
    'SmileCare Dental Clinic',
    '88/12 ถนนสุขุมวิท ซอย 22 แขวงคลองเตย',
    'กรุงเทพมหานคร', 'คลองเตย', '10110',
    '02-123-4567',
    'info@smilecare.co.th',
    'https://maps.google.com/?q=SmileCare+Dental',
    null
  ),
  (
    'c1000000-0000-0000-0000-000000000003',
    'คลินิกทันตกรรมใจ๋',
    '56/7 ถนนเทศบาล 1 ตำบลท่าช้าง',
    'จันทบุรี', 'เมืองจันทบุรี', '22000',
    '039-200-789',
    'admin@dental-jai.com',
    'https://maps.google.com/?q=คลินิกทันตกรรมใจ๋',
    null
  );


-- ============================================================
-- DOCTORS — ทันตแพทย์ 6 คน
-- ============================================================
insert into public.doctors (id, clinic_id, full_name, specialty, available)
values
  (
    'd1000000-0000-0000-0000-000000000001',
    'c1000000-0000-0000-0000-000000000001',
    'ทพญ. อรุณี ปธานนท์',
    'ทันตกรรมทั่วไป',
    true
  ),
  (
    'd1000000-0000-0000-0000-000000000002',
    'c1000000-0000-0000-0000-000000000001',
    'ทพ. ณัฐพล สุขสวัสดิ์',
    'ทันตกรรมจัดฟัน',
    true
  ),
  (
    'd1000000-0000-0000-0000-000000000003',
    'c1000000-0000-0000-0000-000000000002',
    'ทพญ. พิมพ์ชนก วงศ์ทอง',
    'ทันตกรรมเด็ก',
    true
  ),
  (
    'd1000000-0000-0000-0000-000000000004',
    'c1000000-0000-0000-0000-000000000002',
    'ทพ. ชัยวัฒน์ รัตนโชติ',
    'ทันตกรรมรากฟันเทียม',
    true
  ),
  (
    'd1000000-0000-0000-0000-000000000005',
    'c1000000-0000-0000-0000-000000000003',
    'ทพญ. ดาราวดี อาลัย',
    'ทันตกรรมทั่วไป',
    true
  ),
  (
    'd1000000-0000-0000-0000-000000000006',
    'c1000000-0000-0000-0000-000000000003',
    'ทพ. ศุภกิจ มณีรัตน์',
    'ทันตกรรมเอ็นโดดอนต์',
    false
  );


-- ============================================================
-- SERVICES — บริการ 10 รายการ
-- ============================================================
insert into public.services (id, clinic_id, name, name_en, description, price, deposit_amount, duration_minutes, icon_name)
values
  -- Clinic 1
  (
    's1000000-0000-0000-0000-000000000001',
    'c1000000-0000-0000-0000-000000000001',
    'ตรวจสุขภาพฟันทั่วไป', 'Dental Check-up',
    'ตรวจสภาพฟัน เหงือก และช่องปากโดยทันตแพทย์',
    500, 0, 30, 'checkup'
  ),
  (
    's1000000-0000-0000-0000-000000000002',
    'c1000000-0000-0000-0000-000000000001',
    'ขูดหินปูน', 'Scaling',
    'ขูดหินปูนและทำความสะอาดช่องปาก',
    800, 200, 45, 'scaling'
  ),
  (
    's1000000-0000-0000-0000-000000000003',
    'c1000000-0000-0000-0000-000000000001',
    'อุดฟัน', 'Tooth Filling',
    'อุดฟันด้วยวัสดุคอมโพสิต',
    1200, 300, 60, 'filling'
  ),
  (
    's1000000-0000-0000-0000-000000000004',
    'c1000000-0000-0000-0000-000000000001',
    'ถอนฟัน', 'Tooth Extraction',
    'ถอนฟันโดยทันตแพทย์ผู้เชี่ยวชาญ',
    600, 150, 30, 'extraction'
  ),
  -- Clinic 2
  (
    's1000000-0000-0000-0000-000000000005',
    'c1000000-0000-0000-0000-000000000002',
    'จัดฟันแบบใส', 'Clear Aligner',
    'จัดฟันด้วยเครื่องมือใสไม่เจ็บปวด',
    85000, 5000, 60, 'braces'
  ),
  (
    's1000000-0000-0000-0000-000000000006',
    'c1000000-0000-0000-0000-000000000002',
    'ฟอกสีฟัน', 'Teeth Whitening',
    'ฟอกสีฟันให้ขาวสว่างขึ้น',
    3500, 500, 60, 'whitening'
  ),
  (
    's1000000-0000-0000-0000-000000000007',
    'c1000000-0000-0000-0000-000000000002',
    'รากฟันเทียม', 'Dental Implant',
    'ปลูกรากฟันเทียมทดแทนฟันที่หายไป',
    45000, 10000, 90, 'implant'
  ),
  -- Clinic 3
  (
    's1000000-0000-0000-0000-000000000008',
    'c1000000-0000-0000-0000-000000000003',
    'ตรวจสุขภาพฟันเด็ก', 'Pediatric Check-up',
    'ตรวจสุขภาพฟันเฉพาะสำหรับเด็ก',
    400, 0, 30, 'checkup'
  ),
  (
    's1000000-0000-0000-0000-000000000009',
    'c1000000-0000-0000-0000-000000000003',
    'ขูดหินปูนและเคลือบฟลูออไรด์',
    'Scaling & Fluoride',
    'ขูดหินปูนพร้อมเคลือบฟลูออไรด์ป้องกันฟันผุ',
    1000, 200, 60, 'scaling'
  ),
  (
    's1000000-0000-0000-0000-000000000010',
    'c1000000-0000-0000-0000-000000000003',
    'รักษารากฟัน', 'Root Canal Treatment',
    'รักษาคลองรากฟันสำหรับฟันที่ผุลึก',
    8000, 2000, 90, 'root_canal'
  );


-- ============================================================
-- AVAILABLE_SLOTS — ช่วงเวลาว่าง (30 วันข้างหน้า)
-- ============================================================
do $$
declare
  v_doctor_id uuid;
  v_clinic_id  uuid;
  v_date       date;
  v_hour       int;
  doctor_row   record;
begin
  for doctor_row in
    select d.id as doctor_id, d.clinic_id
    from public.doctors d
    where d.available = true
  loop
    v_doctor_id := doctor_row.doctor_id;
    v_clinic_id := doctor_row.clinic_id;

    for i in 0..29 loop
      v_date := current_date + i;
      -- ข้ามวันอาทิตย์ (dow = 0)
      if extract(dow from v_date) = 0 then
        continue;
      end if;

      -- slot ช่วงเช้า 09:00-12:00 ทุก 30 นาที
      for v_hour in 9..11 loop
        insert into public.available_slots
          (doctor_id, clinic_id, slot_date, slot_time, is_booked)
        values
          (v_doctor_id, v_clinic_id, v_date,
           make_time(v_hour, 0, 0), false),
          (v_doctor_id, v_clinic_id, v_date,
           make_time(v_hour, 30, 0), false)
        on conflict (doctor_id, slot_date, slot_time) do nothing;
      end loop;

      -- slot ช่วงบ่าย 13:00-17:00 ทุก 30 นาที
      for v_hour in 13..16 loop
        insert into public.available_slots
          (doctor_id, clinic_id, slot_date, slot_time, is_booked)
        values
          (v_doctor_id, v_clinic_id, v_date,
           make_time(v_hour, 0, 0), false),
          (v_doctor_id, v_clinic_id, v_date,
           make_time(v_hour, 30, 0), false)
        on conflict (doctor_id, slot_date, slot_time) do nothing;
      end loop;
    end loop;
  end loop;
end;
$$;


-- ============================================================
-- BOOKINGS — การจอง 5 รายการ (ตัวอย่าง)
-- หมายเหตุ: user_id ต้องเป็น uuid จาก auth.users จริงๆ
--           ตัวอย่างนี้ใช้ placeholder — แก้เป็น uuid จริงก่อนรัน
-- ============================================================

-- ดึง slot_id ตัวอย่างมาใช้
do $$
declare
  v_slot1 uuid;
  v_slot2 uuid;
  v_slot3 uuid;
begin
  select id into v_slot1 from public.available_slots
  where doctor_id = 'd1000000-0000-0000-0000-000000000001'
    and is_booked = false limit 1;

  select id into v_slot2 from public.available_slots
  where doctor_id = 'd1000000-0000-0000-0000-000000000002'
    and is_booked = false limit 1;

  select id into v_slot3 from public.available_slots
  where doctor_id = 'd1000000-0000-0000-0000-000000000005'
    and is_booked = false limit 1;

  -- *** แทนที่ 'YOUR_USER_UUID' ด้วย uuid จริงจาก Supabase Auth ***
  -- ไปดู uuid ได้ที่: Dashboard → Authentication → Users

  insert into public.bookings
    (booking_code, user_id, clinic_id, doctor_id, service_id,
     slot_id, appointment_date, appointment_time,
     status, deposit_amount, deposit_paid, note)
  values
    (
      'BK260801-0001',
      'YOUR_USER_UUID'::uuid,
      'c1000000-0000-0000-0000-000000000001',
      'd1000000-0000-0000-0000-000000000001',
      's1000000-0000-0000-0000-000000000002',
      v_slot1,
      current_date + 7, '10:00',
      'confirmed', 200, true,
      'ขูดหินปูนทั่วไป'
    ),
    (
      'BK260801-0002',
      'YOUR_USER_UUID'::uuid,
      'c1000000-0000-0000-0000-000000000001',
      'd1000000-0000-0000-0000-000000000002',
      's1000000-0000-0000-0000-000000000001',
      v_slot2,
      current_date + 14, '13:00',
      'waiting_payment', 0, false,
      null
    ),
    (
      'BK260801-0003',
      'YOUR_USER_UUID'::uuid,
      'c1000000-0000-0000-0000-000000000003',
      'd1000000-0000-0000-0000-000000000005',
      's1000000-0000-0000-0000-000000000009',
      v_slot3,
      current_date + 3, '09:00',
      'completed', 200, true,
      'เคลือบฟลูออไรด์ด้วย'
    ),
    (
      'BK260801-0004',
      'YOUR_USER_UUID'::uuid,
      'c1000000-0000-0000-0000-000000000001',
      'd1000000-0000-0000-0000-000000000001',
      's1000000-0000-0000-0000-000000000003',
      null,
      current_date - 30, '10:30',
      'cancelled', 300, false,
      'ยกเลิกเนื่องจากติดธุระ'
    ),
    (
      'BK260801-0005',
      'YOUR_USER_UUID'::uuid,
      'c1000000-0000-0000-0000-000000000002',
      'd1000000-0000-0000-0000-000000000003',
      's1000000-0000-0000-0000-000000000006',
      null,
      current_date - 60, '14:00',
      'completed', 500, true,
      'ฟอกสีฟัน 1 session'
    );

exception when others then
  raise notice 'กรุณาแทนที่ YOUR_USER_UUID ด้วย uuid จริงจาก Authentication → Users';
end;
$$;


-- ============================================================
-- NOTIFICATIONS — การแจ้งเตือน 4 รายการ
-- *** แทนที่ YOUR_USER_UUID เช่นกัน ***
-- ============================================================
do $$
begin
  insert into public.notifications
    (user_id, type, title, body, is_read)
  values
    (
      'YOUR_USER_UUID'::uuid,
      'appointment',
      'นัดหมายในอีก 1 วัน',
      'คุณมีนัดกับ ทพญ. อรุณี ปธานนท์ พรุ่งนี้เวลา 10:00 น.',
      false
    ),
    (
      'YOUR_USER_UUID'::uuid,
      'appointment',
      'ยืนยันการจองสำเร็จ',
      'การจองหมายเลข BK260801-0001 ได้รับการยืนยันแล้ว',
      true
    ),
    (
      'YOUR_USER_UUID'::uuid,
      'promotion',
      'โปรโมชั่นพิเศษ! ขูดหินปูนลด 20%',
      'จองภายใน 31 สิงหาคม รับส่วนลดทันที ไม่จำกัดจำนวน',
      false
    ),
    (
      'YOUR_USER_UUID'::uuid,
      'treatment_tip',
      'คำแนะนำหลังขูดหินปูน',
      'หลีกเลี่ยงอาหารร้อน เย็น หรือแข็งเป็นเวลา 24 ชั่วโมง',
      true
    );
exception when others then
  raise notice 'กรุณาแทนที่ YOUR_USER_UUID ด้วย uuid จริงจาก Authentication → Users';
end;
$$;


-- ============================================================
-- REVIEWS — รีวิวตัวอย่าง
-- *** แทนที่ YOUR_USER_UUID เช่นกัน ***
-- ============================================================
do $$
begin
  insert into public.reviews (user_id, rating, comment)
  values
    (
      'YOUR_USER_UUID'::uuid,
      5,
      'แอปใช้งานง่ายมาก จองคิวได้สะดวก ทีมงานตอบไวมากเลยค่ะ'
    );
exception when others then
  raise notice 'กรุณาแทนที่ YOUR_USER_UUID ด้วย uuid จริงจาก Authentication → Users';
end;
$$;


-- ============================================================
-- USER_NOTIFICATION_SETTINGS — ตั้งค่าเริ่มต้น
-- *** แทนที่ YOUR_USER_UUID เช่นกัน ***
-- ============================================================
do $$
begin
  insert into public.user_notification_settings
    (user_id, all_enabled, appointment, promotion, treatment_tip, feedback)
  values
    ('YOUR_USER_UUID'::uuid, true, true, true, true, true);
exception when others then
  raise notice 'กรุณาแทนที่ YOUR_USER_UUID ด้วย uuid จริงจาก Authentication → Users';
end;
$$;


-- ============================================================
-- วิธีหา uuid ของ user จริง
-- รัน query นี้หลังจาก signup ผ่านแอปแล้ว:
--
--   select id, email from auth.users;
--
-- แล้วเอา id มาแทนที่ YOUR_USER_UUID ทุกจุดด้านบน
-- ============================================================
