---
name: agent-updater
description: Kỹ năng quét, kiểm tra tính năng mới và nâng cấp cấu hình hệ thống Agent theo chuẩn tài liệu chính thức Antigravity IDE. Chỉ kích hoạt khi Người Dùng yêu cầu cập nhật, bảo trì hoặc kiểm tra tính năng mới của Agent.
---

# KỸ NĂNG BẢO TRÌ & NÂNG CẤP HỆ THỐNG AGENT (AGENT UPDATER)

Kỹ năng này chịu trách nhiệm kiểm tra, thẩm định và nâng cấp cấu hình Agent (Skills, Rules, Plugins, Hooks) mỗi khi Google Antigravity IDE phát hành phiên bản mới hoặc khi Người Dùng yêu cầu tái cấu trúc.

---

## 1. NGUYÊN TẮC KÍCH HOẠT (TRIGGER DISCIPLINE)

> [!IMPORTANT]
> **Kỷ luật Tiết kiệm Ngữ cảnh (Token-Saving):**
> Kỹ năng này **TUYỆT ĐỐI KHÔNG ĐƯỢC TỰ ĐỘNG NẠP** trong các phiên làm việc thông thường.
> Chỉ mở tài liệu trong `references/` khi:
> 1. Người Dùng yêu cầu kiểm tra/quét cập nhật IDE Antigravity.
> 2. Người Dùng yêu cầu bổ sung, sửa đổi hoặc nâng cấp Rules / Skills / Plugins / Hooks.

---

## 2. QUY TRÌNH THỰC THI 4 BƯỚC (RUNBOOK)

### Bước 1: Nạp Prompt và Xác định Phạm vi Yêu cầu
- Đọc template chỉ dẫn tại [UPDATE_PROMPT.md](./resources/UPDATE_PROMPT.md).
- Tuân thủ nghiêm ngặt 4 nguyên tắc bảo toàn tại [rules/updater_discipline.md](../../rules/updater_discipline.md).
- Chạy script đối chiếu tự động nếu cần: [check_ide_updates.ps1](./scripts/check_ide_updates.ps1).
- Xác định mục tiêu của đợt cập nhật: bổ sung skill mới, cập nhật rule, cấu hình hook mới hay tái cấu trúc plugin.

### Bước 2: Tra cứu Tài liệu Chính thức Antigravity
Chỉ đọc đúng các tài liệu liên quan trong thư mục `references/`:
- **Tùy biến Agent:** Tra cứu tại [references/agy-customizations/](../../references/agy-customizations/SKILL.md)
  * Cấu hình Hooks: `../../references/agy-customizations/docs/hooks.md`
  * Cấu hình Plugins: `../../references/agy-customizations/docs/plugins.md`
  * Cấu hình JSON: `../../references/agy-customizations/docs/json_configs.md`
  * Cấu hình Rules: `../../references/agy-customizations/docs/rules.md`
  * Cấu hình Skills: `../../references/agy-customizations/docs/skills.md`
- **Chỉ dẫn Môi trường Antigravity:** Tra cứu tại [references/antigravity_guide/](../../references/antigravity_guide/SKILL.md)

### Bước 3: Lên Kế hoạch Nâng cấp (Planning Mode)
- Tạo bản thiết kế chi tiết tại `implementation_plan.md`.
- Trình bày rõ: File thêm mới, file sửa đổi, file bị xóa (nêu rõ lý do khoa học), cam kết bảo toàn nội dung.
- **Dừng lại và xin ý kiến Người Dùng (Proceed)** trước khi can thiệp vào bất kỳ file hệ thống nào.

### Bước 4: Thực thi & Kiểm định Toàn vẹn (QA/QC)
- Thực hiện các thay đổi một cách chuẩn xác.
- Chạy script kiểm toán hệ thống:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .agents\scripts\verify_refactoring.ps1
  ```
- Báo cáo kết quả minh bạch, cam kết zero-fabrication.
