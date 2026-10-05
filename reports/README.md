# 📊 PROJECT REPORTS & AUDIT TELEMETRY (`reports/`)

Thư mục này dành riêng cho việc lưu trữ các báo cáo chính thức, hồ sơ bàn giao và kết quả kiểm thử trong suốt quá trình triển khai dự án GASCOLAE SkyLink theo lộ trình 7 ngày MVP:

---

## 🗂️ 1. CẤU TRÚC BÁO CÁO PHÂN CHIA THEO NGÀY (DAILY MILESTONE FOLDERS)

Để bảo đảm tính khoa học, dễ quản lý và tiện theo dõi tiến độ, toàn bộ báo cáo được phân bổ vào các thư mục theo từng ngày triển khai:

```text
reports/
├── README.md                              # Danh mục tổng hợp toàn bộ báo cáo dự án
├── day-01/                                # Ngày 1: Nền tảng, Khảo sát & Chuẩn hóa Canonical Ingestion
│   ├── Bao_Cao_Nghien_Cuu_Data_Ingestion_S0104.md
│   ├── Bao_Cao_Thiet_Ke_Kien_Truc_Luu_Tru_Lakehouse.md
│   └── view_diagram_interactive.html
├── day-02/                                # Ngày 2: Tra cứu Tri thức, Hybrid Search & UI Catalog
├── day-03/                                # Ngày 3: Máy trạng thái Tư vấn & Missing-Info Loop
├── day-04/                                # Ngày 4: Service Matching & Kiểm thử 2 Tầng Guardrail
├── day-05/                                # Ngày 5: Proposal Structured JSON & Preview Draft
├── day-06/                                # Ngày 6: Pipeline Render DOCX/PDF & Review Queue
└── day-07/                                # Ngày 7: Golden Test Set, E2E Integration & Demo 10 Phút
```

---

## 📑 2. DANH MỤC BÁO CÁO ĐÃ PHÁT HÀNH

| Ngày | Tệp Báo Cáo Chi Tiết | Trục Phụ Trách | Trọng Tâm Nghiên Cứu & Bàn Giao |
| :---: | :--- | :---: | :--- |
| **01** | [Bao_Cao_Nghien_Cuu_Data_Ingestion_S0104.md](./day-01/Bao_Cao_Nghien_Cuu_Data_Ingestion_S0104.md) | **Thành viên C**<br/>(Nguyễn Quyết Giang Sơn) | • Khảo sát 11 tệp tài sản số của Dịch vụ S0104.<br/>• Đánh giá mức độ tương thích Canonical 5 cấp.<br/>• Quyết định phạm vi dữ liệu: Chọn lọc 3 tệp cốt lõi Pha 1.<br/>• Đặc tả thuật toán băm `chunk_id` tất định. |
| **01** | [Bao_Cao_Thiet_Ke_Kien_Truc_Luu_Tru_Lakehouse.md](./day-01/Bao_Cao_Thiet_Ke_Kien_Truc_Luu_Tru_Lakehouse.md) | **Thành viên C**<br/>(Nguyễn Quyết Giang Sơn) | • So sánh Data Warehouse vs Data Lake vs Lakehouse.<br/>• Thiết kế Kiến trúc Medallion 3 tầng (Bronze ➔ Silver ➔ Gold).<br/>• Phân tích chuẩn hóa định dạng trích xuất JSON cho Monorepo.<br/>• Quy hoạch cấu trúc thư mục lưu trữ `knowledge/`. |
| **02** | *(Dự kiến)* | Thành viên B + C + A | Báo cáo tích hợp Hybrid Retrieval và đo lường độ trễ FTS + pgvector. |
| **03** | *(Dự kiến)* | Thành viên B + C + A | Báo cáo kiểm thử Máy trạng thái tư vấn và Missing-Info Loop. |
| **04** | *(Dự kiến)* | Thành viên C + B | Báo cáo hiệu quả 2 Tầng Guardrails phòng chống ảo giác về giá & SLA. |
| **05** | *(Dự kiến)* | Thành viên C + B + A | Báo cáo kiểm định tính toàn vẹn của Proposal JSON Schema. |
| **06** | *(Dự kiến)* | Thành viên B + A | Biên bản nghiệm thu worker LibreOffice headless và render PDF. |
| **07** | *(Dự kiến)* | Cả 3 Thành viên | Báo cáo tổng kết Golden Test Set, Tỷ lệ ảo giác (Hallucination Rate) và Kịch bản Demo MVP v0.1. |

---
*Cập nhật lần cuối: 05/10/2026 — Nhóm Dự Án CT Group Intern (Thành viên C: Nguyễn Quyết Giang Sơn)*
