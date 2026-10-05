# CHỈ DẪN HỆ THỐNG CHO GOOGLE GEMINI (GEMINI.md)

Chào mừng bạn đến với không gian làm việc **GASCOLAE SkyLink** (CT Group Intern Project 2026).  
Toàn bộ quy tắc cốt lõi, vai trò Persona và kiến trúc Plugin của dự án được định nghĩa chi tiết tại:  
👉 [AGENTS.md](./AGENTS.md) | [plugins.json](./plugins.json)

---

## 1. PHÂN CÔNG TRÁCH NHIỆM 3 THÀNH VIÊN & HỆ SINH THÁI AGENT

Hệ thống Agent được thiết kế bám sát 3 trục năng lực kỹ thuật của 3 thành viên thực tập sinh:

| Thành Viên | Họ Tên | Trục Trách Nhiệm Kỹ Thuật | Plugin Phụ Trách | Kỹ Năng Cốt Lõi (Skills) |
| :---: | :--- | :--- | :--- | :--- |
| **Thành viên A** | **Mai Tấn Giáp** (56h) | **Mobile Client (Expo / React Native)**<br/>• SecureStore Token & Silent Refresh Queue<br/>• TanStack Query & Chat UI Consultation<br/>• Missing-Info Form, Evidence Drawer & Comparison UI<br/>• Preview Proposal & Native PDF Viewer | [`skylink-mobile-client`](./plugins/skylink-mobile-client/plugin.json) | • [`expo-mobile-architect`](./plugins/skylink-mobile-client/skills/expo-mobile-architect/SKILL.md)<br/>• [`mobile-ui-components`](./plugins/skylink-mobile-client/skills/mobile-ui-components/SKILL.md) |
| **Thành viên B** | **Lê Phúc Khang** (56h) | **Backend Gateway & Workflow Engine**<br/>• Kiến trúc NestJS, PostgreSQL 16 & Prisma<br/>• Xác thực JWT, Silent Refresh & RBAC 11 quyền<br/>• Quản trị Máy trạng thái tư vấn (Stateful Consultation)<br/>• Pipeline sinh DOCX (docxtemplater) & PDF (LibreOffice worker)<br/>• Structured Logging & Vết kiểm toán (Audit Telemetry) | [`skylink-workflow-engine`](./plugins/skylink-workflow-engine/plugin.json) | • [`stateful-consultation`](./plugins/skylink-workflow-engine/skills/stateful-consultation/SKILL.md)<br/>• [`proposal-pipeline`](./plugins/skylink-workflow-engine/skills/proposal-pipeline/SKILL.md)<br/>• [`devops-docker-libreoffice`](./plugins/skylink-workflow-engine/skills/devops-docker-libreoffice/SKILL.md)<br/>• [`rbac-audit-sentinel`](./plugins/skylink-workflow-engine/skills/rbac-audit-sentinel/SKILL.md) |
| **Thành viên C** | **Nguyễn Quyết Giang Sơn** (56h) | **AI Intelligence & Knowledge Pipeline**<br/>• Chuẩn hóa dữ liệu Service Assets mô hình Canonical 5 cấp<br/>• Schema-Aware Semantic Chunking & băm `chunk_id`<br/>• Hybrid Retrieval: FTS (`tsvector`) + Dense Vector (`pgvector`) với RRF<br/>• Prompt Engineering Zod Structured Output (Gemini LLM)<br/>• 2 Tầng Guardrails (Pre-check Policy & Post-check Citation)<br/>• AI Golden Test Set & Định lượng ảo giác | [`skylink-service-intelligence`](./plugins/skylink-service-intelligence/plugin.json) | • [`canonical-chunker`](./plugins/skylink-service-intelligence/skills/canonical-chunker/SKILL.md)<br/>• [`hybrid-retrieval`](./plugins/skylink-service-intelligence/skills/hybrid-retrieval/SKILL.md)<br/>• [`guardrail-sentinel`](./plugins/skylink-service-intelligence/skills/guardrail-sentinel/SKILL.md)<br/>• [`ai-golden-evaluator`](./plugins/skylink-service-intelligence/skills/ai-golden-evaluator/SKILL.md) |

---

## 2. KỸ NĂNG DÙNG CHUNG & PLUGIN BẢO TRÌ HỆ THỐNG

1. **Workspace Skills (Kỹ năng dùng chung)**:
   - [`mermaid-architect`](./skills/mermaid-architect/SKILL.md): Thiết kế biểu đồ chuẩn Mermaid Horizontal-First.
   - [`e2e-demo-orchestrator`](./skills/e2e-demo-orchestrator/SKILL.md): Điều phối kịch bản kiểm thử End-to-End và diễn tập Demo 10 phút.
2. **Plugin Bảo trì Hệ thống**:
   - [`antigravity-system-updater`](./plugins/antigravity-system-updater/plugin.json): Quét hash SHA-256 đối chiếu IDE Antigravity và bảo toàn 13 tệp tri thức tham chiếu gốc tại [`references/`](./plugins/antigravity-system-updater/references/README.md).

---

## 3. CÁC QUY TẮC BẮT BUỘC KHI PHÁT TRIỂN (WORKSPACE RULES)

Khi hỗ trợ lập trình và phân tích mã nguồn, Gemini bắt buộc phải tuân thủ 5 quy tắc kỹ thuật cấp workspace:
1. [`skylink_monorepo.md`](./rules/skylink_monorepo.md): Chuẩn cấu trúc Monorepo, TypeScript Strict (`no any`), Zod DTO giao tiếp chuẩn.
2. [`security_data_sanitization.md`](./rules/security_data_sanitization.md): Chống rò rỉ dữ liệu `restricted`, ẩn điểm vector thô trên Mobile.
3. [`proposal_legal_compliance.md`](./rules/proposal_legal_compliance.md): Điều khoản miễn trừ pháp lý bắt buộc & cách ly số liệu chưa kiểm chứng vào `items_to_confirm`.
4. [`git_mutation_guardrail.md`](./rules/git_mutation_guardrail.md): Cấm Agent tự ý chạy các lệnh biến đổi Git/GitHub (`add`, `commit`, `push`...). Mọi thao tác ghi Git phải đưa ra khung chat để Người Dùng tự tay thực hiện.
5. [`mermaid_output_discipline.md`](./rules/mermaid_output_discipline.md): Cấm vẽ Mermaid trực tiếp trong khung chat (chỉ vẽ khi ghi vào tệp tài liệu Markdown `.md`).


👉 **Hợp đồng dữ liệu liên module**: Tham khảo trực tiếp tại [docs/spec/README.md](../docs/spec/README.md).
