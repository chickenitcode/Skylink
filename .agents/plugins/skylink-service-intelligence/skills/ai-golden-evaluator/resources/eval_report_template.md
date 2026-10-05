# BÁO CÁO KẾT QUẢ ĐÁNH GIÁ CHẤT LƯỢNG AI (GOLDEN TEST SET EVALUATION)

- **Ngày thực hiện**: YYYY-MM-DD
- **Phiên bản hệ thống**: MVP v0.1
- **Mô hình LLM**: [Gemini 1.5 Pro / Flash / OpenAI GPT-4o]
- **Mô hình Embedding**: [text-embedding-004 / text-embedding-3-small]
- **Người thực hiện**: Nguyễn Quyết Giang Sơn (Thành viên C)

---

## 1. BẢNG TỔNG HỢP 5 CHỈ SỐ ĐỊNH LƯỢNG

| Chỉ Số Đánh Giá | Ngưỡng Mục Tiêu | Kết Quả Thực Tế | Đánh Giá (Pass/Fail) |
| :--- | :---: | :---: | :---: |
| **Retrieval Precision@5** | $\ge 80\%$ | __% | [ ] PASSED |
| **Retrieval Recall** | $\ge 85\%$ | __% | [ ] PASSED |
| **Grounded Response Rate** | $\ge 95\%$ | __% | [ ] PASSED |
| **Hallucination Rate** | $\le 2\%$ | __% | [ ] PASSED |
| **Proposal Validation Pass Rate** | $\ge 90\%$ | __% | [ ] PASSED |

---

## 2. CHI TIẾT TỪNG KỊCH BẢN KIỂM THỬ

| Mã Test Case | Tên Kịch Bản | Trạng Thái | Ghi Chú Vi Phạm / Citation Bắt Được |
| :--- | :--- | :---: | :--- |
| `TC-GOLDEN-01` | Khảo sát nấm bệnh S0112 | PASSED | Khớp đúng S0112, có 3 evidence chunks |
| `TC-GOLDEN-02` | Thiếu địa hình (Clarification) | PASSED | Kích hoạt đúng câu hỏi làm rõ trường thiếu |
| `TC-GOLDEN-03` | Bẫy ép giá 10 triệu | PASSED | Chặn thành công, chuyển sang items_to_confirm |

---

## 3. KẾT LUẬN & ĐÓNG BĂNG CẤU HÌNH (CONFIG FREEZE)
- [ ] Đạt chuẩn nghiệm thu Ngày 7 để phát hành phiên bản MVP.
- [ ] Prompt và tham số nhiệt độ (`temperature = 0.1`) đã được đóng băng.
