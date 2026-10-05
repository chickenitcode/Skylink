# CT GROUP — GASCOLAE PLATFORM
### EXTRA INNOVATION PROJECT

# SKYLINK
## NỀN TẢNG TRỢ LÝ TƯ VẤN DỊCH VỤ NỘI BỘ GASCOLAE TRÊN THIẾT BỊ DI ĐỘNG
*SkyLink — Mobile app nội bộ GASCOLAE*

---

- **Nhóm thực hiện:** Thực tập sinh nhóm 03
- **Thành viên:** 
  - Mai Tấn Giáp
  - Lê Phúc Khang
  - Nguyễn Quyết Giang Sơn
- **Đơn vị:** GASCOLAE Platform
- **Loại dự án:** Extra Innovation Project
- **Địa điểm & Thời gian:** TP. Hồ Chí Minh, 2026

---

## Lời cảm ơn

Nhóm chúng em xin chân thành cảm ơn Ban lãnh đạo, anh Vũ Đỗ Tuấn Huy và các anh chị thuộc GASCOLAE Platform, đội ngũ kỹ thuật và các bên liên quan đã tạo điều kiện để nhóm được tiếp cận, nghiên cứu và chuẩn hóa các Service Assets trong quá trình thực hiện dự án.

Thông qua quá trình nghiên cứu các dịch vụ, nhóm có cơ hội tiếp cận không chỉ kiến thức nghiệp vụ mà còn các vấn đề thực tế liên quan đến quản trị tri thức, tra cứu thông tin, hỗ trợ tư vấn dịch vụ và khai thác dữ liệu bằng trí tuệ nhân tạo.

Trên cơ sở đó, nhóm đề xuất và phát triển dự án **SkyLink** như một bước thử nghiệm nhằm chuyển hóa các Service Assets đã chuẩn hóa thành một hệ thống tri thức có khả năng truy vấn, hỗ trợ tư vấn và tạo bản thảo Proposal có kiểm soát nguồn nhằm giúp đội ngũ salse và đội ngũ business development trong việc tra cứu các kiến thức trong các service thuận tiện và chuẩn xác phục vụ cho quá trình tư vấn khách hàng.

Nhóm xin trân trọng cảm ơn những ý kiến đóng góp và sự hỗ trợ trong quá trình thực hiện dự án.

---

## Danh mục từ viết tắt

| Từ viết tắt | Ý nghĩa |
| :--- | :--- |
| **AI** | Artificial Intelligence |
| **LLM** | Large Language Model |
| **RAG** | Retrieval-Augmented Generation |
| **RBAC** | Role-Based Access Control |
| **API** | Application Programming Interface |
| **FTS** | Full-Text Search |
| **MVP** | Minimum Viable Product |
| **DWH** | Data Warehouse |
| **UI** | User Interface |
| **UX** | User Experience |

---

## Tóm tắt

SkyLink là ứng dụng di động nội bộ được đề xuất cho GASCOLAE nhằm hỗ trợ thành viên trong quá trình tra cứu, tư vấn và đề xuất các dịch vụ dựa trên hệ thống Service Assets đã được chuẩn hóa.

Bài toán chính của dự án không chỉ nằm ở việc xây dựng giao diện hội thoại với mô hình ngôn ngữ lớn, mà tập trung vào việc tổ chức và khai thác dữ liệu dịch vụ theo cách phù hợp cho truy vấn AI.

Dữ liệu từ các Service Assets được chuẩn hóa theo schema chung, sau đó được xử lý bằng cơ chế semantic chunking, bổ sung metadata và embedding để xây dựng Semantic Vector Index.

Hệ thống sử dụng hybrid retrieval kết hợp tìm kiếm theo metadata, full-text search và vector search để xác định các đơn vị tri thức phù hợp với yêu cầu của người dùng.

Quy trình tư vấn được thiết kế theo mô hình stateful consultation. Hệ thống lần lượt thu thập nhu cầu khách hàng, xác định thông tin còn thiếu, tra cứu và đánh giá các dịch vụ phù hợp, sau đó chỉ chuyển sang bước sinh Proposal khi các điều kiện dữ liệu cần thiết đã được đáp ứng.

Để giảm rủi ro từ nội dung do AI tạo ra, hệ thống áp dụng hai lớp kiểm soát: Pre-check Guardrail nhằm giới hạn dữ liệu được phép đưa vào prompt và Post-check Guardrail nhằm kiểm tra grounding, nguồn dẫn và các nội dung có nguy cơ bị suy diễn.

Đầu ra cuối cùng của quy trình là Proposal có cấu trúc, có khả năng truy vết nguồn và được render thành định dạng DOCX hoặc PDF để Sales hoặc người có trách nhiệm tiếp tục kiểm tra trước khi sử dụng.

---

# CHƯƠNG 1. TỔNG QUAN VÀ BÀI TOÁN

## 1.1. Bối cảnh dự án
Trình bày bối cảnh GASCOLAE Platform, quá trình chuẩn hóa các Service Assets và lý do xuất hiện nhu cầu xây dựng một lớp Service Intelligence.

## 1.2. Bài toán hiện tại
Các vấn đề chính gồm:
- Tri thức dịch vụ nằm trong nhiều Service Assets khác nhau.
- Việc tra cứu và so sánh nhiều service còn phụ thuộc nhiều vào thao tác thủ công.
- Sales mất thời gian tổng hợp dữ liệu khi tư vấn khách hàng.
- Việc tạo Proposal có nhiều bước lặp lại.
- AI có nguy cơ sinh ra thông tin không có nguồn kiểm chứng.
- Dữ liệu đã có schema chung nhưng chưa được tổ chức tối ưu cho semantic retrieval.

## 1.3. Động lực lựa chọn ứng dụng di động
SkyLink được định hướng dưới dạng ứng dụng mobile nội bộ do đối tượng sử dụng chính bao gồm Sales, Business Development và các thành viên thường xuyên trao đổi với khách hàng hoặc làm việc ngoài môi trường desktop.

Ứng dụng mobile cung cấp khả năng truy cập tức thời, hỗ trợ workflow hội thoại và tạo nền tảng cho các chức năng mở rộng như notification, voice input, camera hoặc thu thập context tại hiện trường.

## 1.4. Mục tiêu dự án

### 1.4.1. Mục tiêu tổng quát
Xây dựng một nền tảng trợ lý nội bộ cho phép khai thác Service Knowledge của GASCOLAE để hỗ trợ tư vấn và tạo Proposal có kiểm soát nguồn.

### 1.4.2. Mục tiêu cụ thể
- Chuẩn hóa dữ liệu Service thành Knowledge Layer có thể truy vấn.
- Xây dựng semantic chunking phù hợp với schema Service.
- Tạo Vector Knowledge Index.
- Hỗ trợ Hybrid Retrieval.
- Xây dựng Stateful Consultation Workflow.
- Match nhu cầu khách hàng với Service phù hợp.
- Sinh Proposal dựa trên dữ liệu đã được xác minh.
- Kiểm soát quyền truy cập và hallucination.

## 1.5. Phạm vi dự án

### 1.5.1. Trong phạm vi
- Mobile application dành cho người dùng nội bộ.
- Quản lý phiên tư vấn.
- Tra cứu knowledge.
- Service matching.
- Proposal generation.
- Vector retrieval.
- Guardrails.
- Traceability.

### 1.5.2. Ngoài phạm vi
- Tự động gửi Proposal cho khách hàng mà không qua review.
- Tự quyết định giá bán hoặc discount.
- Tự đưa ra cam kết pháp lý.
- Thay thế hoàn toàn Data Warehouse của GASCOLAE.

## 1.6. Đối tượng sử dụng
- Sales / Business Development.
- Operation / Technical.
- Manager / Reviewer.
- Administrator.

---

# CHƯƠNG 2. PHÂN TÍCH VÀ THIẾT KẾ GIẢI PHÁP

## 2.1. Tổng quan giải pháp SkyLink
SkyLink bao gồm ba thành phần chính:
1. Mobile Application.
2. Service Intelligence Backend.
3. Knowledge and AI Infrastructure.

## 2.2. Luồng nghiệp vụ
Luồng nghiệp vụ chính:
> Khách hàng $\rightarrow$ Sales $\rightarrow$ Thu thập nhu cầu $\rightarrow$ AI phân tích $\rightarrow$ Tra cứu / Match Service $\rightarrow$ Bổ sung thông tin nếu thiếu $\rightarrow$ Đề xuất Service $\rightarrow$ Kiểm tra Proposal Readiness $\rightarrow$ Sinh Proposal $\rightarrow$ Validation $\rightarrow$ DOCX/PDF $\rightarrow$ Sales $\rightarrow$ Khách hàng.

## 2.3. Các tác nhân trong hệ thống

### 2.3.1. Sales / Business Development
Tra cứu Service, thực hiện phiên tư vấn và tạo Proposal.

### 2.3.2. Admin
Quản trị người dùng, phân quyền, dữ liệu và cấu hình hệ thống.

### 2.3.3. LLM Provider
Cung cấp khả năng suy luận, trích xuất nhu cầu, hỗ trợ service matching và sinh nội dung có cấu trúc.

## 2.4. Kiến trúc hệ thống
![Kiến trúc tổng thể của hệ thống SkyLink](images/system-architecture.pdf)
*Hình 2.1: Kiến trúc tổng thể của hệ thống SkyLink*

## 2.5. Kiến trúc Mobile Application
Có thể triển khai bằng:
- React Native / Expo; hoặc
- Flutter.

Các module phía mobile:
- Authentication.
- Consultation.
- Service Search.
- Service Detail.
- Service Comparison.
- Proposal Preview.
- Conversation History.
- Notification.

## 2.6. Thiết kế Backend
Backend chịu trách nhiệm:
- API Gateway.
- Authentication và RBAC.
- Consultation Orchestrator.
- Conversation State Manager.
- Service Matcher.
- Hybrid Retrieval Engine.
- Proposal Generation.
- Audit Logging.

## 2.7. Thiết kế dữ liệu Service

### 2.7.1. Canonical Service Data
Canonical Service Data là nguồn dữ liệu chuẩn.

Ví dụ:
```json
{
  "service_id": "S0112",
  "service_name": "...",
  "customer_problems": [],
  "capabilities": [],
  "use_cases": [],
  "service_levels": [],
  "deliverables": [],
  "conditions": []
}
```

## 2.8. Chiến lược Chunking
Dự án sử dụng **schema-aware semantic chunking** thay vì fixed-size chunking.

Các đơn vị tri thức có thể bao gồm:
- Service Overview.
- Customer Problem.
- Capability.
- Use Case.
- Service Level.
- Deliverable.
- Deployment Condition.
- FAQ.
- Research Gap.

### 2.8.1. Chunk Metadata
Mỗi chunk lưu metadata:
```json
{
  "chunk_id": "...",
  "service_id": "S0112",
  "asset_code": "CODE_02",
  "record_type": "service_level",
  "source_ids": ["SRC-01"],
  "status": "verified",
  "visibility": "internal",
  "version": 1,
  "content": "..."
}
```

## 2.9. Vector Knowledge Layer
Embedding được tạo từ semantic chunks và lưu trong vector index.

Công nghệ đề xuất:
- PostgreSQL cho Canonical Data.
- pgvector cho Semantic Vector Index.

## 2.10. Hybrid Retrieval
Hybrid Retrieval kết hợp:
1. Metadata Filtering.
2. Full-text Search.
3. Vector Similarity Search.
4. Ranking / Reranking.

## 2.11. Stateful Consultation
Mỗi phiên tư vấn được lưu dưới dạng Consultation Session.
```json
{
  "session_id": "...",
  "state": "DISCOVERY",
  "requirements": {
    "problem": "...",
    "objective": "...",
    "deployment_context": null,
    "constraints": []
  },
  "candidate_services": [],
  "selected_services": []
}
```

Các trạng thái chính:
1. DISCOVERY.
2. REQUIREMENT_COLLECTION.
3. SERVICE_MATCHING.
4. SERVICE_RECOMMENDED.
5. PROPOSAL_READY.
6. PROPOSAL_GENERATED.
7. REVIEW_REQUIRED.

## 2.12. Service Matching
Service Matcher đánh giá mức độ phù hợp giữa nhu cầu khách hàng và:
- Customer Problem.
- Use Case.
- Capability.
- Target Customer.
- Deployment Condition.

## 2.13. Pre-check Guardrail
Pre-check thực hiện trước khi context được gửi tới LLM.

Kiểm tra:
- Permission.
- Visibility.
- Data Status.
- Service Scope.

## 2.14. Post-check Guardrail
Post-check thực hiện sau khi LLM sinh output.

Kiểm tra:
- Grounding.
- Citation.
- Capability claim.
- Price.
- Timeline.
- Commitment.
- Legal claims.

## 2.15. Proposal Generation
Proposal không được sinh trực tiếp từ toàn bộ conversation history.

Pipeline:
> Conversation $\rightarrow$ Structured Requirements $\rightarrow$ Selected Services $\rightarrow$ Evidence Chunks $\rightarrow$ Proposal JSON $\rightarrow$ Validation $\rightarrow$ DOCX $\rightarrow$ PDF.

## 2.16. Bảo mật hệ thống
Các cơ chế chính:
- Authentication.
- RBAC.
- Server-side Secret Management.
- Input Validation.
- Data Visibility Filtering.
- Audit Logging.
- API Authorization.

---

# CHƯƠNG 3. TRIỂN KHAI VÀ ĐÁNH GIÁ THỰC NGHIỆM

## 3.1. Môi trường triển khai
Trình bày:
- Mobile Framework.
- Backend Framework.
- Database.
- Vector Storage.
- LLM Provider.
- Embedding Model.
- Infrastructure.

## 3.2. Cấu trúc source code
Ví dụ:
```text
skylink/
|
|-- mobile/
|
|-- backend/
|   |-- auth/
|   |-- consultation/
|   |-- retrieval/
|   |-- matcher/
|   |-- proposal/
|   `-- guardrails/
|
|-- knowledge/
|   |-- ingestion/
|   |-- chunking/
|   `-- embedding/
|
`-- docs/
```

## 3.3. Triển khai Knowledge Pipeline
Mô tả:
1. Import Service Assets.
2. Validate Schema.
3. Normalize.
4. Semantic Chunking.
5. Metadata Enrichment.
6. Generate Embedding.
7. Store Vector.

## 3.4. Triển khai Hybrid Retrieval
Mô tả thuật toán retrieval và ranking.

## 3.5. Triển khai Consultation Engine
Mô tả cách quản lý conversation state và requirement collection.

## 3.6. Triển khai Proposal Generator
Mô tả JSON Schema, validation và DOCX/PDF rendering.

## 3.7. Kịch bản kiểm thử

### 3.7.1. Tra cứu Service
Kiểm thử câu hỏi có thông tin trực tiếp trong Knowledge Base.

### 3.7.2. Tư vấn Service
Kiểm thử yêu cầu khách hàng chưa đầy đủ và quá trình AI hỏi bổ sung.

### 3.7.3. Service Matching
Kiểm tra khả năng lựa chọn đúng service từ tập service hiện tại.

### 3.7.4. Guardrail
Kiểm tra:
- Restricted data.
- Missing source.
- Hallucinated price.
- Hallucinated timeline.
- Unsupported capability.

### 3.7.5. Proposal Generation
Kiểm tra Proposal sinh ra:
- đúng service;
- đúng nhu cầu khách hàng;
- có nguồn;
- không tự tạo thông tin;
- render thành công DOCX/PDF.

## 3.8. Tiêu chí đánh giá
Có thể sử dụng các chỉ số:
- Retrieval Precision.
- Retrieval Recall.
- Service Matching Accuracy.
- Grounded Response Rate.
- Hallucination Rate.
- Proposal Validation Pass Rate.
- Average Response Time.

## 3.9. Kết quả thực nghiệm
Chèn kết quả thực tế sau khi hệ thống được triển khai.

Ví dụ:

| Metric | Kết quả | Mục tiêu |
| :--- | :---: | :---: |
| Retrieval Precision | -- | -- |
| Service Match Accuracy | -- | -- |
| Grounded Response Rate | -- | -- |
| Proposal Validation Pass Rate | -- | -- |
| Average Latency | -- | -- |

## 3.10. Phân tích kết quả
Phân tích ưu điểm, hạn chế và các trường hợp hệ thống thất bại.

---

# CHƯƠNG 4. KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN

## 4.1. Kết quả đạt được
Tổng hợp các thành phần đã hoàn thiện:
- Mobile application.
- Canonical Service Knowledge.
- Semantic Chunking.
- Vector Knowledge Layer.
- Hybrid Retrieval.
- Stateful Consultation.
- Service Matching.
- Guardrails.
- Proposal Generation.

## 4.2. Giá trị của dự án
SkyLink chứng minh khả năng chuyển các Service Assets từ tài liệu tĩnh thành một lớp Service Intelligence có thể khai thác bằng AI.

## 4.3. Hạn chế
Ví dụ:
- Dataset thử nghiệm còn giới hạn.
- Chưa tích hợp hoàn toàn với hạ tầng production.
- Chất lượng phụ thuộc vào dữ liệu nguồn.
- Reranking và matching vẫn có thể tiếp tục tối ưu.

## 4.4. Khả năng mở rộng
Kiến trúc có thể mở rộng từ tập service ban đầu sang toàn bộ catalog bằng pipeline:
> Normalize $\rightarrow$ Chunk $\rightarrow$ Metadata $\rightarrow$ Embed $\rightarrow$ Index.

## 4.5. Hướng phát triển
Các hướng tiếp theo:
- Tích hợp trực tiếp GASCOLAE Data Warehouse.
- Enterprise SSO.
- Push Notification.
- Voice Consultation.
- Camera / Image Context.
- Advanced Reranking.
- Knowledge Graph.
- Automated evaluation pipeline.
- Human approval workflow.
- Analytics Dashboard.

---

## Tài liệu tham khảo

1. Patrick Lewis et al., *Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks*, 2020.
2. pgvector, *Open-source vector similarity search for PostgreSQL*.
3. Relevant LLM provider documentation.

---

# PHỤ LỤC

## Phụ lục A. Thiết kế API
Ví dụ:
```http
POST /api/consultations
POST /api/consultations/:id/messages
GET  /api/services/search
POST /api/services/match
POST /api/proposals
GET  /api/proposals/:id
```

## Phụ lục B. Service Knowledge Schema
Đưa JSON Schema đầy đủ của Service vào phần này.

## Phụ lục C. Chunk Schema và Metadata
Đưa cấu trúc chunk, metadata và indexing strategy.

## Phụ lục D. Proposal JSON Schema
Đưa Proposal JSON Schema và validation rule.

## Phụ lục E. Bộ Test Case
Liệt kê các test case:
- Retrieval.
- Service Matching.
- Guardrail.
- Proposal Generation.
- Permission.

## Phụ lục F. Các sơ đồ hệ thống
Bao gồm:
- System Architecture.
- Business Workflow.
- Sequence Diagram.
- Consultation State Machine.
- Knowledge Ingestion Pipeline.
- Database ERD.
