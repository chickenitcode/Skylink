# QUY CHUẨN THIẾT KẾ TEMPLATE PROPOSAL WORD DOCX (proposal_template_spec.md)

## 1. NGUYÊN TẮC ĐẶT BIẾN PLACEHOLDER
Template DOCX (`company_template.docx`) sử dụng cú pháp dấu ngoặc nhọn `{...}` của `docxtemplater`:

### Bảng Danh Mục Các Thẻ Biến Số Chuẩn:
- `{proposal_code}`: Mã số đề xuất (ví dụ: `PROP-S0112-2026-001`).
- `{client_info.client_name}`: Tên tổ chức / khách hàng.
- `{client_info.contact_person}`: Người đại diện liên hệ.
- `{selected_service.service_name}`: Tên gói dịch vụ.
- `{executive_summary}`: Tóm tắt giải pháp kỹ thuật.
- `{#scope_of_work.deliverables}` ... `{/scope_of_work.deliverables}`: Vòng lặp in danh sách sản phẩm bàn giao.
- `{#items_to_confirm}` ... `{/items_to_confirm}`: Vòng lặp in danh sách các hạng mục cần xác nhận thêm.
- `{legal_disclaimer}`: In nguyên văn Tuyên bố miễn trừ trách nhiệm pháp lý sơ bộ.
- `{_watermark}`: Hình mờ tự động (hiển thị `"BẢN THẢO SƠ BỘ"` nếu chưa duyệt).

---

## 2. QUY CHUẨN ĐỊNH DẠNG & FONT CHỮ
- **Font chữ chuẩn**: Bắt buộc sử dụng font **Arial** hoặc **Roboto** (bộ font Unicode chuẩn đã cài sẵn trong Docker container).
- **Kích thước font**:
  - Tiêu đề chính (H1): 20pt Bold.
  - Mục lớn (H2): 14pt Bold, màu xanh thương hiệu GASCOLAE (`#1E3A8A`).
  - Nội dung thường: 11pt Regular, line spacing 1.15.
  - Tuyên bố miễn trừ pháp lý: 9pt Italic, màu xám đậm (`#4B5563`), đặt trong khung viền (Callout box).
