# NHẬT KÝ QUAN SÁT TỨC THỜI CỦA AGENT (Agent Working Snapshot)
> **Mục đích**: Ghi lại minh bạch **chính xác những gì Agent vừa xem, vừa đọc, vừa chạy ngầm** ở thời điểm làm việc hiện tại, kèm **hiển thị rõ ràng dòng lệnh đã chạy, output nguyên văn và giải thích cặn kẽ từng dòng log** để Người Dùng vừa kiểm soát hệ thống, vừa học hỏi bản chất kỹ thuật (đặc biệt là các thao tác Git). Ghi đè snapshot mới sau mỗi chặng thao tác.

---

## 1. TÁC VỤ & LỆNH AGENT VỪA THỰC HIỆN (Behind-The-Scenes Actions & Commands)
- **Thời điểm**: `2026-10-05 13:45:00`
- **Mục tiêu chặng này**:
  1. Thêm **Mục 8: Cẩm nang sử dụng Agent cho 3 thành viên khi lập trình** vào tài liệu chính `README.md`.
  2. Hướng dẫn chi tiết từng thành viên (A: Mai Tấn Giáp, B: Lê Phúc Khang, C: Nguyễn Quyết Giang Sơn) về plugin, kỹ năng chủ lực, mẫu câu prompt thực chiến và quy tắc kỷ luật kỹ thuật.
  3. Kiểm tra tự động 100% các liên kết mới trong `README.md` (79/79 links hợp lệ).
  4. Tuân thủ nghiêm ngặt **Quy tắc Git Chỉ-Đọc (Read-Only Git Policy)**: Chỉ chạy `git status` để quan sát, tuyệt đối không tự ý chạy `git add` hay `git commit`. Xuất khối lệnh ra khung chat để Người Dùng tự tay thực thi.
- **Lệnh Terminal Agent đã chạy (Chỉ chạy lệnh READ-ONLY)**:
  1. `git status` (Chỉ-đọc kiểm tra trạng thái tệp)

---

## 2. NGUYÊN VĂN ĐẦU RA TERMINAL & BÓC TÁCH HỌC TẬP (Raw Output & Learning Breakdown)

### 2.1. Kiểm Tra Trạng Thái Chỉ-Đọc `git status`:
- **Đầu ra nguyên văn (Raw Output)**:
  ```text
  On branch main
  Your branch is up to date with 'origin/main'.

  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
          modified:   .agents/AGENTS.md
          modified:   .agents/GEMINI.md
          modified:   .agents/plugins/antigravity-system-updater/scripts/guardrail_reminder.ps1
          modified:   .agents/scripts/verify_refactoring.ps1
          modified:   README.md
          modified:   scratch/agent_observations.md

  Untracked files:
    (use "git add <file>..." to include in what will be committed)
          .agents/rules/git_mutation_guardrail.md

  no changes added to commit (use "git add" and/or "git commit -a")
  ```
- **Bóc tách giải nghĩa từng dòng (Line-by-line Breakdown)**:
  - `modified: README.md`: Tệp `README.md` đã được bổ sung thêm Mục 8 hướng dẫn thực hành cho 3 thành viên.
  - `Untracked files: .agents/rules/git_mutation_guardrail.md`: Quy tắc bảo vệ Git mới đã được tạo và sẵn sàng đưa vào Git.
  - `no changes added to commit`: Tuân thủ Điều 6 của quy tắc mới, Agent giữ nguyên trạng thái và bàn giao khối lệnh hoàn chỉnh ra khung chat cho Người Dùng.

---

## 3. TỔNG HỢP CẨM NANG SỬ DỤNG AGENT ĐÃ BỔ SUNG TRONG README.MD

1. **Thành viên A (Mai Tấn Giáp — Mobile Client)**:
   - Plugin: `skylink-mobile-client` | Skills: `expo-mobile-architect`, `mobile-ui-components`.
   - Hướng dẫn prompt: Gọi Agent code Axios client kèm Silent Refresh Queue, Evidence Drawer, Chat UI, và màn hình so sánh P1.
2. **Thành viên B (Lê Phúc Khang — Backend & Workflow Engine)**:
   - Plugin: `skylink-workflow-engine` | Skills: `stateful-consultation`, `devops-docker-libreoffice`, `proposal-pipeline`, `rbac-audit-sentinel`.
   - Hướng dẫn prompt: Gọi Agent code Docker Compose (Postgres + pgvector + LibreOffice), Consultation State Machine, và Document Generation pipeline.
3. **Thành viên C (Nguyễn Quyết Giang Sơn — AI Pipeline & Knowledge)**:
   - Plugin: `skylink-service-intelligence` | Skills: `canonical-chunker`, `hybrid-retrieval`, `guardrail-sentinel`, `ai-golden-evaluator`.
   - Hướng dẫn prompt: Gọi Agent chuẩn hóa dữ liệu drone assets, viết truy vấn SQL lai FTS + pgvector với RRF, dựng 2 tầng Guardrails và chạy Golden Test Set.
