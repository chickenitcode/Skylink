# TIÊU CHUẨN ĐO LƯỜNG 5 CHỈ SỐ AI CHO SKYLINK (evaluation_metrics_standard.md)

## 1. MỤC TIÊU ĐỊNH LƯỢNG
Để bảo đảm tính khách quan, chất lượng của hệ thống Trợ lý Tư vấn SkyLink được đo lường qua 5 chỉ số định lượng chặt chẽ:

### 1.1. Retrieval Precision@K ($K=5$):
- **Định nghĩa**: Tỷ lệ phần trăm các đoạn văn bản (chunks) được truy xuất thực sự liên quan đến câu hỏi khảo sát.
- **Công thức**:
  $$\text{Precision@5} = \frac{|\text{Retrieved Chunks} \cap \text{Relevant Chunks}|}{5}$$
- **Mục tiêu nghiệm thu**: $\ge 80\%$.

### 1.2. Retrieval Recall:
- **Định nghĩa**: Tỷ lệ phần trăm các thông tin cốt lõi cần thiết của Dịch vụ được tìm thấy đầy đủ trong Top K kết quả.
- **Công thức**:
  $$\text{Recall} = \frac{|\text{Retrieved Chunks} \cap \text{Core Relevant Chunks}|}{|\text{Total Core Relevant Chunks}|}$$
- **Mục tiêu nghiệm thu**: $\ge 85\%$.

### 1.3. Grounded Response Rate:
- **Định nghĩa**: Tỷ lệ phần trăm các câu trả lời tư vấn có ít nhất một căn cứ dẫn chứng (`evidence_chunk_ids`) đã được kiểm chứng và tồn tại trong DB.
- **Mục tiêu nghiệm thu**: $\ge 95\%$.

### 1.4. Hallucination Rate:
- **Định nghĩa**: Tỷ lệ phần trăm câu trả lời chứa thông tin bịa đặt về Giá, Tiến độ, Năng lực thiết bị hoặc Căn cứ trích dẫn không có thật.
- **Mục tiêu nghiệm thu**: $\le 2\%$ (Tiêu chuẩn khắt khe cho lĩnh vực doanh nghiệp).

### 1.5. Proposal Validation Pass Rate:
- **Định nghĩa**: Tỷ lệ phần trăm tài liệu Proposal JSON vượt qua 100% các bài kiểm tra Zod Schema và Guardrail ngay trong lần sinh đầu tiên.
- **Mục tiêu nghiệm thu**: $\ge 90\%$.
