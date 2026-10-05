# KỶ LUẬT QUẢN TRỊ MÁY TRẠNG THÁI & DUYỆT ĐỀ XUẤT (workflow_state_discipline.md)

## 1. NGUYÊN TẮC QUẢN TRỊ TRẠNG THÁI (STATE DISCIPLINE)
1. **BACKEND SOLE SOURCE OF TRUTH**:
   - Backend NestJS sở hữu độc quyền toàn bộ vòng đời và logic chuyển đổi trạng thái (State Machine Transitions) của các phiên tư vấn (`consultation_sessions`) và đề xuất giải pháp (`proposals`).
   - Ứng dụng Mobile Client **CẤM TUYỆT ĐỐI** tự gán trạng thái hoặc tự chuyển bước. Mobile chỉ gửi sự kiện người dùng (User Action) lên Backend và nhận về trạng thái mới được phản hồi từ cơ sở dữ liệu.
2. **DETERMINISTIC VALIDATION TRƯỚC KHI CHUYỂN BƯỚC**:
   - Máy trạng thái không bao giờ chuyển bước dựa trên suy đoán ngẫu nhiên.
   - Trạng thái chỉ được chuyển từ `COLLECTING_REQUIREMENTS` sang `SERVICE_MATCHING` khi và chỉ khi **toàn bộ 4 trường bắt buộc** trong `CustomerRequirementsSchema` (`problem`, `objective`, `deployment_context`, `timeline_expectation`) đã được xác thực hợp lệ bằng Zod.

---

## 2. KỶ LUẬT PHÊ DUYỆT HUMAN REVIEW (APPROVAL DISCIPLINE)
1. **CẤM TỰ ĐỘNG PHÁT HÀNH (NO AUTO-APPROVAL)**:
   - Một Proposal do AI sinh ra dù đạt điểm số kiểm toán cao đến đâu cũng **KHÔNG BAO GIỜ** được hệ thống tự động gán trạng thái `APPROVED`.
   - Trạng thái sau khi sinh thành công tối đa chỉ là `REVIEW_REQUIRED`.
2. **PHÂN QUYỀN DUYỆT NGHIÊM NGẶT**:
   - Chỉ người dùng có vai trò `REVIEWER` hoặc `ADMIN` và được cấp quyền `PROPOSAL_APPROVE` mới có thể gọi endpoint `POST /api/proposals/:id/review` với hành động `APPROVE`.
   - Sales chỉ có quyền `REQUEST_REVIEW` và xem danh sách bản thảo của chính mình.
3. **RENDER TÀI LIỆU CÓ ĐIỀU KIỆN**:
   - Hệ thống chỉ cho phép xuất và đóng dấu bản PDF chính thức khi Proposal đã đạt trạng thái `APPROVED`.
   - Các bản draft ở trạng thái `DRAFT` hoặc `REVIEW_REQUIRED` nếu xem trước trên mobile bắt buộc phải hiển thị hình mờ (Watermark) `"BẢN THẢO SƠ BỘ — CHƯA PHÊ DUYỆT"`.
