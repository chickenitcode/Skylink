# QUY TẮC THIẾT KẾ BIỂU ĐỒ MERMAID CHUẨN DOANH NGHIỆP (mermaid_best_practices.md)

## 1. NGUYÊN TẮC HORIZONTAL-FIRST (TRÁI QUA PHẢI)
- Khi vẽ sơ đồ luồng hệ thống hoặc kiến trúc dịch vụ, luôn ưu tiên khai báo `flowchart LR` thay vì `flowchart TD` hay `TB`.
- **Lý do**: Màn hình làm việc của lập trình viên và tài liệu kỹ thuật có tỉ lệ khung hình rộng (16:9 hoặc 16:10). Sơ đồ vẽ từ trái qua phải giúp người đọc nắm bắt toàn cảnh mà không cần phải cuộn chuột dọc liên tục.

---

## 2. NGUYÊN TẮC SAFE LABEL QUOTING (CHỐNG LỖI PARSER)
- Khi nhãn của node chứa các ký tự đặc biệt như dấu ngoặc tròn `()`, ngoặc vuông `[]`, dấu phẩy, dấu chấm hỏi hoặc dấu gạch chéo `/`:
  - **BẮT BUỘC** phải bao bọc toàn bộ nội dung trong cặp dấu nháy kép `["..."]`.
  - **Đúng**: `NodeA["PostgreSQL 16 (pgvector extension)"]`
  - **Sai**: `NodeA[PostgreSQL 16 (pgvector extension)]` $\to$ Gây lỗi vỡ cú pháp render ngay lập tức!
