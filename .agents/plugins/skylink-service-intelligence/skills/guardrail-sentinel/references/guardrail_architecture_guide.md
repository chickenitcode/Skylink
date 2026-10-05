# ĐẶC TẢ KIẾN TRÚC BẢO VỆ 2 TẦNG GUARDRAIL SENTINEL (guardrail_architecture_guide.md)

## 1. NGUYÊN LÝ HOẠT ĐỘNG
Hệ thống Guardrail trong SkyLink được phân tách thành 2 tầng kiểm soát độc lập nhằm bảo đảm tốc độ và độ tin cậy:

### 1.1. Tầng 1: Pre-check Policy Filter (Kiểm soát đầu vào)
- **Mục tiêu**: Chặn rò rỉ dữ liệu nhạy cảm trước khi nạp vào bộ nhớ tạm của mô hình ngôn ngữ lớn (Context Window).
- **Cơ chế**: Lọc lập trình tất định (Deterministic Code Filter) loại bỏ các chunk có nhãn `visibility = "restricted"` (đối với Sales) hoặc `status != "verified"`.
- **Lợi ích**: Tiết kiệm chi phí token và ngăn chặn 100% việc LLM vô tình đọc được bí mật kinh doanh hoặc chi phí gốc của nhà cung cấp.

### 1.2. Tầng 2: Post-check Grounding & Citation Auditor (Kiểm toán đầu ra)
- **Mục tiêu**: Phát hiện và chặn đứng ảo giác trong câu trả lời do LLM sinh ra.
- **Cơ chế**:
  1. Kiểm tra tính hợp lệ của cấu trúc JSON bằng Zod Schema.
  2. Truy vết mảng `evidence_chunk_ids`: Toàn bộ chunk được trích dẫn phải thực sự tồn tại trong danh sách chunk đã nạp ở tầng 1.
  3. Quét phát hiện các con số báo giá và cam kết tuyệt đối: Nếu có con số mà không được bảo chứng bởi chunk nguồn, hệ thống tự động cách ly vào mục `items_to_confirm`.

---

## 2. QUY TRÌNH XỬ LÝ VI PHẠM (FAIL-SAFE DEGRADATION)
Khi phát hiện vi phạm:
1. Ghi nhận nhật ký kiểm toán với mã `GUARDRAIL_VIOLATION`.
2. Không trả về thông báo lỗi gây bối rối cho Sales.
3. Thay thế bằng phản hồi an toàn: *"Yêu cầu kỹ thuật của Quý khách cần được đội ngũ kỹ sư GASCOLAE khảo sát thực địa để đưa ra phương án chính xác nhất."*
