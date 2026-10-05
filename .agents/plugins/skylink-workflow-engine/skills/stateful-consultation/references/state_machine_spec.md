# ĐẶC TẢ CHI TIẾT MÁY TRẠNG THÁI TƯ VẤN (state_machine_spec.md)

## 1. NGUYÊN TẮC BẢO TOÀN VÒNG ĐỜI
Máy trạng thái tư vấn (Stateful Consultation Machine) kiểm soát tiến trình hội thoại giữa Sales và Hệ thống Trợ lý AI.

### Bảng Ma Trận Chuyển Đổi Trạng Thái Hợp Lệ

| Trạng Thái Nguồn (From) | Trạng Thái Đích (To) | Điều Kiện Kích Hoạt (Condition / Trigger) | Người Thực Hiện (Actor) |
| :--- | :--- | :--- | :--- |
| `DISCOVERY` | `COLLECTING_REQUIREMENTS` | Sales gửi tin nhắn mô tả nhu cầu đầu tiên | SALES |
| `COLLECTING_REQUIREMENTS` | `COLLECTING_REQUIREMENTS` | `missing_fields.length > 0` (Missing-info loop) | SYSTEM |
| `COLLECTING_REQUIREMENTS` | `SERVICE_MATCHING` | Đủ 100% trường bắt buộc theo Profile | SYSTEM |
| `SERVICE_MATCHING` | `SERVICE_RECOMMENDED` | Hybrid Retrieval & Guardrail trả về Candidate hợp lệ | SYSTEM |
| `SERVICE_RECOMMENDED` | `PROPOSAL_READY` | Sales chọn dịch vụ mục tiêu | SALES |
| `PROPOSAL_READY` | `PROPOSAL_GENERATED` | Sinh thành công Proposal JSON có Zod validation | SYSTEM |
| `PROPOSAL_GENERATED` | `REVIEW_REQUIRED` | Sales gửi yêu cầu phê duyệt đề xuất | SALES |
| `REVIEW_REQUIRED` | `APPROVED` | Reviewer bấm nút Approve | REVIEWER / ADMIN |
| `REVIEW_REQUIRED` | `REVISION_NEEDED` | Reviewer yêu cầu chỉnh sửa thông số | REVIEWER / ADMIN |
| `REVISION_NEEDED` | `PROPOSAL_GENERATED` | Sales cập nhật dữ liệu và sinh lại bản thảo | SALES |

---

## 2. QUY ĐỊNH BẢO MẬT & CHỐNG BỎ BƯỚC
- Hệ thống từ chối mọi yêu cầu chuyển bước nhảy cóc (ví dụ: từ `DISCOVERY` nhảy thẳng sang `PROPOSAL_READY`).
- Khi phát hiện vi phạm chuyển bước, API trả mã lỗi `400 Bad Request` kèm thông báo: `"Chuyển trạng thái không hợp lệ theo quy trình nghiệp vụ SkyLink."`
