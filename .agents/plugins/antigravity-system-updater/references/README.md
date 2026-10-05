# CẨM NANG HƯỚNG DẪN TRA CỨU TÀI LIỆU GỐC GOOGLE ANTIGRAVITY (SYSTEM REFERENCES)
> **Chứng thực nguồn gốc:** 100% tài liệu trong thư mục này được trích xuất nguyên văn (verbatim copy) từ bộ nhân cài đặt của Google DeepMind Antigravity tại `C:\Users\Admin\.gemini\antigravity-ide\builtin\skills\`.  
> Tệp này đóng vai trò là **Bản đồ chỉ dẫn tra cứu bằng tiếng Việt**: Giải thích cặn kẽ từng tệp là gì, chứa nội dung cốt lõi nào và khi nào bạn cần mở tệp đó ra đọc.

---

## ⚡ BẢNG TRA CỨU NHANH THEO NHU CẦU THỰC TẾ

| Bạn đang muốn làm gì? | Tệp bắt buộc phải đọc | Đường dẫn truy cập nhanh |
| :--- | :--- | :--- |
| **Muốn hiểu cách viết Skill chuẩn Antigravity** | Quy chuẩn cấu trúc thư mục, Frontmatter và 4 Best Practices | 👉 **[docs/skills.md](./agy-customizations/docs/skills.md)** |
| **Muốn viết Rule cho dự án (`AGENTS.md` / `GEMINI.md`)** | Quy chuẩn viết Rule, cơ chế walk-up và cấm Frontmatter | 👉 **[docs/rules.md](./agy-customizations/docs/rules.md)** |
| **Muốn tự động hóa script nhắc nhở / chặn lệnh** | Cấu hình Lifecycle Hooks, 5 loại sự kiện, chuẩn I/O stdin/stdout | 👉 **[docs/hooks.md](./agy-customizations/docs/hooks.md)** |
| **Muốn hiểu thứ tự ưu tiên khi trùng tên skill/rule** | Thứ tự quét (Discovery) và mức ưu tiên nạp (Precedence) | 👉 **[agy-customizations/SKILL.md](./agy-customizations/SKILL.md)** |
| **Muốn đóng gói chia sẻ cho đồng nghiệp / dự án khác** | Quy chuẩn đóng gói Plugin (`plugin.json`) gom mọi thứ | 👉 **[docs/plugins.md](./agy-customizations/docs/plugins.md)** |
| **Muốn kết nối công cụ ngoài / Database / API** | Quy chuẩn cấu hình Model Context Protocol (MCP) | 👉 **[docs/mcp_servers.md](./agy-customizations/docs/mcp_servers.md)** |
| **Muốn chia sẻ Skill dùng chung qua Git của công ty** | Cấu hình kế thừa `skills.json` và phân giải đường dẫn | 👉 **[docs/json_configs.md](./agy-customizations/docs/json_configs.md)** |
| **Muốn tận dụng tối đa các tính năng của Antigravity IDE** | Hướng dẫn 3 chế độ tương tác AI (Tab, `Ctrl+I`, Sidebar Agent) | 👉 **[references/ide.md](./antigravity_guide/references/ide.md)** |
| **Muốn dùng ứng dụng Antigravity 2.0 Desktop độc lập** | Quản lý Chat Canvas, Tasks ngầm, Artifacts, phân quyền | 👉 **[references/app.md](./antigravity_guide/references/app.md)** |
| **Muốn dùng Antigravity trên Terminal (giao diện dòng lệnh)** | Hướng dẫn lệnh `agy` CLI, phím tắt Slash Commands | 👉 **[references/cli.md](./antigravity_guide/references/cli.md)** |
| **Muốn viết code Python để gọi Agent tự động** | Hướng dẫn lập trình mở rộng qua Python SDK chính thức | 👉 **[references/sdk.md](./antigravity_guide/references/sdk.md)** |
| **Muốn phân quyền cho Agent tương tác Git / GitHub** | Mẫu phân quyền bảo mật lệnh `gh` CLI và `git` | 👉 **[permissioned-github/SKILL.md](./permissioned-github/SKILL.md)** |

---

## 📖 MỤC LỤC CHI TIẾT TỪNG TỆP TÀI LIỆU

### PHẦN 1: PHÂN HỆ TÙY BIẾN AGENT (ANTIGRAVITY CUSTOMIZATION SYSTEM)
*Nằm trong thư mục `agy-customizations/` — Đây là phần quan trọng nhất để bạn xây dựng hệ thống `.agents/` chuẩn mực.*

---

#### 1. [agy-customizations/SKILL.md](./agy-customizations/SKILL.md) — Tổng Quan Hệ Thống Tùy Biến
- **Tệp này là gì?**: Bản thiết kế tổng thể (Master Guide) giải thích cơ chế Agent tự nhận diện và nạp các thành phần mở rộng.
- **Khi nào cần đọc?**:
  - Khi cần biết Antigravity quét tìm file ở đâu (Workspace `.agents/` $\rightarrow$ Thư mục phân cấp $\rightarrow$ Cấu hình toàn cục `~/.gemini/config/`).
  - Khi muốn biết khi nào một cấu hình bị ghi đè (Thứ tự ưu tiên 5 cấp từ Workspace đến Built-in).
  - Khi cần hiểu nguyên lý **Tiết lộ lũy tiến (Progressive Disclosure)**: Vì sao chỉ nạp `name` + `description` vào context trước mà không nạp toàn bộ file.

---

#### 2. [agy-customizations/docs/rules.md](./agy-customizations/docs/rules.md) — Quy Chuẩn Workspace Rules (`GEMINI.md` & `AGENTS.md`)
- **Tệp này là gì?**: Tài liệu gốc định nghĩa cách hoạt động của hệ thống Quy tắc cấp thư mục.
- **Khi nào cần đọc?**:
  - Khi bạn bắt tay vào viết hoặc sửa file `AGENTS.md` và `GEMINI.md`.
  - **Điểm mấu chốt**: Rules **tuyệt đối không được dùng YAML Frontmatter**, luôn luôn ở trạng thái kích hoạt (**Always Active**) cho thư mục chứa nó và mọi thư mục con; hệ thống tự động khử trùng lặp (Deduplication) khi nạp.

---

#### 3. [agy-customizations/docs/skills.md](./agy-customizations/docs/skills.md) — Quy Chuẩn Workspace Skills (`SKILL.md`)
- **Tệp này là gì?**: Hướng dẫn chính thức về cách đóng gói một Kỹ năng nghiệp vụ (Skill) cho Agent.
- **Khi nào cần đọc?**:
  - Khi bạn thiết kế các trạm kỹ năng Data Science (`ds-01`, `ds-02`...).
  - **Điểm mấu chốt**:
    1. Cấu trúc thư mục chuẩn: `SKILL.md` (bắt buộc) đi kèm các thư mục con tùy chọn `scripts/`, `examples/`, `resources/`, `references/`.
    2. Frontmatter YAML bắt buộc phải có `name` (chữ thường gạch ngang) và `description` (ngôi thứ ba, nêu rõ khi nào kích hoạt).
    3. **4 Nguyên tắc vàng**: Progressive Disclosure (giữ SKILL.md ngắn gọn, đẩy tài liệu dày vào `references/`), Executable Helpers (đóng gói lệnh vào `scripts/`), Validation Steps (chỉ dẫn Agent tự kiểm tra kết quả), No Duplication (không lặp lại kiến thức cơ bản).

---

#### 4. [agy-customizations/docs/hooks.md](./agy-customizations/docs/hooks.md) — Quy Chuẩn Vòng Đời Sự Kiện (`hooks.json`)
- **Tệp này là gì?**: Quy chuẩn kỹ thuật chi tiết nhất về cách cấu hình Lifecycle Hooks để chặn lệnh, nhắc nhở hoặc kiểm tra code tự động.
- **Khi nào cần đọc?**:
  - Khi bạn muốn viết các script bảo vệ như `guardrail_reminder.py` hoặc linter tự động.
  - **Điểm mấu chốt**:
    - 5 sự kiện: `PreToolUse` (trước khi gọi tool), `PostToolUse` (sau khi gọi tool), `PreInvocation` (trước khi model suy luận), `PostInvocation` (sau khi tool chạy xong), `Stop` (khi agent định dừng).
    - Hợp đồng I/O nghiêm ngặt: Nhận JSON qua `stdin` (chứa conversationId, workspacePaths...) và xuất JSON ra `stdout` (chứa `injectSteps`, `ephemeralMessage`, hoặc `decision`).

---

#### 5. [agy-customizations/docs/plugins.md](./agy-customizations/docs/plugins.md) — Quy Chuẩn Gói Mở Rộng Plugin (`plugin.json`)
- **Tệp này là gì?**: Hướng dẫn cách đóng gói Skills, Rules, Hooks và MCP Server vào một đơn vị phân phối duy nhất.
- **Khi nào cần đọc?**:
  - Khi bạn muốn gom toàn bộ bộ công cụ (như `data-science-core`) để đem sang máy khác hoặc chia sẻ cho team dùng chung.
  - Hiểu cách Antigravity tự động cô lập không gian tên (Namespacing) để tránh xung đột giữa các plugin.

---

#### 6. [agy-customizations/docs/mcp_servers.md](./agy-customizations/docs/mcp_servers.md) — Giao Thức Kết Nối Công Cụ Ngoài (`mcp_config.json`)
- **Tệp này là gì?**: Hướng dẫn cấu hình Model Context Protocol (MCP) cho Antigravity.
- **Khi nào cần đọc?**:
  - Khi bạn muốn Agent kết nối với cơ sở dữ liệu (SQLite, Postgres), công cụ tìm kiếm, hoặc các API dịch vụ bên ngoài.
  - Hiểu 2 cơ chế truyền tải: **Stdio** (chạy process nhị phân cục bộ trên máy) và **SSE** (kết nối máy chủ từ xa qua giao thức HTTP Server-Sent Events).

---

#### 7. [agy-customizations/docs/json_configs.md](./agy-customizations/docs/json_configs.md) — Quản Trị Cấu Hình Nâng Cao (`skills.json` & `plugins.json`)
- **Tệp này là gì?**: Hướng dẫn khai báo các file JSON để nạp kỹ năng nằm ngoài thư mục mặc định.
- **Khi nào cần đọc?**:
  - Khi công ty bạn có một kho kỹ năng chung trên Git (`tools/agents/skills/`) và bạn muốn mọi lập trình viên khi clone repo về máy đều tự động nạp các kỹ năng đó.
  - Hiểu quy tắc phân giải đường dẫn: Tuyệt đối (`/`), Relative với thư mục Home (`~/`), và Relative với gốc dự án Git.

---

### PHẦN 2: PHÂN HỆ NỀN TẢNG & ỨNG DỤNG (ANTIGRAVITY PLATFORM & SURFACES)
*Nằm trong thư mục `antigravity_guide/` — Dành cho việc làm chủ môi trường làm việc và các công cụ lập trình của Google.*

---

#### 8. [antigravity_guide/SKILL.md](./antigravity_guide/SKILL.md) — Sitemap Tổng Thể & Live Docs
- **Tệp này là gì?**: Sơ đồ điều phối toàn bộ các bề mặt làm việc của Antigravity và danh mục 11 đường link tra cứu tài liệu trực tuyến chính thức từ DeepMind.
- **Khi nào cần đọc?**: Khi cần tìm kiếm tài liệu cập nhật mới nhất về Vertex AI, Sidecars, Browser Testing hoặc gửi phản hồi hỗ trợ kỹ thuật.

---

#### 9. [antigravity_guide/references/ide.md](./antigravity_guide/references/ide.md) — Cẩm Nang Antigravity IDE (VS Code Fork)
- **Tệp này là gì?**: Hướng dẫn chi tiết cách khai thác tối đa giao diện IDE tích hợp sẵn AI.
- **Khi nào cần đọc?**:
  - Khi cần làm chủ phím tắt: Nhấn `Tab` để Autocomplete / Supercomplete / Nhảy điểm cursor; nhấn `Ctrl+I` để kích hoạt lệnh sửa code cục bộ ngay tại chỗ.
  - Hiểu cơ chế hoạt động của Sidebar Chat, Agent Mode và chế độ lập kế hoạch (Planning Mode).

---

#### 10. [antigravity_guide/references/app.md](./antigravity_guide/references/app.md) — Cẩm Nang Ứng Dụng Độc Lập Antigravity 2.0
- **Tệp này là gì?**: Hướng dẫn sử dụng phần mềm desktop Electron Antigravity 2.0 độc lập.
- **Khi nào cần đọc?**:
  - Khi bạn sử dụng giao diện Chat Canvas độc lập ngoài trình soạn thảo.
  - Cần quản lý các tác vụ hẹn giờ (Cron / Delayed Tasks), phân quyền truy cập file ngoài workspace, chính sách thực thi terminal (Sandbox, Always Proceed, Request Review).

---

#### 11. [antigravity_guide/references/cli.md](./antigravity_guide/references/cli.md) — Cẩm Nang Giao Diện Dòng Lệnh `agy` CLI
- **Tệp này là gì?**: Hướng dẫn chạy Agent trực tiếp từ Terminal thông qua lệnh `agy`.
- **Khi nào cần đọc?**:
  - Khi làm việc trên máy chủ Linux từ xa không có màn hình GUI, hoặc muốn chạy Agent siêu nhẹ qua cửa sổ dòng lệnh PowerShell/Bash.
  - Tra cứu các phím tắt Slash Commands trong môi trường dòng lệnh (`/help`, `/exit`, cấu hình `settings.json`).

---

#### 12. [antigravity_guide/references/sdk.md](./antigravity_guide/references/sdk.md) — Sổ Tay Lập Trình Python SDK (`google-antigravity`)
- **Tệp này là gì?**: Hướng dẫn dùng thư viện Python chính thức để lập trình và điều phối Agent bằng mã nguồn.
- **Khi nào cần đọc?**:
  - Khi bạn muốn viết một script Python tự động khởi tạo Agent, stream câu trả lời theo thời gian thực (real-time tokens), hoặc theo dõi quá trình suy luận ngầm (`response.thoughts`).
  - Tích hợp Agent vào các pipeline kiểm thử phần mềm tự động (CI/CD).

---

### PHẦN 3: PHÂN HỆ BẢO MẬT & PHÂN QUYỀN GITHUB (SECURITY & PERMISSIONS)
*Nằm trong thư mục `permissioned-github/` — Mẫu hình chuẩn mực về phân quyền tương tác hệ thống.*

---

#### 13. [permissioned-github/SKILL.md](./permissioned-github/SKILL.md) — Hướng Dẫn Tương Tác An Toàn với GitHub
- **Tệp này là gì?**: Skill mẫu chính thức của DeepMind hướng dẫn Agent cách sử dụng lệnh `gh` CLI và `git` đúng thẩm quyền.
- **Khi nào cần đọc?**:
  - Khi cần tham khảo cách viết một Skill mang tính chất bảo mật cao.
  - Hiểu cấu trúc chuỗi xin quyền người dùng dạng chuẩn: `<command>.<action>(<resource_json>)` (ví dụ: `git.read({"org": "...", "branch": "*"})`).
