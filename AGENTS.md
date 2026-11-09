# AGENTS.md — กติกาการแก้ไขโค้ดของโปรเจกต์ DentBook

## หลักการสำคัญ: แก้หน้าไหน ต้องไม่กระทบหน้าอื่น

โปรเจกต์นี้ผู้ใช้แก้ดีไซน์ทีละหน้า และต้องการให้ **การแก้ไขในหน้าหนึ่งไม่ไปเปลี่ยนหน้าอื่น**

1. **หน้าตาของแต่ละหน้าต้องอยู่ในไฟล์ของหน้านั้น**
   - ถ้าคอมโพเนนต์ใดถูกใช้เฉพาะหน้าเดียว ให้ย้ายไปประกาศในไฟล์ของหน้านั้น (เป็น `private` เช่น `_Foo`) ไม่ใช่เก็บใน `lib/components/shared_widgets.dart`
   - ตัวอย่างที่ใช้แล้ว: `QueueCard`, `FilterAndCardList`, `_FilterBox`, `_AssetIcon` อยู่ใน `lib/view/User/My_queue/my_queue_two.dart`
2. **คอมโพเนนต์ที่ใช้ร่วมกัน (shared) ต้อง "override ได้"**
   - ห้ามแก้ไฟล์ shared เพื่อเปลี่ยนหน้าตาเฉพาะหน้าใดหน้าหนึ่ง
   - ให้เพิ่มพารามิเตอร์ตัวเลือก/override แล้วให้แต่ละหน้าส่งค่าของตัวเอง
   - ตัวอย่าง: `AppBottomNav(items: ...)` — ถ้าหน้าไหนอยากได้แถบล่างต่างจากเดิม ให้ประกาศ `AppNavItem` ของตัวเองในไฟล์ของหน้านั้นแล้วส่งเข้ามา แทนการไปแก้ `shared_widgets.dart`
3. **แยก logic กับ UI ให้ชัด**
   - ไฟล์ที่เป็น "หน้าจริง" เก็บ logic (โหลดข้อมูล, routing, state)
   - ไฟล์ที่เป็น "ไฟล์ดีไซน์" เก็บ widget สำหรับหน้านั้น (การ์ด, ตัวกรอง) แล้วหน้าจริง import มาใช้
4. **ถ้าผู้ใช้แจ้งว่า "แก้ในหน้านี้" ให้แก้เฉพาะไฟล์ที่ผู้ใช้เปิดอยู่** แล้วเชื่อมโยงให้หน้าจริงใช้ widget จากไฟล์นั้น (เช่น `cardBuilder`)

## โครงสร้างสำคัญ

- `lib/components/shared_widgets.dart` — คอมโพเนนต์ที่ใช้ร่วมกันจริง ๆ (เช่น `AppBottomNav`, `BrandLogo`, `PillButton`, `OnboardingPage`)
- `lib/router/app_router.dart` — จุดเดียวที่คุมการนำทาง (`AppRouter.goBottomTab` ใช้กับแถบล่างทุกหน้า)
- `lib/view/User/My_queue/my_queue_one.dart` — logic หน้า "คิวของฉัน" (แท็บ, QR, การกดแต่ละใบ)
- `lib/view/User/My_queue/my_queue_two.dart` — UI/ดีไซน์ของหน้า "คิวของฉัน" (การ์ด, ตัวกรองช่วงเวลา/เรียงลำดับ)

## กติกาทางเทคนิคที่เจอบ่อย

- `Image.asset` **ไม่มี** พารามิเตอร์ `colorFilter` (ใช้ได้เฉพาะ `SvgPicture.asset`) → ใช้ `color:` (เป็น BlendMode.srcIn) หรือห่อด้วย `ColorFiltered`
- `Border.all` / `Border.fromBorderSide` **ไม่ใช่ const** → ถ้าใส่ใน `BoxDecoration` ต้องถอด `const` ออกจาก `BoxDecoration` (แต่ค่า `Color` ข้างในยังเป็น `const` ได้)
- path ของ asset ต้องมีไฟล์จริงใน `assets/` และประกาศใน `pubspec.yaml` แล้ว ถ้าเพิ่งลบไฟล์ ให้รัน `flutter clean` เพื่อล้าง manifest เก่า
- `flutter analyze lib` ต้องไม่มี error ก่อนจบงาน (info/warning เดิมของโปรเจกต์ใช้ได้)
- โค้ดที่ไม่ถูกเรียกใช้ = dead code ควรลบออก เพราะทำให้แก้ผิดที่ (เช่น `my_queue_two.dart` ที่เคยไม่ถูก route)
