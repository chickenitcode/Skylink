# HƯỚNG DẪN KHỞI CHẠY VÀ LÀM VIỆC DỰ ÁN GASCOLAE SKYLINK (MVP)

Chào mừng nhóm 3 Developer. Đây là tài liệu duy nhất bạn cần đọc để bắt đầu code ngay lập tức mà không bị block bởi các thành viên khác.

---

## 1. Giới thiệu dự án
GASCOLAE Service Intelligence (SkyLink) là trợ lý di động nội bộ hỗ trợ tra cứu tri thức, tư vấn và tự động lập Proposal cho các dịch vụ máy bay không người lái (UAV) của GASCOLAE.

Mục tiêu cốt lõi: 3 developer làm việc ĐỘC LẬP song song bằng cách bám vào **Hợp đồng dữ liệu (Data Contract)**.

---

## 2. Kiến trúc tổng thể
- **Mobile Client**: Native Android (Java), kiến trúc MVVM, Navigation Component.
- **Backend API**: NestJS (TypeScript), Prisma ORM, quản trị luồng State Machine.
- **AI / Database**: PostgreSQL 16 + pgvector, mô hình chuẩn hóa tri thức (Canonical Knowledge), Google Gemini LLM, Guardrails 2 tầng.

---

## 3. Technology Stack
### Mobile (Thành viên A)
- Native Android Java
- Retrofit + OkHttp (Gọi API)
- Android ViewModel + LiveData/StateFlow
- Navigation Component
- Material 3
- EncryptedSharedPreferences (lưu token an toàn)

### Backend (Thành viên B)
- Node.js + NestJS
- Prisma ORM + PostgreSQL 16
- JWT Authentication & RBAC

### AI & Data (Thành viên C)
- pgvector (Cosine Similarity)
- Google Gemini LLM (Structured JSON Output)
- docxtemplater + LibreOffice Headless (Sinh DOCX/PDF)

---

## 4. Cấu trúc Repository
```text
gascolae-service-intelligence/
├── apps/
│   ├── mobile/         # (Thành viên A) Android Native App
│   └── api/            # (Thành viên B & C) NestJS API
├── packages/
│   └── contracts/      # CHỨA openapi.yaml (Hợp đồng API)
├── knowledge/          # Dữ liệu nguồn và script chunking
├── proposal/           # Mẫu template DOCX
├── docs/               # Tài liệu thiết kế
├── docker-compose.yml  # Database + LibreOffice
└── .env.example        # Cấu hình môi trường
```

---

## 5. Cách setup máy mới

### A. Khởi chạy Database & Backend (Thành viên B & C)
1. Copy `.env.example` thành `.env` và điền thông tin (có thể dùng cấu hình mặc định cho local).
2. Chạy Database:
   ```bash
   docker compose up -d
   ```
3. Cài đặt và khởi chạy API:
   ```bash
   cd apps/api
   npm install
   npx prisma generate
   npx prisma migrate dev --name init
   npm run seed
   npm run start:dev
   ```

### B. Khởi chạy Mobile App (Thành viên A)
1. Mở thư mục `apps/mobile` bằng **Android Studio**.
2. Chờ Gradle sync hoàn tất.
3. Chạy ứng dụng trên Emulator hoặc thiết bị thật (nhấn nút Run - Shift + F10).
4. *Lưu ý*: Trỏ URL API trong Retrofit về `http://10.0.2.2:3000/api/v1` (nếu dùng Emulator) hoặc địa chỉ IP mạng LAN của máy tính chạy Backend.

---

## 6. Cách chạy Mock Mode (Dành cho Thành viên A và B)
Trong tệp `.env` của thư mục `apps/api/`, thiết lập:
```env
USE_MOCK_LLM=true
USE_MOCK_EMBEDDING=true
```
- Khi bật chế độ này, Backend sẽ không gọi lên API của Google Gemini, mà sẽ trả về dữ liệu mẫu (Mock data) ngay lập tức.
- Giúp bạn phát triển, test luồng UI, test State Machine mà không tốn quota API hay bị block vì mạng.

---

## 7. Swagger API Documentation
Sau khi Backend chạy thành công, mở trình duyệt:
👉 **http://localhost:3000/api/docs**
- Đây là tài liệu API động, cho phép bạn test các endpoint trực tiếp.

---

## 8. Nguyên tắc làm việc độc lập của 3 Developer

### Đường biên giới: `packages/contracts/openapi.yaml`
1. **Thành viên A (Mobile)**: Dựa vào OpenAPI để viết Retrofit Interface, Data Models và tạo Mock Repository. KHÔNG CẦN CHỜ Backend code xong. Cứ code UI và gắn Mock Data.
2. **Thành viên B (Backend)**: Dựa vào OpenAPI để viết Controller, Service, DTO. Trả về đúng JSON contract. Cứ code logic DB và Auth.
3. **Thành viên C (AI)**: Dựa vào schema DB và OpenAPI để viết thuật toán Chunking, Prompt và LLM Parsing. Test độc lập bằng unit tests hoặc CLI script trong thư mục `knowledge/`.

**Quy tắc tối thượng**: Mọi thay đổi về Request/Response **BẮT BUỘC** phải được thảo luận, sau đó cập nhật vào `openapi.yaml` và thông báo cho toàn team.

---

## 9. API Contract & Database
- Khách hàng có nhu cầu -> Tạo Consultation Session (State `COLLECTING_REQUIREMENTS`).
- Thiếu thông tin -> Backend trả về mảng `missing_fields` -> Mobile render form.
- Đủ thông tin -> Chuyển State -> Trả kết quả `KnowledgeChunk` (Evidence).
- Xuất Proposal -> State `PROPOSAL_READY` -> Gen JSON -> Duyệt -> Render DOCX/PDF.

---

## 10. Git Branch Convention
- Nhánh chính: `main` (chỉ chứa code đã test và chạy được).
- Nhánh phát triển: `develop`
- Tính năng Mobile: `feature/mobile/ten-tinh-nang`
- Tính năng Backend: `feature/api/ten-tinh-nang`
- Tính năng AI/Data: `feature/ai/ten-tinh-nang`
- Sửa lỗi: `fix/ten-loi`

---

## 11. Quy tắc Commit (Conventional Commits)
- `feat(mobile): Thêm màn hình chi tiết dịch vụ`
- `feat(api): Xây dựng API tạo session tư vấn`
- `fix(ai): Sửa lỗi hallucination khi matching`
- `docs: Cập nhật README`

---

## 12. Definition of Done (DoD)
- Code compile thành công (không lỗi TypeScript / Gradle build lỗi).
- Các luồng happy path chạy được từ đầu đến cuối.
- Nếu là API mới -> Đã cập nhật Swagger.
- Nếu là màn hình mới -> Đã xử lý loading và error state.

Chúc team làm việc hiệu quả và ra mắt MVP đúng tiến độ! 🚀
