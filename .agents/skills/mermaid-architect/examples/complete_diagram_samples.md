# MẪU BIỂU ĐỒ MERMAID CHUẨN THỰC CHIẾN (complete_diagram_samples.md)

## 1. Flowchart Horizontal-First (Khuyên Dùng)
```mermaid
flowchart LR
    Client["Ứng Dụng Mobile"] --> Gateway["API Gateway NestJS"]
    Gateway --> DB["PostgreSQL 16 + pgvector"]
    Gateway --> Worker["LibreOffice PDF Worker"]
```

## 2. Sequence Diagram (Xác Thực & Tư Vấn)
```mermaid
sequenceDiagram
    autonumber
    actor Sales as Sales/BD Mobile
    participant API as NestJS Gateway
    participant Guard as Guardrail Sentinel
    participant LLM as LLM Engine

    Sales->>API: Gửi tin nhắn nhu cầu
    API->>Guard: Kiểm tra tiền kiểm Pre-check
    Guard-->>API: Ngữ cảnh an toàn (Sanitized)
    API->>LLM: Trích xuất yêu cầu có cấu trúc
    LLM-->>API: JSON Customer Requirements
    API-->>Sales: Trả về trạng thái & Missing fields
```

## 3. Git Graph (Phân Nhánh Kế Hoạch 7 Ngày)
```mermaid
gitgraph
    commit id: "init-repo"
    branch develop
    checkout develop
    commit id: "day1-foundation"
    commit id: "day2-knowledge-retrieval"
    commit id: "day3-consultation-flow"
    checkout main
    merge develop id: "mvp-v0.1-release" tag: "v0.1"
```
