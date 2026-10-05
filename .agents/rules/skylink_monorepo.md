# QUY TẮC PHÁT TRIỂN MONOREPO & CHUẨN DTO DÙNG CHUNG (skylink_monorepo.md)

## 1. MỤC ĐÍCH & PHẠM VI ÁP DỤNG
Tài liệu này quy định kỷ luật kiến trúc Monorepo cho toàn bộ các thành viên phát triển dự án **GASCOLAE SkyLink**, bao gồm ứng dụng di động (`apps/mobile`), máy chủ API backend (`apps/api`), và gói thư viện hợp đồng dùng chung (`packages/shared`).

---

## 2. PHÂN ĐỊNH THƯ MỤC MONOREPO

```text
skylink-monorepo/
├── apps/
│   ├── mobile/         # Ứng dụng di động Expo / React Native (Thành viên A phụ trách)
│   └── api/            # Backend NestJS + Prisma ORM (Thành viên B phụ trách)
├── packages/
│   └── shared/         # Zod Schema DTO, TypeScript Types, Enums & Hằng số dùng chung
├── docs/               # Toàn bộ hồ sơ kiến trúc, đặc tả spec và kế hoạch dự án
├── .agents/            # Hệ thống Plugins, Skills, Rules của Agent
└── docker-compose.yml  # Hạ tầng PostgreSQL 16 + pgvector cục bộ
```

---

## 3. KỶ LUẬT LẬP TRÌNH TYPESCRIPT & HỢP ĐỒNG DỮ LIỆU

### 3.1. Chế độ Strict Mode Bắt Buộc:
- Toàn bộ các gói trong monorepo bắt buộc phải bật `"strict": true` trong `tsconfig.json`.
- **CẤM TUYỆT ĐỐI** sử dụng kiểu `any`. Trong trường hợp dữ liệu chưa xác định rõ kiểu hoặc đầu vào từ bên ngoài, bắt buộc sử dụng kiểu `unknown` và kiểm tra kiểu thông qua type-guard hoặc Zod parser trước khi truy cập thuộc tính.

### 3.2. Chân Lý Hợp Đồng Thuộc Về `packages/shared`:
- Mọi DTO (Data Transfer Object) giao tiếp qua REST API giữa `apps/mobile` và `apps/api` bắt buộc phải được định nghĩa bằng thư viện **Zod** trong `packages/shared`.
- Kiểu dữ liệu TypeScript phải được suy luận tự động từ Zod Schema bằng hàm `z.infer<typeof Schema>`:
  ```typescript
  // packages/shared/src/schemas/consultation.ts
  import { z } from 'zod';

  export const CustomerRequirementsSchema = z.object({
    problem: z.string().min(5),
    objective: z.string().min(5),
    deployment_context: z.string().min(3),
    timeline_expectation: z.string().min(2),
    budget_range: z.string().nullable().optional(),
    scale: z.string().nullable().optional(),
    constraints: z.array(z.string()).default([]),
  });

  export type CustomerRequirements = z.infer<typeof CustomerRequirementsSchema>;
  ```
- Backend `apps/api` dùng Zod Schema trong ValidationPipe.
- Mobile `apps/mobile` dùng TypeScript Types được import trực tiếp từ `packages/shared`, bảo đảm 100% không lệch hợp đồng dữ liệu.

---

## 4. QUY ƯỚC QUẢN TRỊ TRẠNG THÁI (STATE OWNERSHIP)
1. **Backend Độc Quyền Quản Lý State**: Mobile Client **KHÔNG ĐƯỢC PHÉP** tự ý gán hay chuyển đổi trạng thái phiên tư vấn (`consultation_sessions.state`) hoặc đề xuất (`proposals.status`).
2. Mobile chỉ gửi sự kiện/hành động của người dùng lên Backend; Backend tính toán logic máy trạng thái, kiểm tra điều kiện chuyển đổi và trả về trạng thái mới cho Mobile render.
3. Khi nhận được trạng thái `COLLECTING_REQUIREMENTS` với danh sách `missing_fields`, Mobile chỉ kích hoạt form bổ sung thông tin cho các trường còn thiếu, không tự ý kích hoạt tìm kiếm khớp dịch vụ.

---

## 5. KIỂM SOÁT PHIÊN BẢN & MÃ LỆNH TÍCH HỢP
- Khi có thay đổi về trường dữ liệu hoặc endpoint API:
  1. Thành viên phụ trách bắt buộc phải cập nhật tệp đặc tả tương ứng trong `docs/spec/`.
  2. Cập nhật Zod Schema tại `packages/shared`.
  3. Chạy `npm run typecheck` trên toàn bộ monorepo để bảo đảm không làm vỡ mã nguồn của thành viên khác trước khi commit.
