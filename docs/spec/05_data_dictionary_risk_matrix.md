# TỪ ĐIỂN DỮ LIỆU DÙNG CHUNG & MA TRẬN QUẢN TRỊ RỦI RO (DATA DICTIONARY & RISK MATRIX)

> **Mã hồ sơ**: `SPEC-MOD-05`  
> **Module**: Shared Data Dictionary & Anti-Hallucination Risk Matrix  
> **Vị trí tài liệu**: `docs/spec/05_data_dictionary_risk_matrix.md`  
> **Phụ trách triển khai**: Toàn bộ nhóm phát triển (Thành viên A, B, C)  
> **Điều hướng liên kết**: [⬅️ Module 04 (Proposal)](./04_proposal_pipeline_spec.md) | [📋 Mục Lục](./README.md) | [Tiếp theo: Module 06 (Catalog) ➡️](./06_knowledge_catalog_ingestion_spec.md)

---

## 1. TỪ ĐIỂN DỮ LIỆU DÙNG CHUNG (SHARED DATA DICTIONARY)

Bảng đối chiếu kiểu dữ liệu giữa TypeScript (Client & Backend), Prisma ORM (Database) và Zod Schemas:

| Tên Trường (Field) | Kiểu Dữ Liệu TypeScript | Kiểu Prisma PostgreSQL | Ý Nghĩa Kỹ Thuật | Ví Dụ Mẫu |
| :--- | :--- | :--- | :--- | :--- |
| `user_id` | `string` (UUID v4) | `String @id @default(uuid())` | Mã định danh duy nhất của người dùng | `usr_sales_01` |
| `role` | `'SALES' \| 'REVIEWER' \| 'ADMIN'` | `String` | Nhóm vai trò phân quyền RBAC | `SALES` |
| `permissions` | `string[]` | `String[]` | Danh sách quyền nguyên tử được cấp | `["service:read", "proposal:create"]` |
| `service_id` | `string` | `String @id` | Mã định danh dịch vụ Canonical | `S0112` |
| `service_name` | `string` | `String` | Tên chính thức của gói dịch vụ | `Giám sát Không phận Nông nghiệp` |
| `chunk_id` | `string` (Deterministic) | `String @unique` | Mã định danh duy nhất của Semantic Chunk | `CHK_S0112_CAP_a12f9b8c` |
| `record_type` | `'overview' \| 'capability' \| 'problem' \| 'service_level' \| 'deliverable' \| 'condition'` | `String` | Loại bản ghi tri thức theo schema | `capability` |
| `visibility` | `'public' \| 'internal' \| 'restricted'` | `String @default("internal")` | Mức độ bảo mật của đơn vị tri thức | `internal` |
| `status` | `'verified' \| 'draft' \| 'archived'` | `String @default("draft")` | Trạng thái thẩm định của dữ liệu | `verified` |
| `embedding` | `number[]` | `Unsupported("vector(768)")` | Vector nhúng ngữ nghĩa (Gemini 768 dims) | `[0.012, -0.045, ...]` |
| `source_ids` | `string[]` | `String[]` | Danh sách ID tài liệu gốc kiểm chứng | `["SRC_AGRI_SPEC_2026_01"]` |
| `session_id` | `string` (UUID v4) | `String @id @default(uuid())` | Mã phiên tư vấn | `ses_7f8a9b1c-2d3e-4f5a` |
| `session_state` | `ConsultationState` | `String` | Trạng thái máy của phiên tư vấn | `SERVICE_MATCHING` |
| `proposal_id` | `string` | `String @id` | Mã định danh bản thảo Proposal | `PROP_2026_S0112_0089` |
| `evidence_chunk_ids`| `string[]` | `String[]` | Mảng chunk_id trích dẫn chứng minh | `["CHK_S0112_CAP_a12f9b8c"]` |

---

## 2. MA TRẬN QUẢN TRỊ RỦI RO & BẢO VỆ CHỐNG ẢO GIÁC (RISK MATRIX)

Hệ thống SkyLink áp dụng các quy tắc chốt chặn tự động để bảo đảm tính an toàn pháp lý và thương mại:

| Trường Dữ Liệu | Nguồn Kiểm Chứng Tối Cao | Hành Vi Bị Cấm (Bị Guardrail chặn đứng) | Cơ Chế Phạt Khi Vi Phạm |
| :--- | :--- | :--- | :--- |
| `service_id` | Bảng Canonical `services` | Cấm LLM tự đề xuất mã dịch vụ không tồn tại trong database. | Bị từ chối ngay ở Post-check, kích hoạt fallback `NO_MATCH`. |
| `scope_summary` | Trích xuất từ Customer Requirements | Cấm tự ý mở rộng phạm vi dịch vụ vượt ngoài năng lực thiết bị. | Đánh dấu cảnh báo đỏ và yêu cầu Sales xác nhận lại. |
| `evidence_chunk_ids` | Kết quả truy vấn Hybrid Retrieval | Cấm trích dẫn `chunk_id` ảo giác không tồn tại trong context được nạp. | Chặn đứng phản hồi, kích hoạt Retry Safe Mode (tối đa 2 lần). |
| `pricing / discount` | Bảng giá chính thức của GASCOLAE | Cấm LLM tự ý sinh giá bán, giảm giá hoặc cam kết "giá rẻ nhất". | Xóa bỏ nội dung giá, gắn nhãn `[CẦN XÁC MINH VỚI PHÒNG TÀI CHÍNH]`. |
| `timeline / SLA` | `record_type = service_level` | Cấm hứa hẹn thời gian bàn giao phi thực tế (ví dụ: giao trong 24h). | Buộc phải trích dẫn SLA tiêu chuẩn từ `service_level`. |
| `approval_status` | Quyết định Reviewer có thẩm quyền | Nghiêm cấm hệ thống tự ý đổi trạng thái sang `APPROVED`. | Trạng thái mặc định luôn là `REVIEW_REQUIRED`. |
