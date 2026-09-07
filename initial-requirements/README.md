# Wadee — Initial Requirements (Source of Truth)

โฟลเดอร์นี้เป็นแหล่งความจริงหลัก (source of truth) ของโปรเจกต์ Wadee
เอกสารทั้งหมดในนี้ใช้อ้างอิงระหว่างพัฒนา

## สถานะปัจจุบัน
- ขอบเขตงานปัจจุบัน: สร้าง **UI เท่านั้น** ยังไม่ต่อ logic จริง (API, validation)
- หน้าที่ทำแล้ว: `Intro1` (`lib/view/Intro/Intro1.dart`)

## ข้อควรทราบเรื่อง Figma
- Frame อ้างอิง: Project-Wadee `node-id=25-382`
  (https://www.figma.com/design/dtj0IOp74rA59IPGUQeIZy/Project-Wadee?node-id=25-382)
- ณ ตอน scaffold ยัง **เข้าถึง Figma frame โดยตรงไม่ได้** (ลิงก์ตอบ HTTP 403)
  ค่าดีไซน์ (สี/ฟอนต์/ระยะ/ข้อความ) ในโค้ดจึงเป็น **placeholder**
- เมื่อได้สเปกจริงจาก Figma (ผ่าน Figma MCP / export) ให้แทนค่าที่:
  - สี → `lib/theme/app_colors.dart`
  - ตัวอักษร → `lib/theme/app_typography.dart`
  - ระยะ/รัศมี/breakpoint → `lib/theme/app_spacing.dart`
  - ข้อความ/ภาพของหน้า Intro1 → ค่าคงที่ใน `lib/view/Intro/Intro1.dart`

ดูรายละเอียดโครงสร้างและ mapping ที่ `design-spec.md`
