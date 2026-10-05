# ĐẶC TẢ CHI TIẾT CẤU TRÚC CANONICAL 5 CẤP (canonical_spec_guide.md)

## 1. TẠI SAO PHẢI LÀ CANONICAL 5 CẤP?
Trong các hệ thống RAG thông thường, tài liệu thường được cắt vụn thành các đoạn văn bản (chunks) độc lập mà không lưu giữ ngữ cảnh phả hệ (lineage). Khi một chunk bị tách rời khỏi tên Dịch vụ hoặc Căn cứ Pháp lý gốc, LLM rất dễ suy diễn sai phạm vi áp dụng (ví dụ: áp dụng quy chuẩn bay của drone mini cho drone công nghiệp tải trọng 50kg).

Mô hình **Canonical 5 cấp** giải quyết triệt để vấn đề này:
1. **Level 1 - Service (Dịch vụ)**: Thực thể kinh doanh cao nhất có mã duy nhất (ví dụ: `S0112`).
2. **Level 2 - Asset (Tài sản dịch vụ)**: Các hồ sơ cấu thành gói dịch vụ (ví dụ: `CODE_01` Báo cáo kỹ thuật, `CODE_02` Hồ sơ thiết bị).
3. **Level 3 - Record (Bản ghi danh mục)**: Nhóm thông tin có cấu trúc phục vụ việc tra cứu theo chủ đề (`problem`, `capability`, `service_level`, `condition`...).
4. **Level 4 - Chunk (Đoạn ngữ nghĩa)**: Đơn vị tri thức nhỏ nhất được băm định danh SHA-256 tất định và nạp vào vector database.
5. **Level 5 - Source (Căn cứ pháp lý)**: Mã nguồn tài liệu thực tế do Ban Thẩm định GASCOLAE hoặc Cơ quan Nhà nước ban hành.

---

## 2. QUY TẮC BẢO TOÀN TRUY VẾT (TRACEABILITY MANDATE)
- Bất kỳ chunk nào được sinh ra bắt buộc phải mang theo mảng `evidence_source_ids`.
- Trong cơ sở dữ liệu quan hệ PostgreSQL, bảng `service_chunks` liên kết khóa ngoại nhiều-nhiều với bảng `service_sources` qua bảng trung gian `chunk_sources`.
- Khi xóa hoặc cập nhật một Service, toàn bộ chỉ mục vector của các chunk con được tự động đồng bộ lại (Cascade/Re-index) dựa trên mối quan hệ 5 cấp này.
