# HƯỚNG DẪN KIỂM TOÁN VÀ GIÁM SÁT AN TOÀN (compliance_telemetry_guide.md)

## 1. MỤC ĐÍCH VẬN HÀNH
Hệ thống SkyLink phục vụ tư vấn các gói dịch vụ viễn thám và dữ liệu công nghệ cao. Cơ chế Telemetry và Audit Trail bất biến bảo đảm:
1. **Truy cứu trách nhiệm cá nhân**: Xác định rõ Sales nào đã khởi tạo tư vấn, Reviewer nào đã bấm phê duyệt đề xuất.
2. **Truy vết chất lượng AI**: Đo lường độ trễ tìm kiếm (search latency), độ chính xác của các đoạn dẫn chứng (`evidence_chunk_ids`) theo thời gian thực.
3. **Cảnh báo sớm rủi ro (Early Risk Detection)**: Tự động gom nhóm các sự kiện `GUARDRAIL_VIOLATION` để phát hiện nếu mô hình AI bắt đầu có xu hướng suy diễn hoặc bị người dùng tấn công prompt injection.

---

## 2. NGUYÊN TẮC BẢO VỆ DỮ LIỆU KIỂM TOÁN
- **Bất biến (Append-only)**: Bảng `audit_logs` chỉ hỗ trợ thao tác `INSERT` và `SELECT`. Tuyệt đối không cấp quyền `UPDATE` hoặc `DELETE` cho bất kỳ API endpoint hay tài khoản ứng dụng nào.
- **Lưu trữ độc lập**: Trong môi trường production, nhật ký kiểm toán được đồng bộ định kỳ sang cold storage (S3/Cloud Storage) có cơ chế khóa WORM (Write Once, Read Many).
