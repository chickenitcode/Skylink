# QUY TẮC PHÒNG VỆ THAO TÁC GIT & GITHUB (READ-ONLY GIT POLICY)

> **Mã quy tắc**: `RULE-GIT-READONLY-01`  
> **Áp dụng**: Toàn bộ phiên làm việc của AI Agent (Antigravity / Google Gemini)  
> **Cấp độ**: BẮT BUỘC TUÂN THỦ TUYỆT ĐỐI (NON-NEGOTIABLE GUARDRAIL)

---

## 1. NGUYÊN TẮC CỐT LÕI: QUYỀN KIỂM SOÁT THUỘC VỀ NGƯỜI DÙNG

Trong môi trường làm việc chuyên nghiệp và dự án thực tập doanh nghiệp:
1. **Mã nguồn và lịch sử Git là tài sản tối cao của Người Dùng**: Mọi thao tác ghi dấu lịch sử (`commit`), đưa mã nguồn lên mạng (`push`), hay thay đổi trạng thái cây thư mục (`add`, `reset`) phải luôn nằm dưới quyền kiểm soát ý thức 100% của Người Dùng.
2. **Loại bỏ hoàn toàn rủi ro Agent tự tung tự tác**: Tránh tình trạng Agent vô tình commit nhầm file nhạy cảm, commit đè lên commit của người khác, hoặc push code chưa kiểm chứng gây hỏng nhánh chung của nhóm.

---

## 2. DANH MỤC LỆNH BỊ CẤM TUYỆT ĐỐI AGENT TỰ Ý CHẠY (STRICTLY PROHIBITED)

Agent **CẤM TUYỆT ĐỐI** tự ý thực thi các lệnh sau đây qua công cụ terminal (`run_command`):

| Nhóm Thao Tác | Các Lệnh Bị Cấm Tuyệt Đối | Lý Do & Rủi Ro |
| :--- | :--- | :--- |
| **Ghi vết & Đóng gói** | `git add`, `git commit`, `git commit -a`, `git commit --amend` | Nguy cơ đóng gói nhầm file rác, file nhạy cảm (`.env`), hoặc đè commit message. |
| **Đẩy & Kéo mã nguồn** | `git push`, `git push -f`, `git pull`, `git fetch` | Nguy cơ phá vỡ nhánh từ xa (`remote origin`), xung đột code không báo trước. |
| **Hủy hoại & Khôi phục** | `git reset`, `git revert`, `git restore`, `git clean` | Nguy cơ mất vĩnh viễn code đang viết dở của Người Dùng trong working tree. |
| **Nhánh & Hợp nhất** | `git branch -d`, `git branch -D`, `git merge`, `git rebase` | Nguy cơ xóa nhầm nhánh tính năng, xung đột mã nguồn diện rộng. |

---

## 3. QUY TRÌNH CHUẨN KHI CẦN COMMIT HOẶC PUSH CODE

Khi hoàn thành một tác vụ và cần lưu lại lịch sử mã nguồn, Agent **BẮT BUỘC** phải tuân theo quy trình 3 bước sau:

### Bước 1: Chỉ chạy lệnh Kiểm tra Trạng thái (Read-Only)
- Agent chỉ được phép chạy: `git status` hoặc `git diff --stat` để kiểm tra danh sách file đã thay đổi.
- Cập nhật giải thích minh bạch vào `scratch/agent_observations.md`.

### Bước 2: Soạn thảo thông điệp Commit chuẩn mực
- Soạn thông điệp commit theo chuẩn **Conventional Commits**:
  - `feat: ...` (Tính năng mới)
  - `fix: ...` (Sửa lỗi)
  - `docs: ...` (Tài liệu)
  - `refactor: ...` (Tái cấu trúc không đổi logic)
  - `test: ...` (Kiểm thử)
  - `chore: ...` (Cấu hình hệ thống, dependencies)

### Bước 3: Đưa khối lệnh ra khung Chat để Người Dùng TỰ TAY THỰC THI
- Trình bày rõ ràng khối lệnh trong phản hồi chat, giải thích ngắn gọn mục đích từng lệnh.
- **Để Người Dùng tự copy và tự chạy trên terminal của họ**.

*Ví dụ mẫu phản hồi của Agent:*
> "Tôi đã hoàn thành việc tạo tính năng X. Để lưu lại thay đổi vào Git, bạn hãy chạy các lệnh sau trên terminal của mình:
> ```bash
> git add <danh_sach_file>
> git commit -m "feat: mo ta ngan gon"
> git push origin main
> ```"

---

## 4. CÁC LỆNH CHỈ-ĐỌC ĐƯỢC PHÉP CHẠY (PERMITTED READ-ONLY COMMANDS)

Agent chỉ được phép chạy các lệnh đọc trạng thái không làm thay đổi dữ liệu:
- `git status`: Xem trạng thái tệp (đã sửa, chưa theo dõi).
- `git log`: Xem lịch sử các commit gần nhất.
- `git diff`: So sánh điểm khác biệt của mã nguồn.
- `git branch`: Liệt kê danh sách các nhánh cục bộ (không kèm cờ xóa `-d` hay `-D`).
- `git remote -v`: Xem cấu hình địa chỉ kho chứa từ xa.

*Lưu ý: Mọi kết quả từ các lệnh chỉ-đọc trên đều phải tuân thủ kỷ luật minh bạch, giải nghĩa cho người mới tại `scratch/agent_observations.md`.*
