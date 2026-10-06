# QUY TẮC KỶ LUẬT REVIEW MÃ NGUỒN, FLOW & ĐO LATENCY (CODE GENERATION AUDIT DISCIPLINE)

> **Mã quy tắc**: `RULE-CODE-GEN-AUDIT`  
> **Phạm vi áp dụng**: Mọi tác vụ Agent tạo mới hoặc chỉnh sửa mã nguồn (scripts, services, algorithms, models, utils) trong dự án CT Group Intern Project (GASCOLAE SkyLink).  
> **Căn cứ yêu cầu**: Xóa bỏ hoàn toàn "hộp đen" khi sinh code. Mỗi khi tạo code xong, Agent bắt buộc phải lập báo cáo Markdown chi tiết vào thư mục `scratch/` để Người Dùng kiểm soát logic, hiểu rõ flow và nắm được tốc độ thực thi (latency).

---

## 1. NGUYÊN TẮC BẮT BUỘC (MANDATORY REQUIREMENT)

Mỗi khi Agent hoàn thành việc **tạo mới hoặc chỉnh sửa mã nguồn** trong không gian làm việc:
1. **BẮT BUỘC**: Agent phải tự động lập một tệp báo cáo kỹ thuật Markdown tại:  
   `scratch/code_review_report.md` (hoặc ghi nhận thành phân mục chuyên sâu trong `scratch/agent_observations.md`) dựa theo mẫu chuẩn [scratch/code_review_report.template.md](../../scratch/code_review_report.template.md).
2. **CẤM TỰ Ý KẾT THÚC LƯỢT MÀ KHÔNG CÓ BÁO CÁO**: Không được phép chỉ thông báo "tôi đã viết code xong" mà không cung cấp bản phân tích Review, sơ đồ Flow và đánh giá Latency bên trong `scratch/`.

---

## 2. NỘI DUNG 3 PHẦN BẮT BUỘC CỦA BÁO CÁO TRONG `scratch/`

Mỗi báo cáo Markdown sinh ra trong `scratch/` phải có đầy đủ 3 cấu phần kỹ thuật:

### 2.1. Phần 1: Bảng Đánh Giá Review Mã Nguồn (Code Review Report Card - 5 Tiêu Chí)
- **1. Logic & Độ Đúng Đắn (Correctness Audit)**: Kiểm tra null check, undefined, bắt lỗi file I/O, kiểm định kiểu dữ liệu với Zod Schema.
- **2. Bảo Mật & Kỷ Luật Guardrail (Security & Guardrail Check)**: Đảm bảo không leak dữ liệu `restricted` (bảng giá Tệp 7), không expose raw vector score ra client, kiểm tra RBAC permissions.
- **3. Hiệu Năng & Big-O (Complexity & Resource Allocation)**: Phân tích độ phức tạp thời gian $O(N)$ và không gian bộ nhớ RAM (tránh N+1 query, rò rỉ buffer).
- **4. Bản Diff Đề Xuất Trực Quan (Before / After Comparison)**: Đối chiếu từng dòng mã thay đổi và giải thích lý do tối ưu.
- **5. Phán Quyết Review (Review Verdict)**: `APPROVED` (Đạt chuẩn) | `NEEDS_REVISION` (Cần chỉnh sửa) | `BLOCKED` (Chặn lỗi nghiêm trọng).

### 2.2. Phần 2: Sơ Đồ Luồng Xử Lý (Workflow Flow Diagram - Mermaid)
- Trực quan hóa cấu trúc dữ liệu và chuỗi gọi hàm của đoạn code vừa viết bằng sơ đồ Mermaid (`flowchart` hoặc `sequenceDiagram`).
- *Lưu ý*: Khối mã Mermaid được phép và khuyến khích vẽ đầy đủ bên trong tệp `.md` tại `scratch/` (tuân thủ `RULE-MERMAID-OUTPUT`, không xuất trực tiếp ra khung chat).

### 2.3. Phần 3: Đo Đạc & Đánh Giá Tốc Độ / Latency Thực Tế (Latency Profiling & SLA)
- Báo cáo số liệu đo đạc định lượng (bằng bộ định thời vi mô `performance.now()` hoặc `Stopwatch`):
  - Thời gian thực thi chi tiết của từng mắt xích (Hop-by-hop breakdown).
  - So sánh thời gian thực tế với **SLA trần** của hệ thống (Ví dụ: Parse < 80ms, Hybrid Search < 150ms).
  - Đưa ra kết luận hiệu năng: `PASS` 🟢 hoặc `BOTTLENECK` 🔴 kèm phương án tối ưu nếu vượt ngưỡng.

---

## 3. CHECKLIST ĐỐI SOÁT TỰ ĐỘNG
- [ ] Tệp mã nguồn đã được tạo/sửa đổi tại đúng vị trí quy định.
- [ ] Đã tạo/cập nhật tệp báo cáo Markdown tương ứng tại `scratch/code_review_report.md` (hoặc `scratch/agent_observations.md`).
- [ ] Báo cáo có đủ 3 phần: Review Report Card 5 mục, Sơ đồ Mermaid Flow và Phân tích Latency (ms).
- [ ] Đã trỏ link file markdown trong `scratch/` về khung chat để Người Dùng mở xem và kiểm soát.
