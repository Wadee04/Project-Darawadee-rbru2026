# Design Spec & โครงสร้างโปรเจกต์

## เทคโนโลยี
- Frontend: **Flutter** 3.47.0 (Dart 3.13.0), Material 3
- Backend / Database / Deployment: *ยังไม่กำหนด* (ระบุภายหลังเมื่อขึ้น logic จริง)

## โครงสร้างไดเรกทอรี
```
lib/
├─ main.dart                     # entry point → เปิดหน้า Intro1
├─ theme/                        # design tokens (แก้ที่นี่ให้ตรง Figma)
│  ├─ app_colors.dart
│  ├─ app_typography.dart
│  ├─ app_spacing.dart
│  └─ app_theme.dart
├─ src/
│  ├─ components/                # shared / reusable components
│  │  ├─ app_button.dart         # Button (primary/secondary/text)
│  │  ├─ app_input.dart          # Input (text field)
│  │  ├─ app_card.dart           # Card container
│  │  └─ page_indicator.dart     # (ใหม่) page dots สำหรับ onboarding
│  └─ utils/
│     └─ responsive.dart         # breakpoint helper mobile/tablet/desktop
└─ view/
   └─ Intro/
      └─ Intro1.dart             # หน้า Intro1
```

> หมายเหตุ: requirement ระบุ `src/components/` — ในโปรเจกต์ Flutter โค้ดต้องอยู่ใต้
> `lib/` เพื่อให้ import ได้ จึงวางไว้ที่ `lib/src/components/` (ตรงตามเจตนาเดิม)

## Design Tokens (placeholder — แทนด้วยค่า Figma จริง)
### สี (`app_colors.dart`)
| Token | ค่า placeholder | ใช้กับ |
|---|---|---|
| primary | `#2E7D5B` | ปุ่มหลัก, dot active |
| secondary | `#F2A03D` | accent |
| background | `#FFFFFF` | พื้นหลัง |
| surface | `#F7F8F7` | พื้น input/illustration |
| textPrimary | `#1A1C1B` | หัวข้อ |
| textSecondary | `#5F6562` | เนื้อความ |
| border | `#E2E5E3` | เส้นขอบ |

### ตัวอักษร (`app_typography.dart`)
ใช้ฟอนต์ระบบก่อน (`fontFamily = null`). scale: display 32 / headline 24 / title 18 / body 16 / button 16 / caption 13.

### ระยะห่าง (`app_spacing.dart`)
4pt scale: xs 4, sm 8, md 16, lg 24, xl 32, xxl 48, xxxl 64.

## Responsive
| อุปกรณ์ | ช่วงความกว้าง | layout ของ Intro1 |
|---|---|---|
| mobile | ≤ 600 | คอลัมน์เดียว ภาพบน–เนื้อหาล่าง จัดกึ่งกลาง |
| tablet | 601–1024 | คอลัมน์เดียว จำกัดความกว้าง content 480 |
| desktop | > 1024 | สองคอลัมน์: ภาพซ้าย / เนื้อหาขวา |

> ปรับ breakpoint ได้ที่ `AppBreakpoints` ใน `app_spacing.dart`
> หาก Figma มี frame แยกต่อขนาดจอ ให้ปรับ layout ตามนั้น

## Intro1 — เนื้อหา placeholder
- Title: "ยินดีต้อนรับสู่ Wadee"
- Description: ข้อความแนะนำสั้น ๆ
- Page indicator: 3 จุด, active = จุดแรก
- ปุ่ม: "เริ่มต้นใช้งาน" (primary), "ข้าม" (text)
- ภาพประกอบ: กล่อง placeholder ไอคอนรูปภาพ

## ขอบเขตที่ยัง **ไม่ทำ** ในรอบนี้
- Navigation จริงระหว่างหน้า (onNext/onSkip เป็น no-op)
- API / validation / state management
- Asset ภาพจริง
