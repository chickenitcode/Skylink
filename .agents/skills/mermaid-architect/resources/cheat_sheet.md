# 📑 SỔ TAY CÚ PHÁP TOÀN DIỆN 20+ LOẠI SƠ ĐỒ MERMAID CHO DỰ ÁN SKYLINK (GASCOLAE)

> **MỤC ĐÍCH CỦA TỆP NÀY**: 
> Đây là kho mẫu cú pháp **Copy-Paste Nhanh** chuẩn 100% dành cho AI Agent và các thành viên dự án **GASCOLAE SkyLink** (Mai Tấn Giáp, Lê Phúc Khang, Nguyễn Quyết Giang Sơn).
> Toàn bộ các ví dụ được ánh xạ thực tế theo bài toán: **Ứng dụng Mobile Tư vấn Dịch vụ Nội bộ, Backend NestJS, PostgreSQL/Prisma + pgvector, Hybrid Retrieval, Stateful Consultation, 2 Tầng Guardrail Chống Ảo Giác và Pipeline Sinh Proposal DOCX/PDF**.
> Mọi sơ đồ đều tuân thủ nguyên tắc: **Horizontal-First (`flowchart LR`)** và **Safe Label Quoting (`["..."]`)** để không bao giờ bị lỗi cú pháp (`Syntax error`).

---

## 📌 BẢNG MỤC LỤC NHANH 20 LOẠI SƠ ĐỒ THỰC CHIẾN SKYLINK

| STT | Tên Sơ Đồ | Từ Khóa Cú Pháp | Trường Hợp Ứng Dụng Trong Dự Án SkyLink |
| :---: | :--- | :--- | :--- |
| **01** | [Flowchart (Đường Ống Dữ Liệu & RAG)](#1-flowchart-duong-ong-nap-du-lieu-va-hybrid-retrieval) | `flowchart LR` | Pipeline nạp Service Assets, Schema-Aware Chunking, Hybrid Search |
| **02** | [GitGraph (Nhánh Phát Triển Sprint MVP)](#2-gitgraph-quy-trinh-re-nhanh-sprint-mvp-7-ngay) | `gitGraph` | Quản lý nhánh tính năng Monorepo (`api`, `mobile`, `shared`, `ai`) |
| **03** | [Quadrant Chart (Ma Trận Đánh Đổi Kiến Trúc)](#3-quadrant-chart-ma-tran-danh-doi-giai-phap-ky-thuat) | `quadrantChart` | Đánh đổi: Độ an toàn AI vs Tốc độ triển khai, Quick Wins vs Bẫy kỹ thuật |
| **04** | [XY Chart (Đánh Giá Chất Lượng AI)](#4-xy-chart-bieu-do-danh-gia-chat-luong-ai--rag-metrics) | `xychart-beta` | Diễn biến Precision, Recall, Grounded Rate qua các phiên bản Prompt |
| **05** | [Timeline (Tiến Trình 7 Ngày MVP)](#5-timeline-tien-trinh-7-ngay-phat-trien-mvp) | `timeline` | Các mốc Checkpoint từng ngày từ Nền tảng (N1) đến Phát hành (N7) |
| **06** | [Sequence (Vòng Đời Gọi API & Tư Vấn)](#6-sequence-diagram-vong-doi-api-tu-van--doi-sanh-dich-vu) | `sequenceDiagram` | Luồng tương tác: Mobile App $\leftrightarrow$ NestJS Gateway $\leftrightarrow$ AI $\leftrightarrow$ Guardrail |
| **07** | [Entity Relationship (Lược Đồ Cơ Sở Dữ Liệu)](#7-entity-relationship-diagram-co-so-du-lieu-canonical-skylink) | `erDiagram` | Quan hệ bảng: `services`, `service_chunks`, `sessions`, `proposals` |
| **08** | [State Diagram (Máy Trạng Thái Tư Vấn)](#8-state-diagram-vong-doi-phien-tu-van-stateful-consultation) | `stateDiagram-v2` | Trạng thái: `DISCOVERY` $\to$ `REQUIREMENTS` $\to$ `MATCHING` $\to$ `APPROVED` |
| **09** | [Mindmap (Danh Mục Dịch Vụ GASCOLAE)](#9-mindmap-cay-phan-ra-danh-muc-dich-vu-gascolae) | `mindmap` | Cấu trúc phân rã dịch vụ: Drone nông nghiệp, logistics, an ninh, đo đạc |
| **10** | [Pie Chart (Phân Bổ Record Tri Thức)](#10-pie-chart-ty-le-phan-bo-loai-record-tri-thuc) | `pie` | Tỷ trọng các loại record: Overview, Capability, Problem, SLA, Deliverable |
| **11** | [Gantt Chart (Tiến Độ 3 Thành Viên)](#11-gantt-chart-ke-hoach-phan-bo-cong-viec-3-thanh-vien) | `gantt` | Lộ trình song song của Thành viên A (Mobile), B (Backend), C (AI/Data) |
| **12** | [Class Diagram (Kiến Trúc Module NestJS)](#12-class-diagram-thiet-ke-module-backend-nestjs) | `classDiagram` | Cấu trúc OOP: Controllers, Services, Adapters, Guardrails |
| **13** | [User Journey (Hành Trình Nhân Viên Sales)](#13-user-journey-hanh-trinh-tu-van-cua-sales-tren-mobile) | `journey` | Trải nghiệm Sales: Đăng nhập $\to$ Thu thập nhu cầu $\to$ Lập Proposal |
| **14** | [Sankey (Dòng Chảy Lọc Context Guardrail)](#14-sankey-diagram-dong-chay-thanh-loc-ngu-canh-qua-guardrail) | `sankey-beta` | Lọc Context: 100 Chunks $\to$ Pre-check $\to$ LLM $\to$ Post-check $\to$ Proposal |
| **15** | [Kanban (Bảng Điều Phối Task MVP)](#15-kanban-bang-dieu-phoi-nhiem-vu-sprint-mvp) | `kanban` | Quản lý tiến độ đầu việc P0 (Backlog, In Progress, Review, Done) |
| **16** | [Requirement Diagram (Đặc Tả Phi Chức Năng)](#16-requirement-diagram-dac-ta-yeu-cau-phi-chuc-nang--bao-mat) | `requirementDiagram` | Ràng buộc: Latency < 3s, Zero Hallucination, RBAC Sales/Admin |
| **17** | [C4 Architecture (Kiến Trúc Container C4)](#17-c4-architecture-kien-truc-he-thong-skylink-c4-container) | `flowchart TB` | Phân tầng: Expo App, NestJS API, PostgreSQL pgvector, Gemini API |
| **18** | [Block Diagram (Khối Service Intelligence Core)](#18-block-diagram-kien-truc-khoi-service-intelligence-core) | `block-beta` | Layout module: Ingestion, Chunker, Hybrid Engine, Orchestrator |
| **19** | [Packet Diagram (Cấu Trúc JWT & Token Header)](#19-packet-diagram-layout-goi-tin-jwt-access-token) | `packet-beta` | Cấu trúc byte/trường của JWT Token Payload cho Auth & RBAC |
| **20** | [Architecture Cloud (Môi Trường Triển Khai Docker)](#20-architecture-cloud-ha-tang-trien-khai-docker--production) | `flowchart TD` | Kết nối: Mobile Expo $\to$ Nginx Proxy $\to$ Docker Containers $\to$ DB |

---

## 1. Flowchart (Đường Ống Nạp Dữ Liệu và Hybrid Retrieval)
> **Ứng dụng**: Luồng xử lý từ Service Assets thô $\to$ Chuẩn hóa Canonical $\to$ Semantic Chunker $\to$ Hybrid Retrieval.
```mermaid
flowchart LR
    subgraph Ingest["1. Nạp Service Assets"]
        direction TB
        RawAsset[("Tài liệu Service Asset thô<br/>(DOCX / JSON / Markdown)")]
        Canon["Chuẩn hóa sang Canonical Schema<br/>(Service/Asset/Record/Source)"]
    end

    subgraph Chunking["2. Schema-Aware Chunking"]
        direction TB
        Splitter["Phân đoạn ngữ nghĩa theo Record Type:<br/>• Overview, Customer Problem<br/>• Capability, Service Level, Deliverable"]
        Enrich["Gán Metadata & Hash Chunk ID:<br/>• chunk_id ổn định, status: verified<br/>• visibility: internal | restricted"]
    end

    subgraph Indexing["3. Lưu Trữ & Chỉ Mục"]
        direction TB
        PG[("PostgreSQL: Bảng service_chunks")]
        FTS["Full-Text Search Index (GIN tsvector)"]
        HNSW["Semantic Vector Index (pgvector HNSW)"]
    end

    subgraph QueryEngine["4. Hybrid Retrieval Engine"]
        direction TB
        SalesReq["Truy vấn nhu cầu từ Sales"]
        Fusion["Reciprocal Rank Fusion (RRF Ranker)"]
        Evidence["Top Chunks kèm evidence_chunk_ids"]
    end

    RawAsset --> Canon
    Canon --> Splitter
    Splitter --> Enrich
    Enrich --> PG
    PG --> FTS
    PG --> HNSW
    SalesReq --> FTS
    SalesReq --> HNSW
    FTS --> Fusion
    HNSW --> Fusion
    Fusion --> Evidence
```

---

## 2. GitGraph (Quy Trình Rẽ Nhánh Sprint MVP 7 Ngày)
> **Ứng dụng**: Theo dõi quy trình branching phát triển Monorepo của 3 thành viên theo từng ngày.
```mermaid
gitGraph
    commit id: "init-monorepo" tag: "Day 1.0"
    branch feat/api-foundation
    checkout feat/api-foundation
    commit id: "nestjs-prisma-pgvector"
    commit id: "auth-jwt-rbac"
    checkout main
    merge feat/api-foundation id: "merge-api-n1"
    
    branch feat/knowledge-pipeline
    checkout feat/knowledge-pipeline
    commit id: "canonical-chunker"
    commit id: "embedding-hybrid-search" tag: "Day 2.0"
    checkout main
    merge feat/knowledge-pipeline id: "merge-rag-n2"
    
    branch feat/consultation-workflow
    checkout feat/consultation-workflow
    commit id: "state-machine-engine"
    commit id: "missing-info-loop" tag: "Day 3.0"
    checkout main
    merge feat/consultation-workflow id: "merge-consult-n3"
    
    branch feat/guardrail-matching
    checkout feat/guardrail-matching
    commit id: "pre-post-guardrails"
    commit id: "evidence-service-matcher" tag: "Day 4.0"
    checkout main
    merge feat/guardrail-matching id: "merge-match-n4"
    
    branch feat/proposal-generator
    checkout feat/proposal-generator
    commit id: "proposal-json-schema"
    commit id: "docx-pdf-render" tag: "Day 5.0"
    checkout main
    merge feat/proposal-generator id: "merge-proposal-n5"
    
    commit id: "golden-set-eval-pass" tag: "Day 6.0"
    commit id: "tag-mvp-v0.1-release" tag: "MVP v0.1"
```

---

## 3. Quadrant Chart (Ma Trận Đánh Đổi Giải Pháp Kỹ Thuật)
> **Ứng dụng**: Đánh giá các quyết định kỹ thuật trong MVP SkyLink giữa Độ Phức Tạp Triển Khai vs Độ An Toàn & Tin Cậy Nghiệp Vụ.
```mermaid
quadrantChart
    title Đánh Đổi Kiến Trúc: Độ Phức Tạp Cài Đặt vs Độ Tin Cậy & An Toàn AI
    x-axis "Cài đặt Nhanh / Đơn giản" --> "Cài đặt Phức tạp / Tốn công"
    y-axis "Độ An toàn Thấp" --> "Độ An toàn Cực cao"
    quadrant-1 "Đầu tư Dài hạn (Strategic)"
    quadrant-2 "Quick Wins (Ưu tiên P0)"
    quadrant-3 "Kém Hiệu quả (Avoid)"
    quadrant-4 "Bẫy Kỹ thuật (Danger Zone)"
    "Zod Output Validation": [0.15, 0.88]
    "Pre-check Visibility Filter": [0.20, 0.92]
    "Post-check Citation Audit": [0.30, 0.85]
    "Hybrid Search (FTS + pgvector)": [0.70, 0.90]
    "Hardcoded If-Else Consultation": [0.10, 0.25]
    "Pure Vector Search không Filter": [0.85, 0.20]
```

> [!TIP]
> **Khuyến Nghị Thiết Kế Giao Diện Tối: Dùng Ma Trận 2x2 bằng `flowchart TD` (Chống Đè Chữ)**:
```mermaid
flowchart TD
    subgraph Matrix["MA TRẬN QUYẾT ĐỊNH KỸ THUẬT SKYLINK (2x2 MATRIX)"]
        direction TB
        subgraph TopRow["ĐỘ TIN CẬY & AN TOÀN CAO"]
            direction LR
            subgraph Q2["🌟 QUICK WINS (ƯU TIÊN LÀM NGAY)"]
                direction TB
                W1["<b>Zod Schema Parsing</b><br/>• Chặn sập cấu trúc JSON"]
                W2["<b>Pre-check Visibility Filter</b><br/>• Ngăn lộ dữ liệu restricted"]
            end
            subgraph Q1["💎 ĐẦU TƯ CỐT LÕI (STRATEGIC VALUE)"]
                direction TB
                S1["<b>Hybrid Retrieval (FTS + pgvector)</b><br/>• Độ phủ thuật ngữ kỹ thuật + ngữ nghĩa"]
                S2["<b>Stateful Consultation Machine</b><br/>• Backend độc quyền quản lý state"]
            end
        end
        subgraph BottomRow["ĐỘ TIN CẬY THẤP (RỦI RO CAO)"]
            direction LR
            subgraph Q3["⚠️ KÉM HIỆU QUẢ"]
                direction TB
                A1["<b>Rule-based Chat cứng nhắc</b><br/>• Trải nghiệm tư vấn kém, không linh hoạt"]
            end
            subgraph Q4["⛔ BẪY NGUY HIỂM (TRÁNH TUYỆT ĐỐI)"]
                direction TB
                D1["<b>Pure Semantic Vector Search</b><br/>• Bỏ sót mã dịch vụ S0112, thông số SLA"]
                D2["<b>Tự động gửi Proposal chưa Review</b><br/>• Nguy cơ pháp lý do ảo giác giá"]
            end
        end
    end
    classDef gold fill:#2e2204,stroke:#f59e0b,color:#ffffff;
    classDef high fill:#0f291e,stroke:#10b981,color:#ffffff;
    classDef low fill:#262626,stroke:#737373,color:#ffffff;
    classDef trap fill:#3b1212,stroke:#ef4444,color:#ffffff;
    class W1,W2,Q2 gold;
    class S1,S2,Q1 high;
    class A1,Q3 low;
    class D1,D2,Q4 trap;
```

---

## 4. XY Chart (Biểu Đồ Đánh Giá Chất Lượng AI / RAG Metrics)
> **Ứng dụng**: Trực quan hóa kết quả kiểm thử bộ Golden Evaluation Set qua 4 phiên bản prompt/retrieval.
```mermaid
xychart-beta
    title "Diễn Biến Chỉ Số Đánh Giá AI SkyLink Qua Các Phiên Bản Tinh Chỉnh"
    x-axis ["V1 Raw Prompt", "V2 Few-shot", "V3 Hybrid FTS", "V4 Guardrail Enforced"]
    y-axis "Tỷ lệ Đạt Chuẩn (%)" 0 --> 100
    bar [45, 68, 85, 96]
    line [45, 68, 85, 96]
```

---

## 5. Timeline (Tiến Trình 7 Ngày Phát Triển MVP)
> **Ứng dụng**: Lịch trình thực thi chi tiết 7 ngày theo tài liệu `GASCOLAE_Ke_Hoach_MVP_7_Ngay_VI.md`.
```mermaid
timeline
    title Kế Hoạch 7 Ngày Triển Khai MVP SkyLink
    section Giai Đoạn 1: Khởi Tạo
        Ngày 1 : Nghiên Cứu Stack & Khởi Tạo Workspace : NestJS API + Expo Mobile Shell + Canonical Prototype
        Ngày 2 : Tra Cứu Tri Thức End-to-End : Nạp Full Services + Batch Embedding pgvector + Hybrid Search API
    section Giai Đoạn 2: Nghiệp Vụ Cốt Lõi
        Ngày 3 : Phiên Tư Vấn Stateful Consultation : Chat Session + Trích xuất Requirements + Missing-info Loop
        Ngày 4 : Service Matching Có Bằng Chứng : Matching Engine + Pre-check / Post-check Guardrails
    section Giai Đoạn 3: Sinh Đề Xuất & Bàn Giao
        Ngày 5 : Sinh Proposal Bản Thảo : Proposal Readiness + Sinh Structured JSON + Validation
        Ngày 6 : Human Review & Xuất Tài Liệu : Quyền Duyệt PROPOSAL_APPROVE + Render DOCX / PDF
        Ngày 7 : Kiểm Thử Golden Set & Phát Hành : Chốt Golden Eval Set + Hardening Secret + Tag Release v0.1
```

---

## 6. Sequence Diagram (Vòng Đời API Tư Vấn & Đối Sánh Dịch Vụ)
> **Ứng dụng**: Tương tác tuần tự giữa Sales Mobile App, NestJS API Gateway, RAG Retrieval, LLM Engine và Guardrail.
```mermaid
sequenceDiagram
    autonumber
    actor Sales as "Sales / BD (Mobile App)"
    participant Gateway as "NestJS API Gateway"
    participant StateMgr as "Consultation State Manager"
    participant RAG as "Hybrid Retrieval (pgvector + FTS)"
    participant LLM as "LLM Provider (Gemini)"
    participant Guardrail as "Post-check Sentinel"

    Sales->>Gateway: POST /api/consultations/:id/messages (Yêu cầu tư vấn)
    Gateway->>StateMgr: Cập nhật tin nhắn & Lấy lịch sử hội thoại
    StateMgr->>LLM: Trích xuất structured requirements (Problem, Objective, Constraints)
    LLM-->>StateMgr: Trả về CustomerRequirements JSON
    
    alt Thiếu thông tin bắt buộc
        StateMgr-->>Gateway: Trạng thái COLLECTING_REQUIREMENTS + Câu hỏi clarification
        Gateway-->>Sales: Hiển thị câu hỏi bổ sung trên UI
    else Đã đủ thông tin yêu cầu
        StateMgr->>RAG: Truy vấn Hybrid Search theo Requirements
        RAG-->>StateMgr: Trả về Top Chunks kèm evidence_chunk_ids
        StateMgr->>LLM: Gợi ý Service + Sinh Rationale có căn cứ
        LLM-->>Guardrail: Phản hồi Structured Matching
        Guardrail->>Guardrail: Kiểm tra Citation Audit + Claim Detector
        Guardrail-->>StateMgr: Kết quả thẩm định hợp lệ
        StateMgr-->>Gateway: Trạng thái SERVICE_RECOMMENDED + Candidate Services
        Gateway-->>Sales: 200 OK: Hiển thị Thẻ Dịch Vụ Khuyến Nghị & Nguồn Bằng Chứng
    end
```

---

## 7. Entity Relationship Diagram (Cơ Sở Dữ Liệu Canonical SkyLink)
> **Ứng dụng**: Lược đồ quan hệ chuẩn hóa trong PostgreSQL/Prisma phục vụ cả nghiệp vụ lẫn RAG.
```mermaid
erDiagram
    USERS ||--o{ CONSULTATION_SESSIONS : "khởi tạo"
    USERS ||--o{ AUDIT_LOGS : "thực hiện"
    SERVICES ||--o{ SERVICE_CHUNKS : "phân rã thành"
    SOURCES ||--o{ SERVICE_CHUNKS : "kiểm chứng nguồn"
    CONSULTATION_SESSIONS ||--o{ MESSAGES : "chứa"
    CONSULTATION_SESSIONS ||--o| CUSTOMER_REQUIREMENTS : "trích xuất"
    CONSULTATION_SESSIONS ||--o{ PROPOSALS : "sinh ra"
    PROPOSALS ||--o{ PROPOSAL_EVIDENCE : "trích dẫn"
    SERVICE_CHUNKS ||--o{ PROPOSAL_EVIDENCE : "chứng minh"

    USERS {
        uuid id PK
        string email
        string full_name
        string role "Sales | Admin | Reviewer"
    }

    SERVICES {
        string service_id PK "Ví dụ: S0112"
        string service_name
        string status "verified | draft"
        int version
    }

    SERVICE_CHUNKS {
        string chunk_id PK "CHK_S0112_CAP_xxx"
        string service_id FK
        string record_type "overview | capability | problem | sla"
        text content
        string visibility "internal | restricted"
        string status "verified | draft"
        vector embedding "vector(768)"
    }

    SOURCES {
        string source_id PK "SRC-AGRI-01"
        string title
        string document_path
    }

    CONSULTATION_SESSIONS {
        uuid id PK
        uuid user_id FK
        string state "DISCOVERY | MATCHING | APPROVED"
        datetime created_at
    }

    PROPOSALS {
        uuid id PK
        uuid session_id FK
        string service_id FK
        jsonb proposal_json
        string status "draft | review_required | approved"
        string docx_url
        string pdf_url
    }
```

---

## 8. State Diagram (Vòng Đời Phiên Tư Vấn Stateful Consultation)
> **Ứng dụng**: Kiểm soát chặt chẽ máy trạng thái trên Backend; Mobile không thể tự đổi state.
```mermaid
stateDiagram-v2
    [*] --> DISCOVERY: Sales bấm "Bắt đầu phiên tư vấn mới"
    DISCOVERY --> COLLECTING_REQUIREMENTS: Gửi tin nhắn đầu tiên
    
    state COLLECTING_REQUIREMENTS {
        [*] --> CheckFields
        CheckFields --> MissingFields: Thiếu mục tiêu / điều kiện
        MissingFields --> AskClarification: Sinh câu hỏi làm rõ
        AskClarification --> CheckFields: Khách hàng bổ sung thông tin
        CheckFields --> RequirementsComplete: Đủ thông tin bắt buộc
    }

    COLLECTING_REQUIREMENTS --> SERVICE_MATCHING: Deterministic Validator Pass
    SERVICE_MATCHING --> SERVICE_RECOMMENDED: Hybrid Search + Guardrail Pass
    SERVICE_MATCHING --> NO_MATCH: Không có dịch vụ phù hợp
    NO_MATCH --> COLLECTING_REQUIREMENTS: Điều chỉnh tiêu chí

    SERVICE_RECOMMENDED --> PROPOSAL_READY: Sales chọn 1 Candidate Service
    PROPOSAL_READY --> PROPOSAL_GENERATED: Sinh Proposal JSON thành công
    
    PROPOSAL_GENERATED --> REVIEW_REQUIRED: Zod & Citation Audit Pass
    PROPOSAL_GENERATED --> REJECTED_VALIDATION: Phát hiện ảo giác giá/tiến độ
    REJECTED_VALIDATION --> PROPOSAL_READY: Tự động retry hoặc sửa tiêu chí

    REVIEW_REQUIRED --> APPROVED: Reviewer mang quyền PROPOSAL_APPROVE duyệt
    REVIEW_REQUIRED --> REVISION_REQUESTED: Reviewer yêu cầu chỉnh sửa
    REVISION_REQUESTED --> PROPOSAL_GENERATED: Sales cập nhật bản thảo

    APPROVED --> DOCUMENT_RENDERED: Xuất file DOCX / PDF
    DOCUMENT_RENDERED --> [*]: Bàn giao Sales gửi khách hàng
```

---

## 9. Mindmap (Cây Phân Rã Danh Mục Dịch Vụ GASCOLAE)
> **Ứng dụng**: Sơ đồ cấu trúc tri thức các dòng dịch vụ không phận & giải pháp Drone của GASCOLAE.
```mermaid
mindmap
  root((Danh Mục Dịch Vụ GASCOLAE))
    (Nông Nghiệp Công Nghệ Cao)
      [S0112: Giám sát sức khỏe cây trồng đa phổ NDVI]
      [S0118: Phun thuốc & phân bón chính xác bằng Drone tải trọng lớn]
      [S0120: Bản đồ độ ẩm & trắc địa nông trường diện tích lớn]
    (Logistics & Giao Nhận Không Phận)
      [S0113: Vận chuyển mẫu y tế & hàng khẩn cấp liên đảo]
      [S0122: Hành lang giao nhận chặng cuối đô thị thông minh]
      [S0125: Quản lý trạm sạc & bãi đáp Drone tự động]
    (Khảo Sát & Hạ Tầng Công Nghiệp)
      [S0114: Kiểm tra ăn mòn & nứt gãy đường ống năng lượng]
      [S0115: Quét 3D LiDAR công trình xây dựng & đo thể tích đất]
      [S0119: Giám sát an toàn điện lưới cao thế không gián đoạn]
    (An Ninh & Cứu Hộ Cứu Nạn)
      [S0116: Tuần tra biên giới & phát hiện xâm nhập ban đêm bằng cảm biến nhiệt]
      [S0128: Tìm kiếm cứu nạn bão lũ & thả phao cứu sinh tự động]
```

---

## 10. Pie Chart (Tỷ Lệ Phân Bổ Loại Record Tri Thức)
> **Ứng dụng**: Phân tích tỷ trọng các đơn vị tri thức trong Knowledge Base đã chuẩn hóa.
```mermaid
pie title Phân Bổ Đơn Vị Tri Thức (Semantic Chunks) Trong SkyLink
    "Năng Lực Kỹ Thuật (Capabilities)" : 32.5
    "Vấn Đề Khách Hàng (Customer Problems)" : 24.0
    "Tình Huống Sử Dụng (Use Cases)" : 18.5
    "Cấp Độ Dịch Vụ & SLA (Service Levels)" : 10.0
    "Sản Phẩm Bàn Giao (Deliverables)" : 8.5
    "Điều Kiện Triển Khai (Conditions)" : 6.5
```

---

## 11. Gantt Chart (Kế Hoạch Phân Bổ Công Việc 3 Thành Viên)
> **Ứng dụng**: Quản lý tiến độ song song của 3 thành viên trong 7 ngày Sprint MVP.
```mermaid
gantt
    title Phân Bổ Công Việc 7 Ngày Sprint MVP SkyLink
    dateFormat  YYYY-MM-DD
    section Thành viên A (Mobile & Tích Hợp)
        Khởi tạo Expo App & Navigation Shell       :done,    a1, 2026-10-06, 2026-10-06
        Màn hình Đăng nhập & Lưu trữ Token         :done,    a2, 2026-10-07, 2026-10-07
        Màn hình Tra cứu & Chi tiết Service        :active,  a3, 2026-10-07, 2026-10-08
        Giao diện Chat Tư vấn & Missing Info       :         a4, 2026-10-08, 2026-10-09
        Thẻ Khuyến Nghị & Xem Nguồn Evidence       :         a5, 2026-10-09, 2026-10-10
        Màn hình Preview Proposal & Tải DOCX/PDF   :         a6, 2026-10-10, 2026-10-11
        Tích hợp E2E & Chuẩn bị Demo               :         a7, 2026-10-12, 2026-10-12
    section Thành viên B (Backend & DB & Workflow)
        Setup NestJS, Docker PostgreSQL pgvector   :done,    b1, 2026-10-06, 2026-10-06
        Auth JWT, Role RBAC & User Service         :done,    b2, 2026-10-07, 2026-10-07
        API Tra cứu Tri thức Hybrid Search         :active,  b3, 2026-10-07, 2026-10-08
        Stateful Consultation Engine & Missing Loop:         b4, 2026-10-08, 2026-10-09
        Service Matching API & State Transition    :         b5, 2026-10-09, 2026-10-10
        Proposal REST API & Review Workflow        :         b6, 2026-10-10, 2026-10-11
        Security Hardening & Triển khai Staging    :         b7, 2026-10-12, 2026-10-12
    section Thành viên C (AI, Data & Guardrail)
        Định nghĩa Canonical Schema & Chunker Prototype :done, c1, 2026-10-06, 2026-10-06
        Nạp Full Services & Batch Embedding Job         :done, c2, 2026-10-07, 2026-10-07
        Embedding Adapter & Thuật toán RRF Ranking      :active, c3, 2026-10-07, 2026-10-08
        Prompt Trích xuất Requirements (Zod)            :         c4, 2026-10-08, 2026-10-09
        Pre-check Visibility & Post-check Citation      :         c5, 2026-10-09, 2026-10-10
        Proposal JSON Generation Prompt & Post-guard    :         c6, 2026-10-10, 2026-10-11
        Đánh giá Golden Set & Tinh chỉnh Prompt         :         c7, 2026-10-12, 2026-10-12
```

---

## 12. Class Diagram (Thiết Kế Module Backend NestJS)
> **Ứng dụng**: Kiến trúc mã nguồn hướng đối tượng của NestJS Backend.
```mermaid
classDiagram
    class ConsultationController {
        -consultationService: ConsultationService
        +createSession(dto: CreateSessionDto)
        +sendMessage(id: string, dto: MessageDto)
        +getMatching(id: string)
    }

    class ConsultationService {
        -stateManager: WorkflowStateManager
        -retrievalService: HybridRetrievalService
        -aiAdapter: LLMAdapter
        -guardrail: GuardrailService
        +processMessage(sessionId, text)
        +evaluateReadiness(sessionId)
    }

    class HybridRetrievalService {
        -prisma: PrismaService
        -embeddingAdapter: EmbeddingAdapter
        +search(query: string, role: string) SearchResultChunk[]
    }

    class EmbeddingAdapter {
        <<Interface>>
        +generateEmbedding(text: string) number[]
        +getDimension() int
    }

    class GeminiEmbeddingAdapter {
        -client: GoogleGenerativeAI
        +generateEmbedding(text: string) number[]
    }

    class GuardrailService {
        +preCheck(chunks: RawChunk[], role: string) RawChunk[]
        +postCheck(output: LLMOutput, validIds: Set~string~) AuditResult
    }

    class ProposalDocxRenderer {
        +renderDocx(proposalData: ProposalJson) Buffer
        +convertToPdf(docxBuffer: Buffer) Buffer
    }

    ConsultationController --> ConsultationService
    ConsultationService --> HybridRetrievalService
    ConsultationService --> GuardrailService
    HybridRetrievalService --> EmbeddingAdapter
    EmbeddingAdapter <|.. GeminiEmbeddingAdapter
    ConsultationService --> ProposalDocxRenderer
```

---

## 13. User Journey (Hành Trình Tư Vấn Của Sales Trên Mobile)
> **Ứng dụng**: Đánh giá trải nghiệm người dùng của nhân viên Sales từ lúc nhận khách đến khi có Proposal.
```mermaid
journey
    title Hành Trình Tư Vấn Khách Hàng Của Sales Với SkyLink Mobile
    section Chuẩn Bị & Tra Cứu
      Mở app & Xác thực sinh trắc học FaceID: 5: Sales
      Tìm kiếm nhanh giải pháp nông nghiệp S0112: 5: Sales
      Xem danh sách năng lực & chứng chỉ bay: 4: Sales
    section Phiên Tư Vấn Với Khách
      Bấm Tạo Phiên Tư Vấn Mới: 5: Sales
      Nhập yêu cầu: Khách cần quét 500ha cao su: 4: Sales
      AI chỉ báo thiếu thông tin địa hình & giấy phép: 3: Sales
      Bổ sung thông tin thiếu theo gợi ý của AI: 5: Sales
    section Đề Xuất & Bàn Giao
      Xem thẻ đề xuất dịch vụ S0112 kèm lý do: 5: Sales
      Bấm Tạo Bản Thảo Proposal: 4: Sales
      Gửi yêu cầu phê duyệt cho Quản lý: 5: Sales
      Nhận thông báo Approved & Tải PDF gửi khách: 5: Sales
```

---

## 14. Sankey Diagram (Dòng Chảy Thanh Lọc Ngữ Cảnh Qua Guardrail)
> **Ứng dụng**: Trực quan hóa số lượng chunk dữ liệu được thanh lọc qua 2 tầng bảo vệ để triệt tiêu ảo giác.
```mermaid
sankey-beta
    Kho Tri Thức Toàn Cục (500 Chunks),Khớp Lệnh Hybrid Search (50 Chunks),50
    Kho Tri Thức Toàn Cục (500 Chunks),Không Liên Quan (450 Chunks),450
    Khớp Lệnh Hybrid Search (50 Chunks),Pre-check: Loại Bỏ Restricted (10 Chunks),10
    Khớp Lệnh Hybrid Search (50 Chunks),Pre-check: Giữ Lại Verified Chunks (40 Chunks),40
    Pre-check: Giữ Lại Verified Chunks (40 Chunks),Đưa Vào Prompt Context (40 Chunks),40
    Đưa Vào Prompt Context (40 Chunks),Post-check: Trích Dẫn Hợp Lệ Trong Proposal (8 Chunks),8
    Đưa Vào Prompt Context (40 Chunks),Không Trích Dẫn Nhưng Hỗ Trợ Ngữ Cảnh (32 Chunks),32
```

---

## 15. Kanban (Bảng Điều Phối Nhiệm Vụ Sprint MVP)
> **Ứng dụng**: Theo dõi trạng thái các đầu việc P0 trong bảng phân công 7 ngày.
```mermaid
kanban
  Backlog (Ưu Tiên P1)
    [P1: Màn hình so sánh 2-3 candidate services trên Mobile]
    [P1: Admin tối thiểu - Gán quyền user & trigger re-index]
  Đang Triển Khai (Sprint P0)
    [D2-5: Hoàn thiện Hybrid Search API với FTS + pgvector]
    [D3-1: Quản trị phiên tư vấn & trích xuất yêu cầu khách hàng]
    [D4-2: Cài đặt Pre-check Guardrail lọc quyền truy cập]
  Chờ Kiểm Thử (Review / Guardrail)
    [D1-3: Bộ dữ liệu 2 service mẫu được chuẩn hóa Canonical]
    [D2-1: Khung Mobile Shell Expo và luồng xác thực Token]
  Hoàn Thành (Done)
    [R1-R3: Thống nhất Stack công nghệ Mobile + Backend + AI]
    [D1-1: Thiết lập cấu trúc Monorepo dùng chung]
    [D1-2: Docker Compose PostgreSQL với extension pgvector]
```

---

## 16. Requirement Diagram (Đặc Tả Yêu Cầu Phi Chức Năng & Bảo Mật)
> **Ứng dụng**: Quản lý ràng buộc kỹ thuật nghiêm ngặt trước khi đóng gói bản phát hành MVP v0.1.
```mermaid
requirementDiagram

    requirement req_hallucination {
        id: REQ-SAFE-01
        text: Tỷ lệ ảo giác (Hallucination) về Giá bán và Tiến độ phải bằng 0%
        risk: High
        verifymethod: Test
    }

    requirement req_grounding {
        id: REQ-SAFE-02
        text: 100% đề xuất trong Proposal phải gắn kèm chunk_id kiểm chứng
        risk: High
        verifymethod: Inspection
    }

    requirement req_latency {
        id: REQ-PERF-01
        text: Thời gian phản hồi API Hybrid Search phải dưới 1.5 giây
        risk: Medium
        verifymethod: Demonstration
    }

    requirement req_rbac {
        id: REQ-SEC-01
        text: User quyền Sales không thể truy cập chunk có visibility = restricted
        risk: High
        verifymethod: Test
    }

    element skylink_guardrail_system {
        type: Software Component
        docref: guardrail_discipline.md
    }

    skylink_guardrail_system - satisfies -> req_hallucination
    skylink_guardrail_system - satisfies -> req_grounding
    skylink_guardrail_system - satisfies -> req_rbac
```

---

## 17. C4 Architecture (Kiến Trúc Hệ Thống SkyLink C4 Container)
> **Ứng dụng**: Sơ đồ phân tầng kiến trúc tổng thể toàn hệ thống ở mức Container.
```mermaid
flowchart TB
    subgraph C4["KIẾN TRÚC TỔNG THỂ HỆ THỐNG SKYLINK (C4 CONTAINER)"]
        direction TB
        User["Người Dùng Nội Bộ<br/><i>[Sales / BD / Admin]</i>"]
        
        subgraph MobileLayer["Tầng Thiết Bị Di Động"]
            App["SkyLink Mobile Client<br/><i>[Expo / React Native, TanStack Query, SecureStore]</i>"]
        end

        subgraph BackendLayer["Tầng Dịch Vụ Nghiệp Vụ (Backend)"]
            direction TB
            Gateway["API Gateway & Auth Guards<br/><i>[NestJS, JWT, Passport]</i>"]
            Consultation["Consultation Orchestrator<br/><i>[State Machine, Deterministic Validator]</i>"]
            Retrieval["Hybrid Retrieval Engine<br/><i>[FTS tsvector, pgvector RRF Ranker]</i>"]
            ProposalSvc["Proposal Pipeline<br/><i>[docxtemplater, LibreOffice Headless]</i>"]
        end

        subgraph DataLayer["Tầng Cơ Sở Dữ Liệu & Lưu Trữ"]
            direction LR
            DB[("PostgreSQL 16 + pgvector<br/><i>[Canonical Services, Chunks, Sessions]</i>")]
            Storage[("Object Storage / Local Disk<br/><i>[DOCX Templates, Rendered PDFs]</i>")]
        end

        subgraph ExternalLayer["Dịch Vụ AI Bên Ngoài"]
            LLMProvider["Google Gemini API<br/><i>[gemini-1.5-pro, text-embedding-004]</i>"]
        end
    end

    User -->|Sử dụng| App
    App -->|HTTPS / REST API| Gateway
    Gateway --> Consultation
    Gateway --> Retrieval
    Gateway --> ProposalSvc
    Consultation --> Retrieval
    Retrieval --> DB
    ProposalSvc --> DB
    ProposalSvc --> Storage
    Retrieval --> LLMProvider
    Consultation --> LLMProvider
```

---

## 18. Block Diagram (Kiến Trúc Khối Service Intelligence Core)
> **Ứng dụng**: Sơ đồ cấu trúc các khối chức năng bên trong lõi Service Intelligence của SkyLink.
```mermaid
block-beta
    columns 3
    block:header:3
        h["LÕI TRÍ TUỆ DỊCH VỤ SKYLINK (SERVICE INTELLIGENCE CORE)"]
    end
    block:ingest["1. TẦNG NẠP TRI THỨC"]:1
        A["Service Asset Parser"]
        B["Canonical Normalizer"]
        C["Semantic Chunker"]
    end
    block:retrieval["2. TẦNG TRUY VẤN LAI"]:1
        D["FTS tsvector Search"]
        E["pgvector Cosine Search"]
        F["RRF Fusion Ranker"]
    end
    block:guard["3. TẦNG BẢO VỆ & OUTPUT"]:1
        G["Pre-check Visibility Filter"]
        H["Post-check Citation Auditor"]
        I["DOCX / PDF Generator"]
    end
    ingest --> retrieval
    retrieval --> guard
```

---

## 19. Packet Diagram (Layout Gói Tin JWT Access Token)
> **Ứng dụng**: Mô tả cấu trúc các trường trong Payload của JWT Token dùng cho Authentication & RBAC.
```mermaid
packet-beta
    0-15: "Token Algorithm & Type (HS256 / JWT)"
    16-31: "Issuer Identifier (gascolae.skylink)"
    32-63: "Subject: User UUID (32 bits reference)"
    64-79: "User Role (16 bits: Sales | Reviewer | Admin)"
    80-95: "Permissions Bitmask (READ, CONSULT, APPROVE)"
    96-127: "Issued At Timestamp (iat: Unix Time)"
    128-159: "Expiration Timestamp (exp: 24h validity)"
```

---

## 20. Architecture Cloud (Hạ Tầng Triển Khai Docker & Production)
> **Ứng dụng**: Trực quan hóa cấu trúc container hóa triển khai trên máy chủ môi trường Staging/Production.
```mermaid
flowchart TD
    subgraph ClientSide["Môi Trường Thiết Bị Đầu Cuối"]
        direction TB
        MobileApp["Ứng Dụng Mobile SkyLink<br/><i>[Android APK / iOS Internal Build]</i>"]
    end

    subgraph HostServer["Máy Chủ Triển Khai (Linux Host Server)"]
        direction TB
        Nginx["Reverse Proxy & SSL Termination<br/><i>[Nginx Container - Port 80/443]</i>"]
        
        subgraph DockerCompose["Docker Compose Stack"]
            direction LR
            NestApp["NestJS API Container<br/><i>[Node 20, Port 3000]</i>"]
            PostgresDB[("PostgreSQL 16 + pgvector<br/><i>[Port 5432, Persistent Volume]</i>")]
            LibreOffice["LibreOffice Headless<br/><i>[PDF Render Service]</i>"]
        end
    end

    subgraph ExternalCloud["Cloud Services"]
        GeminiAPI["Google Gemini AI Platform<br/><i>[REST HTTPS]</i>"]
    end

    MobileApp -->|HTTPS / WSS| Nginx
    Nginx --> NestApp
    NestApp --> PostgresDB
    NestApp --> LibreOffice
    NestApp --> GeminiAPI
```

---

## 💡 3 QUY TẮC BẤT BIẾN ĐỂ SƠ ĐỒ LUÔN HIỂN THỊ HOÀN HẢO:
1. **Luôn đóng ngoặc kép nhãn node**: `A["Tên nhãn có (ngoặc), dấu cách, số S0112"]` $\to$ Tránh 100% lỗi vỡ cú pháp.
2. **Quy tắc Bố cục Ngang Ưu Tiên (Horizontal-First)**: Luôn dùng `flowchart LR` cho luồng dữ liệu, RAG pipeline, và quy trình xử lý để tận dụng toàn bộ chiều rộng màn hình.
3. **Màu sắc Dark Theme độ tương phản cao**: Không dùng nền màu nhạt; luôn dùng viền đậm và màu chữ trắng sáng để chống tàng hình chữ trên màn hình tối.
