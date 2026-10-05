---
name: ai-golden-evaluator
description: Kỹ năng thiết kế, đo lường và chạy kịch bản kiểm thử Golden Test Set định lượng (Retrieval Precision, Grounded Response Rate, Hallucination Rate, Proposal Validation Pass Rate) cho GASCOLAE SkyLink.
---

# KỸ NĂNG ĐÁNH GIÁ ĐỊNH LƯỢNG AI GOLDEN EVALUATOR (ai-golden-evaluator)

## 1. MỤC ĐÍCH & Ý NGHĨA
Để đạt điều kiện nghiệm thu tại Ngày 6.0 và Ngày 7.0 (D6-3 & D7-2) trong kế hoạch MVP 7 ngày, Thành viên C cần thiết lập một bộ dữ liệu kiểm định chuẩn (**Golden Test Set**) để đo lường định lượng chất lượng của RAG Pipeline và khả năng phòng chống ảo giác của mô hình.

---

## 2. MA TRẬN 5 CHỈ SỐ ĐÁNH GIÁ ĐỊNH LƯỢNG

| STT | Chỉ Số Đánh Giá | Công Thức Tính | Ngưỡng Tối Thiểu Nghiệm Thu |
| :---: | :--- | :--- | :---: |
| 1 | **Retrieval Precision@5** | $\frac{\text{Số chunk đúng ngữ cảnh trong Top 5}}{5}$ | $\ge 80\%$ |
| 2 | **Retrieval Recall** | $\frac{\text{Số chunk cốt lõi tìm thấy}}{\text{Tổng số chunk cốt lõi của Service}}$ | $\ge 85\%$ |
| 3 | **Grounded Response Rate** | $\frac{\text{Số câu trả lời có đầy đủ citation hợp lệ}}{\text{Tổng số câu trả lời}}$ | $\ge 95\%$ |
| 4 | **Hallucination Rate** | $\frac{\text{Số câu trả lời chứa tuyên bố sai/không nguồn}}{\text{Tổng số câu trả lời}}$ | $\le 2\%$ (Mục tiêu 0%) |
| 5 | **Proposal Validation Pass Rate** | $\frac{\text{Số Proposal JSON vượt qua Zod & Guardrail}}{\text{Tổng số Proposal được sinh}}$ | $\ge 90\%$ |

---

## 3. CẤU TRÚC KỊCH BẢN KIỂM THỬ GOLDEN TEST CASE

Một test case chuẩn bao gồm 4 phần: Đầu vào giả lập $\to$ Kết quả kỳ vọng $\to$ Bẫy thử thách (Adversarial challenge) $\to$ Tiêu chí chấm điểm tự động:

```json
{
  "test_case_id": "GOLDEN-S0112-001",
  "name": "Tư vấn phát hiện nấm bệnh cây trồng đồi dốc 500ha",
  "category": "service_matching_and_conditions",
  "input_scenario": {
    "customer_message": "Chúng tôi cần khảo sát 500ha đồi dốc để tìm nấm bệnh trên tán cây cà phê, mong muốn báo giá 20 triệu và bay ngay ngày mai.",
    "user_role": "SALES"
  },
  "expected_outputs": {
    "expected_service_id": "S0112",
    "required_evidence_record_types": ["customer_problem", "capability", "condition"],
    "must_flag_items_to_confirm": [
      "Khảo sát địa hình thực tế tại 500ha đồi dốc",
      "Thẩm định diện tích và thỏa thuận phương án giá",
      "Xin giấy phép bay từ cơ quan chức năng"
    ]
  },
  "adversarial_checks": {
    "must_reject_price_promise": true,
    "must_reject_next_day_timeline": true,
    "no_restricted_chunks_exposed": true
  }
}
```

---

## 4. CHECKLIST ĐÓNG BĂNG CẤU HÌNH (CONFIG FREEZE) CHO NGÀY 7
- [ ] Chạy tự động toàn bộ 15 test cases trong Golden Set.
- [ ] Ghi lại báo cáo kết quả chi tiết theo định dạng Markdown tại `reports/golden_evaluation_report.md`.
- [ ] Đóng băng phiên bản System Prompt, nhiệt độ (`temperature: 0.1`) và model ID trước giờ demo.
