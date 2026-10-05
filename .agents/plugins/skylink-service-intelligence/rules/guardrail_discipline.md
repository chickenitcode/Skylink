# KỶ LUẬT GUARDRAIL & CHỐNG ẢO GIÁC (guardrail_discipline.md)

## 1. NGUYÊN TẮC CỐT TỬ (THE TWO GOLDEN RULES)
1. **KHÔNG BẰNG CHỨNG - KHÔNG PHÁT NGÔN (Zero Evidence, Zero Claim)**:
   - Mô hình LLM tuyệt đối không được đưa ra bất kỳ tuyên bố kỹ thuật, cam kết năng lực, thời gian triển khai hoặc điều kiện bay nào nếu không thể truy ngược về ít nhất một mã đoạn dẫn chứng (`evidence_chunk_ids`) đã được xác minh (`status: "verified"`).
2. **CHÂN LÝ THUỘC VỀ DỮ LIỆU CANONICAL (Canonical Truth)**:
   - Cơ sở dữ liệu quan hệ PostgreSQL lưu trữ Service Assets dạng chuẩn hóa Canonical 5 cấp (`Service` $\to$ `Asset` $\to$ `Record` $\to$ `Chunk` $\to$ `Source`) là nguồn chân lý duy nhất. Chỉ mục vector (`pgvector`) chỉ là một công cụ dẫn xuất dùng để tìm kiếm ngữ nghĩa, không bao giờ được coi là nguồn chân lý thay thế.

---

## 2. KỸ THUẬT TIỀN KIỂM (PRE-CHECK GUARDRAILS)
Trước khi tổng hợp prompt nạp vào LLM, hệ thống phải thực hiện 3 phép lọc cứng bằng mã lập trình (Deterministic Filtering):
1. **Lọc phạm vi hiển thị (Visibility Filter)**:
   - Nếu vai trò của người gọi là `SALES`: Lọc bỏ 100% các chunk có `visibility == "restricted"`.
   - Chỉ giữ lại các chunk có `visibility IN ("public", "internal")`.
2. **Lọc trạng thái dữ liệu (Status Filter)**:
   - Chỉ giữ lại các chunk có `status == "verified"`.
   - Bỏ qua các chunk có `status IN ("draft", "under_review", "deprecated")`.
3. **Giới hạn số lượng ngữ cảnh (Context Budget)**:
   - Giới hạn tối đa Top 5 - Top 7 chunk có điểm xếp hạng RRF cao nhất để tránh hiện tượng tràn ngữ cảnh (lost in the middle) và giảm thiểu chi phí token.

---

## 3. KỸ THUẬT HẬU KIỂM (POST-CHECK GUARDRAILS)
Sau khi LLM phản hồi, hệ thống không được trả kết quả ngay về cho Mobile, mà phải chạy qua đường ống kiểm toán hậu kiểm:
1. **Zod Schema Validation**:
   - Ép buộc toàn bộ output của LLM phải tuân thủ nghiêm ngặt định dạng JSON đã định nghĩa. Nếu JSON bị lỗi cú pháp hoặc thiếu trường bắt buộc, tự động kích hoạt retry hoặc fallback an toàn.
2. **Kiểm toán dẫn chứng (Citation Auditor)**:
   - Quét toàn bộ mảng `evidence_chunk_ids` trong câu trả lời của LLM.
   - Truy vấn đối chiếu ngược với DB PostgreSQL: Nếu phát hiện bất kỳ `chunk_id` nào được LLM "bịa ra" mà không có thực trong DB, hệ thống lập tức từ chối và ghi log sự kiện `GUARDRAIL_VIOLATION`.
3. **Phát hiện suy diễn về Giá & Tiến độ**:
   - Quét văn bản đầu ra bằng Regex và từ khóa nhạy cảm về giá (ví dụ: `VNĐ`, `USD`, `giá chỉ`, `chi phí`) hoặc cam kết tuyệt đối (ví dụ: `chính xác 100%`, `cam kết hoàn tiền`).
   - Nếu nội dung này không nằm trong nội dung trích dẫn của các Evidence Chunks, tự động gắn cờ cảnh báo hoặc chuyển vào danh mục `items_to_confirm`.
