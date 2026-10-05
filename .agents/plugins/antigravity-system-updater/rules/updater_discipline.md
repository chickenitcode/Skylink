# BỘ QUY TẮC ĐIỀU HÀNH BẢO TRÌ & NÂNG CẤP HỆ THỐNG AGENT (UPDATER DISCIPLINE)

Bộ quy tắc này tự động kích hoạt khi phân hệ plugin `antigravity-system-updater` hoạt động nhằm bảo vệ an toàn tuyệt đối cho toàn bộ cấu hình hệ thống Agent và kho tri thức Data Science.

---

## 1. NGUYÊN TẮC BẢO TOÀN TRI THỨC TUYỆT ĐỐI (ZERO CONTENT LOSS)
- **Bất biến kho tri thức tham chiếu**: Tuyệt đối không xóa, không ghi đè rút gọn hoặc làm mất bất kỳ dòng nội dung nào trong kho tri thức tham chiếu gốc của Google Antigravity tại `references/` cũng như các tài liệu tri thức chuyên sâu của dự án.
- **Bất biến các bộ quy tắc điều hành**: Không tự ý sửa đổi tinh thần cốt lõi của các bộ quy tắc điều hành Agent tại `rules/` hoặc workspace rules (`AGENTS.md`, `GEMINI.md`).

---

## 2. KỶ LUẬT KIỂM TOÁN TRƯỚC - SỬA ĐỔI SAU (AUDIT-FIRST)
- Trước khi thực hiện bất kỳ nâng cấp nào đối với `rules/`, `skills/`, `plugins/`, `hooks/`:
  1. **Quét và lập bảng đối chiếu Diff chi tiết**: So sánh hiện trạng của workspace với tài liệu mới nhất từ Google Antigravity.
  2. **Giải thích bản chất kỹ thuật "TẠI SAO"**: Nêu rõ lý do khoa học, lợi ích và rủi ro tiềm ẩn của thay đổi.
  3. **Xin ý kiến Người Dùng**: Dừng lại và chờ Người Dùng xác nhận trước khi can thiệp vào bất kỳ tệp cấu hình cốt lõi nào.

---

## 3. KỶ LUẬT KHẢ CHUYỂN & CHUẨN HÓA ĐƯỜNG DẪN (PORTABILITY)
- Mọi liên kết tham chiếu giữa các thành phần của Agent phải ưu tiên sử dụng đường dẫn tương đối (relative paths) hoặc chuẩn định danh workspace-relative theo tài liệu chính thức của Antigravity.
- Tuyệt đối không gán cứng đường dẫn tuyệt đối cục bộ của máy cá nhân vào trong các tệp logic hoặc hướng dẫn tái sử dụng.

---

## 4. BẮT BUỘC CHẠY SCRIPT KIỂM ĐỊNH TOÀN DIỆN (AUTOMATED VERIFICATION)
- Sau mỗi lần cập nhật, bảo trì hoặc tái cấu trúc, bắt buộc phải chạy script kiểm toán:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .agents/scripts/verify_refactoring.ps1
  ```
- Đảm bảo 100% các tiêu chí kiểm tra đều đạt trạng thái PASSED trước khi bàn giao cho Người Dùng.
