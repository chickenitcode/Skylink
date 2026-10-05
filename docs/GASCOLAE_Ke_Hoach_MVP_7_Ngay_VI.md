# GASCOLAE SkyLink — Kế hoạch MVP 7 ngày

## 1. Thông tin chung

| Thông tin | Giá trị |
| --- | --- |
| **Dự án** | Internal Mobile Service Intelligence MVP |
| **Thời gian** | 7 ngày / 14 buổi nửa ngày |
| **Quy mô team** | 3.0 thành viên |
| **Tổng công dự kiến** | 0 giờ |
| **Tổng số đầu việc** | 42 |
| **Tiến độ hoàn thành** | 0% |

## 2. Phân công thành viên

| Thành viên | Mã | Vai trò chính | Trách nhiệm chính |
| --- | --- | --- | --- |
| Mai Tấn Giáp | A | Dev | Đảm bảo tính nhất quán kiến trúc, tích hợp mobile, hợp đồng dữ liệu dùng chung, tích hợp cuối |
| Lê Phúc Khang | B | Dev | NestJS API, PostgreSQL/Prisma, Auth/RBAC, workflow Proposal và tài liệu |
| Nguyễn Quyết Giang Sơn | C | AI / Data | Dữ liệu chuẩn hóa, chunking, embedding, hybrid retrieval, prompt/guardrail/evaluation cho LLM |

## 3. Nguyên tắc triển khai

1. Sáng ngày 1 dành riêng cho research và thống nhất công nghệ; bắt đầu code từ chiều ngày 1.
2. Ưu tiên một happy path end-to-end hoàn chỉnh hơn là mở rộng quá nhiều tính năng.
3. Backend quản lý workflow state và authorization; mobile không tự thay đổi state.
4. Canonical service data là nguồn chuẩn; pgvector chỉ là semantic index dẫn xuất.
5. Output của LLM phải có cấu trúc và được validate; human review là bắt buộc trước trạng thái APPROVED.

## 4. Giả định

| Hạng mục | Chi tiết |
| --- | --- |
| **Dữ liệu service** | Service Assets mục tiêu đã có sẵn và có thể normalize theo canonical schema đã thống nhất. |
| **AI provider** | Có ít nhất một API key LLM + embedding được phép dùng cho phát triển MVP. |
| **Proposal template** | Có DOCX template để render Proposal trong MVP. |
| **Môi trường deploy** | Có thể provision PostgreSQL+pgvector và object/file storage phù hợp. |

---

# Phạm vi MVP

| Ưu tiên | Hạng mục | Định nghĩa trong MVP | Phạm vi |
| --- | --- | --- | --- |
| P0 | Ứng dụng mobile nội bộ | Login, home, service search/detail, consultation, requirements, match result, proposal readiness/preview/review/docs | Trong MVP |
| P0 | Auth/RBAC | Quyền Sales/Business Development và Admin/Reviewer | Trong MVP |
| P0 | Canonical Knowledge | Service/Asset/Record/Chunk/Source có verification status + visibility + version | Trong MVP |
| P0 | Hybrid Retrieval | PostgreSQL FTS + pgvector + metadata filter + evidence | Trong MVP |
| P0 | Stateful Consultation | Requirement extraction, missing-info loop, workflow state do backend quản lý | Trong MVP |
| P0 | Service Matching | Recommendation có evidence; không expose raw vector score cho UI | Trong MVP |
| P0 | Proposal Pipeline | Readiness → structured JSON → validation → human review → DOCX/PDF | Trong MVP |
| P0 | Guardrail | Pre-check permission/visibility/status + post-check grounding/claims/citations | Trong MVP |
| P0 | Audit | State transition, retrieval trace, proposal/review event | Trong MVP |
| P1 | Admin tối thiểu | Gán role + trigger/status ingestion/re-index | Giới hạn thời gian |
| P1 | So sánh service | So sánh 2–3 candidate service trên mobile | Làm nếu luồng cốt lõi ổn định |
| Ngoài phạm vi | Enterprise IAM/SSO đầy đủ | MVP dùng JWT/RBAC; giữ adapter point cho giai đoạn sau | Không thuộc MVP |
| Ngoài phạm vi | Admin dashboard đầy đủ | Chỉ làm chức năng Admin tối thiểu | Không thuộc MVP |
| Ngoài phạm vi | Analytics/KPI dashboard nâng cao | Không tạo business analytics giả | Không thuộc MVP |
| Ngoài phạm vi | Tự động gửi Proposal cho khách hàng | Sales/human vẫn là bên gửi cuối | Không thuộc MVP |


---

# Checkpoint theo ngày

| Ngày | Checkpoint cuối ngày | Tiêu chí nghiệm thu | Quy tắc Go / No-Go |
| --- | --- | --- | --- |
| 1.0 | Nền tảng sẵn sàng | Workspace chạy được; API health hoạt động; PostgreSQL+pgvector migration thành công; 2 service được normalize/chunk. | Chỉ sang bước ingest đầy đủ và Auth khi foundation có thể tái lập. |
| 2.0 | Tra cứu tri thức end-to-end | Sales login, duyệt service, hybrid search, mở chi tiết service có nguồn. | Không để restricted knowledge xuất hiện trong kết quả của Sales. |
| 3.0 | Luồng tư vấn hoạt động | Tạo session → chat → structured requirements → field thiếu → clarification → lưu state. | Backend, không phải mobile/LLM, sở hữu workflow state chính thức. |
| 4.0 | Service Matching hoạt động | Requirement đủ → hybrid retrieval → guardrail → service đề xuất + evidence → Sales chọn service. | Recommendation không có evidence phải bị reject/fallback. |
| 5.0 | Proposal Draft hoạt động | Readiness đạt → sinh Proposal JSON → validation → lưu draft và preview. | Claim không có căn cứ về price/timeline/capability phải bị chặn hoặc đánh dấu. |
| 6.0 | Review + tài liệu hoạt động | Reviewer approve/request changes; Proposal approved sinh DOCX/PDF; có audit trace. | Chỉ reviewer có quyền mới được approve. |
| 7.0 | MVP sẵn sàng phát hành | App đã deploy chạy full happy path; test P0 pass; golden AI cases đạt; demo và setup docs sẵn sàng. | Chỉ tag MVP v0.1 khi không còn blocker nghiêm trọng. |


---

# Kế hoạch chi tiết 7 ngày

| Mã | Ngày | Buổi | Đầu việc chi tiết | Nhóm công việc | Đầu việc | Phụ trách | Ước tính (giờ) | Phụ thuộc | Kết quả bàn giao | Checkpoint / Tiêu chí hoàn thành | Ưu tiên | Trạng thái | Trạng thái 2 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R1 | 1.0 | Sáng | Tìm hiểu Expo/React Native navigation, lưu token an toàn, TanStack Query; rà soát cấu trúc module NestJS, Prisma, PostgreSQL/pgvector, Swagger/OpenAPI. | Nghiên cứu & thống nhất kỹ thuật | Nghiên cứu stack mobile + backend | Thành viên A + B | 4.0 | - | Ghi chú kỹ thuật + quyết định stack | Chốt stack; không còn blocker chưa rõ trước khi khởi tạo dự án | P0 | Chưa bắt đầu | Chưa bắt đầu |
| R2 | 1.0 | Sáng | Tìm hiểu schema-aware chunking, PostgreSQL FTS + pgvector, metadata filtering, truy vết evidence, mẫu thiết kế Embedding Adapter. | Nghiên cứu & thống nhất kỹ thuật | Nghiên cứu RAG / hybrid retrieval | Thành viên C | 4.0 | - | Ghi chú thiết kế RAG | Chốt chunk schema + chiến lược retrieval | P0 | Chưa bắt đầu | Chưa bắt đầu |
| R3 | 1.0 | Sáng | Tìm hiểu structured JSON output của Gemini/OpenAI, Zod validation, pre-check/post-check guardrail, docxtemplater + LibreOffice headless. | Nghiên cứu & thống nhất kỹ thuật | Nghiên cứu structured output của LLM + sinh Proposal | Thành viên A + C | 4.0 | - | Ghi chú triển khai AI/Proposal | Chốt JSON contract của LLM + cách sinh Proposal | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D1-1 | 1.0 | Chiều | Tạo repo/workspace: apps/mobile, apps/api, packages/shared; cấu hình TypeScript, lint, mẫu env, DTO/type dùng chung, quy ước branch. | Khởi tạo dự án | Khởi tạo workspace và hợp đồng dữ liệu dùng chung | Thành viên A | 4.0 | R1,R3 | Bộ khung workspace chạy được | Mobile + API chạy local theo README | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D1-2 | 1.0 | Chiều | Tạo các module NestJS, Docker Compose cho PostgreSQL+pgvector, Prisma schema ban đầu, migration, health endpoint, Swagger. | Nền tảng Backend | Khởi tạo API + cơ sở dữ liệu | Thành viên B | 4.0 | R1 | Nền tảng API + DB | GET /health hoạt động; migration đầu chạy thành công; pgvector sẵn sàng | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D1-3 | 1.0 | Chiều | Ánh xạ schema service sang Service/Asset/Record/Chunk/Source; làm prototype schema-aware chunker cho 2 service mẫu; định nghĩa chunk_id ổn định. | Nền tảng tri thức | Định nghĩa canonical schema + prototype chunking | Thành viên C | 4.0 | R2 | Canonical schema + chunk mẫu | 2 service được normalize và chunk thành công, có metadata/source link | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D2-1 | 2.0 | Sáng | Expo app shell, navigation, màn hình login, session store, SecureStore cho token, API client, khung điều hướng theo role. | Nền tảng Mobile | Xây mobile shell và luồng đăng nhập | Thành viên A | 4.0 | D1-1,D1-2 | Khung login/navigation mobile | Login kết nối mock/real API và giữ được session | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D2-2 | 2.0 | Sáng | Triển khai users/roles/permissions, JWT access+refresh, guards; tạo bảng service/asset/record/chunk/source và seed role. | Backend & RBAC | Triển khai Auth/RBAC + schema service | Thành viên B | 4.0 | D1-2,D1-3 | Auth/RBAC + DB tri thức | Quyền Sales/Admin được enforce trên endpoint mẫu | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D2-3 | 2.0 | Sáng | Tạo script/import format để normalize, nạp Service Assets hiện có, enrich metadata, chunk toàn bộ service, kiểm tra visibility/status/source. | Nạp dữ liệu tri thức | Nạp toàn bộ dữ liệu service | Thành viên C | 4.0 | D1-3 | Bộ dữ liệu canonical đã nạp | Toàn bộ service mục tiêu có record/chunk hợp lệ, không có source tham chiếu mồ côi | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D2-4 | 2.0 | Chiều | Triển khai EmbeddingAdapter, batch embedding job, lưu embedding model/version/dimension; tạo vector index. | Retrieval | Embedding + lập chỉ mục pgvector | Thành viên C | 4.0 | D2-3 | Vector index | Tất cả chunk đủ điều kiện đã được embedding; lỗi được ghi nhận và có thể retry | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D2-5 | 2.0 | Chiều | Triển khai metadata filter + PostgreSQL FTS + pgvector search + merge/rank; trả về chunk kèm source ID, status, visibility. | Retrieval | Hybrid Search API | Thành viên B + C | 4.0 | D2-2,D2-4 | POST /knowledge/search | Các truy vấn mẫu trả về evidence phù hợp và không lộ restricted chunk | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D2-6 | 2.0 | Chiều | Triển khai danh sách service, tìm kiếm, chi tiết service, source chip và verification badge; kết nối backend. | Mobile Knowledge | Màn hình danh mục/tìm kiếm/chi tiết service | Thành viên A | 4.0 | D2-1,D2-5 | UI tra cứu tri thức | Login → search → mở service → xem nguồn chạy end-to-end | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D3-1 | 3.0 | Sáng | Tạo consultation_sessions, messages, customer_requirements; triển khai API create/get/list/message và lưu workflow state. | Backend tư vấn | Lưu Consultation Session + message | Thành viên B | 4.0 | D2-2 | Consultation API | Tạo session được, lưu message được, backend trả đúng state | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D3-2 | 3.0 | Sáng | Thiết kế schema trích xuất problem/objective/context/constraints/output; gọi LLM Adapter; Zod validation; cập nhật requirement state. | AI tư vấn | Trích xuất requirement | Thành viên C | 4.0 | D2-5 | Requirement extractor | 3 đoạn hội thoại mẫu tạo ra structured requirements hợp lệ | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D3-3 | 3.0 | Sáng | Xây form bắt đầu tư vấn, màn hình chat, trạng thái message, requirement summary, chỉ báo field còn thiếu. | Mobile tư vấn | Chat + màn hình requirement state | Thành viên A | 4.0 | D2-6,D3-1 | UI tư vấn | User tạo session và gửi/nhận message tư vấn được | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D3-4 | 3.0 | Chiều | Triển khai validator deterministic cho các field bắt buộc; chỉ sinh câu hỏi clarification cho field còn thiếu; giữ state COLLECTING_REQUIREMENTS đến khi đủ. | Workflow | Kiểm tra đủ requirement + clarification | Thành viên B + C | 4.0 | D3-1,D3-2 | Logic checkpoint requirement | Backend chặn service matching khi thiếu field bắt buộc | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D3-5 | 3.0 | Chiều | Thêm màn hình/trạng thái missing information, chỉnh requirement, retry flow và lịch sử/tiếp tục phiên tư vấn. | Mobile tư vấn | Luồng bổ sung thông tin còn thiếu | Thành viên A | 4.0 | D3-3,D3-4 | UX clarification hoàn chỉnh | User bổ sung thông tin thiếu và tiếp tục session đúng trạng thái | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D3-6 | 3.0 | Chiều | Test tạo session, message, contract trích xuất requirement, payload lỗi, truy cập trái phép, state transition. | Kiểm thử | Integration test cho consultation | Thành viên B + C | 4.0 | D3-4 | Bộ test consultation | Các test quan trọng của consultation chạy pass | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D4-1 | 4.0 | Sáng | Lấy candidate service bằng hybrid search; gom chunk theo service; sinh rationale; lưu match + evidence chunk ID. | Service Matching | Matching engine có evidence | Thành viên C | 4.0 | D3-4 | Service matcher | Các scenario mẫu trả về đúng candidate service và evidence | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D4-2 | 4.0 | Sáng | Triển khai lọc role/visibility/status trước khi tạo prompt; chặn context restricted/không được phép và log lý do. | Guardrail | Pre-check guardrail | Thành viên B | 4.0 | D2-2,D4-1 | Lớp pre-check policy | Restricted chunk không bao giờ đi vào prompt của LLM trong test | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D4-3 | 4.0 | Sáng | Xây recommendation card, evidence viewer, service liên quan, selected-service state và no-match state. | Mobile Matching | UI kết quả match + chọn service | Thành viên A | 4.0 | D3-5 | UI service recommendation | User xem được rationale/evidence và chọn service | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D4-4 | 4.0 | Chiều | Yêu cầu structured recommendation output kèm evidence ID; kiểm tra chunk được trích dẫn tồn tại/được phép; reject capability/claim không có căn cứ. | Guardrail | Post-check grounding validation | Thành viên C | 4.0 | D4-1,D4-2 | Post-check validator | Recommendation thiếu căn cứ hoặc citation sai bị fail an toàn | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D4-5 | 4.0 | Chiều | Triển khai /matches và /service-selection; chỉ chuyển READY_FOR_MATCHING → MATCHING_SERVICE → SERVICE_RECOMMENDED khi match hợp lệ. | Tích hợp Backend | Matching API + workflow transition | Thành viên B | 4.0 | D4-1,D4-4 | Matching endpoint | State transition đúng workflow; transition sai trả domain error | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D4-6 | 4.0 | Chiều | Kết nối mobile với matching API, xử lý loading/fallback/no-match/needs-verification, sửa các contract lệch nhau. | Tích hợp | End-to-end consultation → matching | Cả team | 4.0 | D4-3,D4-5 | Luồng matching end-to-end | Phiên tư vấn mới đạt SERVICE_RECOMMENDED và hiển thị được evidence | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D5-1 | 5.0 | Sáng | Định nghĩa field bắt buộc, kiểm tra selected service/evidence, cảnh báo price/timeline/unverified item; triển khai readiness endpoint. | Backend Proposal | Proposal Readiness Validator | Thành viên B | 4.0 | D4-5 | Proposal readiness API | Không cho generate Proposal nếu deterministic readiness chưa đạt | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D5-2 | 5.0 | Sáng | Định nghĩa các section, source reference, assumptions/items_to_confirm; sinh structured Proposal JSON từ requirements + selected service + approved evidence. | AI Proposal | Proposal JSON schema + generation prompt | Thành viên C | 4.0 | D4-4,D5-1 | Proposal generation engine | Scenario mẫu tạo Proposal JSON đúng schema và có grounding | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D5-3 | 5.0 | Sáng | Xây readiness checklist, missing/warning display, chọn service level/option, thao tác tạo draft. | Mobile Proposal | Màn hình readiness + cấu hình Proposal | Thành viên A | 4.0 | D4-6,D5-1 | UI bắt đầu Proposal | User hiểu Proposal đã/chưa sẵn sàng và chỉ generate khi đủ điều kiện | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D5-4 | 5.0 | Chiều | Kiểm tra JSON schema, evidence reference, visibility/status, các claim không được phép về price/timeline/accuracy/ROI/capability. | Proposal Guardrail | Proposal validation pipeline | Thành viên C | 4.0 | D5-2 | Proposal post-check | Proposal không hợp lệ bị reject với lỗi validation rõ ràng | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D5-5 | 5.0 | Chiều | Tạo proposals/sections/evidence/validations; triển khai create/get/list/validate/submit-review endpoint và state transition. | Backend Proposal | Lưu Proposal + API | Thành viên B | 4.0 | D5-1,D5-2,D5-4 | Proposal REST API | Draft + section + evidence + validation result được lưu đúng | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D5-6 | 5.0 | Chiều | Xây tiến trình generate, validation summary, proposal preview, source reference và lịch sử draft. | Mobile Proposal | UI preview Proposal + kết quả validation | Thành viên A | 4.0 | D5-3,D5-5 | UI Proposal draft | Selected service → validated proposal draft hiển thị được trên mobile | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D6-1 | 6.0 | Sáng | Triển khai pending review, approve/request-changes endpoint, kiểm tra reviewer permission, review history và state transition. | Workflow Review | Human review + approval | Thành viên B | 4.0 | D5-5 | Review API | Chỉ role có PROPOSAL_APPROVE được approve; request changes quay về revision state | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D6-2 | 6.0 | Sáng | Ánh xạ validated Proposal JSON vào company DOCX template bằng docxtemplater/PizZip; render PDF qua LibreOffice headless; lưu metadata tài liệu. | Tài liệu | Render DOCX/PDF | Thành viên A + B | 4.0 | D5-5 | DOCX + PDF đã sinh | Proposal approved sinh được DOCX/PDF đọc đúng nội dung/version | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D6-3 | 6.0 | Sáng | Tạo golden set nhỏ: search query, consultation scenario, expected service/evidence, invalid claim case; ghi pass/fail. | Chất lượng AI | Bộ evaluation cho RAG / Proposal | Thành viên C | 4.0 | D5-4 | Checklist đánh giá AI | Các case retrieval/matching/guardrail cốt lõi đạt tiêu chí đã thống nhất | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D6-4 | 6.0 | Chiều | Xây review queue, validation summary, approve/request changes, approved proposal, tải/mở DOCX/PDF. | Mobile Review | Màn hình reviewer + tài liệu | Thành viên A | 4.0 | D6-1,D6-2 | UI review/tài liệu | Reviewer approve được và Sales truy cập được tài liệu sinh ra | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D6-5 | 6.0 | Chiều | API/màn hình protected để gán user-role, trigger/status cho service ingestion/re-index; không xây full admin dashboard. | Admin MVP | Chức năng Admin tối thiểu | Thành viên B | 4.0 | D6-1 | Admin capability tối thiểu | Admin đổi role và trigger re-index được; Sales không có quyền | P1 | Chưa bắt đầu | Chưa bắt đầu |
| D6-6 | 6.0 | Chiều | Log auth event, workflow transition, retrieval evidence ID, proposal generation/validation/review; thêm structured logging cơ bản. | Audit & Observability | Audit log + retrieval trace | Thành viên B + C | 4.0 | D4-5,D6-1 | Audit trail | Một scenario đầy đủ có thể truy vết từ consultation đến proposal approval | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D7-1 | 7.0 | Sáng | Chạy happy path và failure path: unauthorized, thiếu requirement, no match, restricted knowledge, validation fail, reviewer yêu cầu chỉnh sửa. | Kiểm thử | Full integration + E2E test | Thành viên A + B | 4.0 | D6-4,D6-6 | Kết quả E2E test | Tất cả luồng P0 pass; không còn blocker nghiêm trọng | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D7-2 | 7.0 | Sáng | Đánh giá golden set, chỉ tinh chỉnh chunk metadata/filter/ranking/prompt tại nơi phát hiện lỗi; đóng băng prompt/config version. | Chất lượng AI | Tinh chỉnh retrieval/LLM cuối | Thành viên C | 4.0 | D6-3 | AI config đã chốt | Kết quả golden set được ghi nhận; lỗi grounding/hallucination nghiêm trọng được xử lý | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D7-3 | 7.0 | Sáng | Kiểm tra secret/env, RBAC, input validation, rate limit cơ bản, quyền truy cập file, error response, migration/seed có thể chạy lại. | Hardening | Rà soát bảo mật/cấu hình | Thành viên B | 4.0 | D6-5 | Checklist hardening MVP | Không có secret trong repo; endpoint restricted bị chặn đúng; setup mới có thể tái lập | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D7-4 | 7.0 | Chiều | Deploy API + PostgreSQL/pgvector + storage; build bản mobile internal hoặc Expo internal distribution; cấu hình môi trường staging/production. | Triển khai | Deploy MVP | Thành viên A + B | 4.0 | D7-1,D7-3 | MVP đã deploy | Mobile kết nối deployed API và chạy được happy path | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D7-5 | 7.0 | Chiều | Chuẩn bị user role demo, customer scenario, expected S0112 match, proposal output; cập nhật README, setup, link architecture/API, known limitations. | Demo & tài liệu | Chuẩn bị demo scenario + handoff kỹ thuật | Thành viên A + C | 4.0 | D7-2,D7-4 | Bộ demo + tài liệu handoff | Demo 10 phút chạy từ đầu mà không cần sửa DB thủ công | P0 | Chưa bắt đầu | Chưa bắt đầu |
| D7-6 | 7.0 | Chiều | Chạy checklist nghiệm thu; chụp màn hình/tài liệu; phân loại issue còn lại thành P1/P2; tag bản phát hành MVP. | Nghiệm thu cuối | Checkpoint MVP và khóa backlog | Cả team | 4.0 | D7-4,D7-5 | Bản phát hành MVP v0.1 | Toàn bộ tiêu chí nghiệm thu cuối đạt hoặc các phần chưa đạt được ghi rõ là không chặn release | P0 | Chưa bắt đầu | Chưa bắt đầu |


---

# Bảng phân bổ tiến độ theo buổi

| Nhóm công việc | N1 Sáng | N1 Chiều | N2 Sáng | N2 Chiều | N3 Sáng | N3 Chiều | N4 Sáng | N4 Chiều | N5 Sáng | N5 Chiều | N6 Sáng | N6 Chiều | N7 Sáng | N7 Chiều |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Nghiên cứu & thống nhất | ● | ● |  |  |  |  |  |  |  |  |  |  |  |  |
| Khởi tạo dự án / Backend |  | ● | ● |  |  |  |  |  |  |  |  |  |  |  |
| Nạp dữ liệu tri thức |  | ● | ● | ● |  |  |  |  |  |  |  |  |  |  |
| Nền tảng Mobile / Knowledge |  |  | ● | ● |  |  |  |  |  |  |  |  |  |  |
| Consultation Workflow |  |  |  |  | ● | ● |  |  |  |  |  |  |  |  |
| Service Matching & Guardrail |  |  |  |  |  |  | ● | ● |  |  |  |  |  |  |
| Proposal Engine |  |  |  |  |  |  |  |  | ● | ● |  |  |  |  |
| Review / Tài liệu / Admin |  |  |  |  |  |  |  |  |  |  | ● | ● |  |  |
| Kiểm thử / Hardening |  |  |  |  |  |  |  |  |  |  |  |  | ● |  |
| Deploy / Demo |  |  |  |  |  |  |  |  |  |  |  |  |  | ● |


> **Ghi chú:** Checkpoint MVP theo ngày: N1 Nền tảng → N2 Tra cứu tri thức → N3 Consultation → N4 Matching → N5 Proposal → N6 Review/Tài liệu → N7 Phát hành

### Phân bổ khối lượng và rủi ro theo thành viên

| Thành viên | Giờ dự kiến | Trọng tâm | Rủi ro nếu bị chặn |
| --- | --- | --- | --- |
| Thành viên A | 56.0 | Mobile + tích hợp + tài liệu | Chặn tích hợp UI/demo |
| Thành viên B | 56.0 | Backend + DB + RBAC + workflow | Chặn API/state flow cốt lõi |
| Thành viên C | 56.0 | AI/data/retrieval/guardrail | Chặn chất lượng search/matching/proposal |

