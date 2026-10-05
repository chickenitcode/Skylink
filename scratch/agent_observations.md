# NHẬT KÝ QUAN SÁT TỨC THỜI CỦA AGENT (Agent Working Snapshot)
> **Mục đích**: Ghi lại minh bạch **chính xác những gì Agent vừa xem, vừa đọc, vừa chạy ngầm** ở thời điểm làm việc hiện tại, kèm **hiển thị rõ ràng dòng lệnh đã chạy, output nguyên văn và giải thích cặn kẽ từng dòng log** để Người Dùng vừa kiểm soát hệ thống, vừa học hỏi bản chất kỹ thuật (đặc biệt là các thao tác Git). Ghi đè snapshot mới sau mỗi chặng thao tác.

---

## 1. TÁC VỤ & LỆNH AGENT VỪA THỰC HIỆN (Behind-The-Scenes Actions & Commands)
- **Thời điểm**: `2026-10-05 13:37:00`
- **Mục tiêu chặng này**: 
  1. Tạo tệp `.gitattributes` chuẩn hóa Line Endings (CRLF vs LF) cho nhóm làm việc đa nền tảng (Thành viên dùng Windows + Thành viên dùng Ubuntu / Linux).
  2. Tạo tệp `.gitignore` toàn diện cho Monorepo: NestJS Backend (Thành viên B), Expo Mobile (Thành viên A), AI Pipeline (Thành viên C), loại bỏ rác hệ điều hành và bảo mật biến môi trường.
  3. Kiểm định toàn diện hệ thống bằng `.agents/scripts/verify_refactoring.ps1`.
- **Lệnh Terminal Agent đã chạy**:
  1. `powershell -ExecutionPolicy Bypass -File .agents/scripts/verify_refactoring.ps1` (Exit code: 0 - 100% PASSED)

---

## 2. NGUYÊN VĂN ĐẦU RA TERMINAL & BÓC TÁCH HỌC TẬP (Raw Output & Learning Breakdown)

### 2.1. Kiểm Định Toàn Hệ Thống `verify_refactoring.ps1`:
- **Đầu ra nguyên văn (Raw Output)**:
  ```text
  =================================================================
     KIEM TOAN TOAN DIEN HE THONG AGENT & PLUGINS (ANTIGRAVITY)    
  =================================================================
  1. KIEM TRA KHONG GIAN CUSTOMIZATION ROOT (.agents): [+] Hop le
  2. KIEM TRA BANG DIEU KHIEN PLUGINS.JSON: [+] Hop le
  3. KIEM TRA PLUGIN antigravity-system-updater: [+] Hop le (13/13 refs)
  3.8 KIEM TRA WORKSPACE SKILL: mermaid-architect: [+] Day du 4 thanh phan
  3.9 KIEM TRA WORKSPACE SKILL: e2e-demo-orchestrator: [+] Day du 4 thanh phan
  3.10 KIEM TRA CAC SKYLINK PLUGINS MO RONG: [+] 4/4 Plugins, 10/10 Skills day du 4 phan
  3.11 KIEM TRA QUY TAC QUAN TRI WORKSPACE: [+] 3/3 Rules hop le
  =================================================================
     KET QUA: 100% TAT CA CAC TIEU CHI KIEM TOAN DEU PASSED!       
  =================================================================
  ```
- **Bóc tách giải nghĩa cho người mới nhập môn Git & DevOps**:
  - `verify_refactoring.ps1` đóng vai trò là "Cổng gác chất lượng" (Quality Gate). Trước khi đưa mã nguồn lên Git, script này đảm bảo rằng toàn bộ các tài liệu, cấu hình plugin, thư viện kỹ năng và các tệp tham chiếu không bị mất mát hay gãy vỡ.

---

## 3. BẢN CHẤT KỸ THUẬT: TẠI SAO PHẢI CÓ `.GITATTRIBUTES` KHI CÓ THÀNH VIÊN DÙNG UBUNTU?

Khi một nhóm có thành viên code trên **Windows** (như Giáp hoặc Khang) và thành viên code trên **Ubuntu / Linux** (như Sơn):

### 1. Thảm họa Line Ending (CRLF vs LF):
- **Windows**: Dùng cặp ký tự `\r\n` (Carriage Return + Line Feed hay **CRLF**) để xuống dòng.
- **Ubuntu / Linux**: Dùng duy nhất `\n` (**LF**) để xuống dòng.
- **Hậu quả nếu KHÔNG có `.gitattributes`**:
  - Khi thành viên Windows gõ code rồi commit, file sẽ mang mã `CRLF`.
  - Thành viên Ubuntu kéo về (`git pull`), mở ra sửa 1 chữ rồi lưu: Git sẽ phát hiện **TOÀN BỘ CÁC DÒNG** trong file đều bị đổi mã xuống dòng. Lệnh `git diff` sẽ đỏ rực từ dòng đầu đến dòng cuối dù chỉ sửa 1 ký tự, gây xung đột mã (merge conflict) cực kỳ ức chế.
  - **Lỗi chí mạng với Shell Scripts (`*.sh`)**: Nếu file script `.sh` có mã `CRLF`, khi chạy trên Ubuntu terminal sẽ báo lỗi kinh điển:
    ```bash
    /bin/bash^M: bad interpreter: No such file or directory
    # Hoặc: syntax error near unexpected token $'\r'
    ```
    Bởi vì Linux không hiểu ký tự `^M` (`\r`) ẩn phía sau!
  - **Lỗi Docker Build trên Ubuntu**: Dockerfile hoặc entrypoint scripts bị dính CRLF sẽ khiến container Linux trên Ubuntu bị crash ngay khi khởi động.

### 2. Giải pháp triệt để trong `.gitattributes`:
- `* text=auto eol=lf`: Tự động nhận diện mọi tệp văn bản mã nguồn (`.ts`, `.tsx`, `.json`, `.md`, `.sql`...) và **ép chuẩn hóa thành LF khi commit vào Git repo**. Nhờ đó, cả thành viên Windows và Ubuntu đều commit chung một định dạng LF chuẩn quốc tế.
- `*.sh text eol=lf`: Cưỡng chế 100% shell scripts luôn mang mã LF dù được tạo hay sửa ở bất kỳ hệ điều hành nào.
- `*.bat`, `*.ps1 text eol=crlf`: Dành riêng cho Windows scripts.
- `*.png`, `*.pdf`, `*.docx binary`: Khai báo tệp nhị phân rõ ràng để Git **tuyệt đối không can thiệp** làm biến dạng cấu trúc nhị phân của tài liệu hay hình ảnh.

---

## 4. BẢN CHẤT KỸ THUẬT: CẤU TRÚC PHÒNG VỆ CỦA `.GITIGNORE`

Tệp `.gitignore` được phân chia thành 9 phân vùng bảo vệ:
1. **Dependencies (`node_modules/`, `.pnpm-store/`)**: Ngăn chặn đẩy hàng trăm nghìn tệp thư viện nặng hàng GB lên Git.
2. **Build Outputs (`dist/`, `build/`, `.turbo/`, `apps/api/dist/`)**: Không lưu mã nguồn đã biên dịch.
3. **Mobile Expo (`.expo/`, `apps/mobile/android/`, `*.apk`, `*.keystore`)**:
   - Bảo mật tuyệt đối các file keystore ký số phát hành app.
   - Bỏ qua cache Metro bundler và build native khi chạy local.
4. **Database & Docker (`postgres-data/`, `pgdata/`, `*.sqlite`, `~$*`)**:
   - Không commit dữ liệu database nhị phân của container PostgreSQL.
   - Bỏ qua các file khóa tạm thời của LibreOffice/Word (`~$*.docx`).
5. **Secrets & Credentials (`.env`, `.env.local`, `.env.*`)**:
   - Ngăn chặn 100% nguy cơ lộ API Key (Gemini API Key, JWT Secret, DB Password).
   - Chỉ giữ lại file mẫu `!*.env.example` và `!.env.template`.
6. **Hệ điều hành (Windows + Ubuntu + macOS)**:
   - Ubuntu: Bỏ qua `*~` (file backup của gedit/nano), `.fuse_hidden*`, `.Trash-*`.
   - Windows: Bỏ qua `Thumbs.db`, `Desktop.ini`, `$RECYCLE.BIN/`.
   - macOS: Bỏ qua `.DS_Store`.
7. **Kỷ luật Scratchpad (`scratch/`)**:
   - Tự động bỏ qua mọi script thử nghiệm tạm thời: `scratch/*.ps1`, `scratch/*.sh`, `scratch/*.tmp`.
   - Bảo toàn tài liệu sổ tay quan sát: `!scratch/agent_observations.md` và `!scratch/agent_observations.template.md`.
