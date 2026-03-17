# The_Mamu
lib/
├── core/
│   ├── errors/          # จัดการ Exception และ Failure ต่างๆ
│   ├── network/         # คลาสตั้งค่า HTTP Client (เช่น Dio หรือ http)
│   ├── theme/           # ค่าสี, ฟอนต์, สไตล์ของแอป
│   └── utils/           # ฟังก์ชันช่วยเหลือ (Helper functions)
├── features/
│   └── auth/            # ฟีเจอร์ตัวอย่าง: Authentication
│       ├── data/
│       │   ├── datasources/  # โค้ดยิง API (Remote) หรือดึงข้อมูลเครื่อง (Local)
│       │   ├── models/       # คลาสข้อมูลที่ผูกกับ JSON (มี fromJson/toJson)
│       │   └── repositories/ # คลาสที่ Implement การดึงข้อมูลจริง
│       ├── domain/
│       │   ├── entities/     # โครงสร้างข้อมูลหลัก (เป็น Dart ล้วน ไม่มี JSON)
│       │   ├── repositories/ # Abstract class หรือ Interface (กำหนดสเปก)
│       │   └── usecases/     # โลจิกการทำงาน (1 คลาส = 1 หน้าที่ เช่น LoginUser)
│       └── presentation/
│           ├── pages/        # หน้าจอหลัก (เช่น login_page.dart)
│           ├── widgets/      # ชิ้นส่วน UI ย่อย (เช่น login_button.dart)
│           └── state/        # ตัวจัดการ State (เช่น Bloc, Riverpod, Provider)
├── injection.dart       # ไฟล์ตั้งค่า Dependency Injection (DI)
└── main.dart            # ไฟล์เริ่มต้นรันแอป

กฎเหล็ก 3 ข้อของการเขียนแบบนี้:

Domain ห้ามขึ้นตรงกับใคร: ในโฟลเดอร์ domain/ ต้องเป็น Dart ล้วน ห้ามมีการ import โค้ดที่เกี่ยวกับ UI (Material/Cupertino) หรือ โค้ดฝั่ง Data (API/JSON) เด็ดขาด

UI ห้ามต่อ API ตรงๆ: ไฟล์ใน presentation/ ห้ามยิง HTTP request เอง ต้องเรียกผ่าน State หรือ Usecase เท่านั้น

Core สำหรับของส่วนรวม: อะไรที่ฟีเจอร์อื่นต้องใช้ร่วมกัน (เช่น คลาสเช็กสถานะอินเทอร์เน็ต) ให้เก็บไว้ใน core/