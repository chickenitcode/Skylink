# 📊 MA TRẬN LỰA CHỌN SƠ ĐỒ MERMAID CHO DỰ ÁN SKYLINK (GASCOLAE)

> 💡 **NGUYÊN TẮC: LỰA CHỌN SƠ ĐỒ THEO BẢN CHẤT KỸ THUẬT CỦA BÁO CÁO**  
> Thành viên dự án và AI Agent căn cứ vào thông điệp kiến trúc và câu chuyện kỹ thuật cần trình bày để **tự lựa chọn 1 đến 2 loại sơ đồ tối ưu nhất** từ kho 20+ sơ đồ của `mermaid-architect`.  
> Bảng dưới đây đóng vai trò là **khung định hướng mẫu & catalog tham khảo (Reference Patterns)** cho các hồ sơ kỹ thuật của hệ thống **GASCOLAE SkyLink**.

---

## 🧭 CƠ CHẾ LỰA CHỌN SƠ ĐỒ THEO BẢN CHẤT KỸ THUẬT

Khi chuẩn bị vẽ sơ đồ cho một tài liệu hoặc báo cáo kỹ thuật, hãy tự vấn 3 câu hỏi:
1. **Thông điệp cốt lõi cần truyền tải là gì?**
   - Phân tầng thành phần hệ thống $\to$ `flowchart TB` (C4 Container) hoặc `block-beta`.
   - Luồng dữ liệu nạp & xử lý $\to$ `flowchart LR` (Horizontal-First).
   - Máy trạng thái / Vòng đời phiên làm việc $\to$ `stateDiagram-v2`.
   - Vòng đời gọi API tuần tự giữa các bên $\to$ `sequenceDiagram`.
   - Cấu trúc cơ sở dữ liệu quan hệ $\to$ `erDiagram`.
   - Đo lường định lượng / Điểm số kiểm thử $\to$ `xychart-beta`.
   - Dòng chảy thanh lọc dữ liệu qua các tầng lọc $\to$ `sankey-beta`.
   - Ma trận đánh đổi giải pháp kỹ thuật $\to$ `flowchart TD` (2x2 Matrix) hoặc `quadrantChart`.
   - Lộ trình phát triển / Phân công tiến độ $\to$ `gantt` hoặc `timeline`.
2. **Loại sơ đồ nào giúp người đọc (Ban Giám Đốc, Giảng Viên Hướng Dẫn, Khách Hàng) hiểu nhanh nhất?**
3. **Sơ đồ có trả lời được câu hỏi "So-What?" không?** (Mỗi sơ đồ bắt buộc đi kèm giải thích ý nghĩa nghiệp vụ).

---

## 📌 BẢNG MA TRẬN GỢI Ý CHO 8 HỒ SƠ KỸ THUẬT CỐT LÕI SKYLINK

| STT | Hồ Sơ / Tài Liệu Báo Cáo | Sơ Đồ Gợi Ý Điển Hình (Mẫu 1) | Sơ Đồ Mở Rộng Ứng Biến (Mẫu 2) | Ý Nghĩa Kỹ Thuật Trả Lời (So-What?) |
| :---: | :--- | :--- | :--- | :--- |
| **01** | `Báo cáo Đề xuất & Kiến trúc Tổng thể` | `flowchart TB` (C4 Container) | `mindmap` (Danh mục dịch vụ) | Hệ thống gồm những thành phần nào? Mobile, Backend, PostgreSQL và AI liên kết ra sao? |
| **02** | `Đặc tả Dữ liệu Canonical & Chunking` | `flowchart LR` (Pipeline nạp tri thức) | `erDiagram` (Lược đồ Canonical DB) | Dữ liệu Service thô được chuyển hóa thành các Semantic Chunks và lưu trữ có quan hệ thế nào? |
| **03** | `Thiết kế Hybrid Retrieval Engine` | `flowchart LR` (FTS + Vector + RRF) | `sankey-beta` (Lưu lượng truy vấn) | Làm sao để hệ thống vừa bắt chính xác từ khóa kỹ thuật (FTS), vừa hiểu ngữ nghĩa (pgvector)? |
| **04** | `Quy trình Tư vấn Stateful Consultation` | `stateDiagram-v2` (Máy trạng thái) | `sequenceDiagram` (Vòng đời API) | Phiên tư vấn chuyển dịch qua các trạng thái nào? Xử lý thế nào khi khách hàng thiếu thông tin? |
| **05** | `Bộ Lõi Service Matching & Bằng Chứng` | `sequenceDiagram` (Đối sánh & Trích xuất) | `flowchart TD` (Cây quyết định lọc) | Căn cứ nào để AI gợi ý đúng dịch vụ? Bằng chứng (`evidence_chunk_ids`) được truy vết ra sao? |
| **06** | `Kiểm Toán An Toàn & 2 Tầng Guardrail` | `flowchart LR` (Pre-check & Post-check) | `flowchart TD` (Ma trận 2x2 Đánh đổi) | Làm thế nào để triệt tiêu 100% rủi ro bịa giá, bịa tiến độ và lộ dữ liệu bảo mật restricted? |
| **07** | `Pipeline Tự Động Sinh Proposal DOCX/PDF` | `flowchart LR` (JSON $\to$ DOCX $\to$ PDF) | `requirementDiagram` (SLA & Validation) | Từ dữ liệu có cấu trúc làm sao render thành văn bản công ty chuẩn chỉnh có chữ ký duyệt? |
| **08** | `Báo Cáo Đánh Giá Chất Lượng AI (Golden Set)` | `xychart-beta` (Diễn biến Precision/Recall) | `gantt` (Tiến độ hoàn thiện 7 ngày) | Độ chính xác, tỷ lệ trích dẫn bằng chứng và độ tin cậy AI đã đạt chuẩn nghiệm thu hay chưa? |

---

## 🎨 3 QUY TẮC STYLING CHO TÀI LIỆU MARKDOWN CHUYÊN NGHIỆP
1. **Chuẩn Dark Theme tương phản cao (Chống tàng hình chữ)**:
   - Sử dụng nền màu đậm (`#2e2204`, `#0f291e`, `#0f233a`) kết hợp viền rực rỡ và ép chữ trắng `color:#ffffff`.
2. **Quy tắc Safe Quoting**:
   - 100% nhãn có chứa dấu ngoặc đơn `()`, ngoặc vuông `[]`, dấu phẩy `,`, hai chấm `:` phải được bọc trong `["..."]`.
3. **Quy tắc Bố cục Ngang Ưu Tiên (Horizontal-First)**:
   - Luôn sử dụng `flowchart LR` cho các sơ đồ quy trình, pipeline để tận dụng toàn bộ chiều ngang trang đọc, tránh kéo dài dọc gây mỏi mắt.
