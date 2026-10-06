# QUY TẮC KỶ LUẬT XUẤT SƠ ĐỒ MERMAID (MERMAID OUTPUT DISCIPLINE)

> **Mã quy tắc**: `RULE-MERMAID-OUTPUT`  
> **Phạm vi áp dụng**: Toàn bộ các tương tác của Agent trong dự án CT Group Intern Project (GASCOLAE SkyLink).  
> **Căn cứ yêu cầu**: Khung chat trực tiếp không hỗ trợ render khối mã Mermaid, hiển thị raw code gây rối mắt và làm giảm trải nghiệm người dùng.

---

## 1. NGUYÊN TẮC CẤM XUẤT MERMAID TRONG KHUNG CHAT (NO MERMAID IN CHAT)

1. **CẤM TUYỆT ĐỐI**: Không bao giờ vẽ hoặc chèn các khối mã ` ```mermaid ` trực tiếp vào nội dung tin nhắn phản hồi trong khung chat giữa Agent và Người Dùng.
2. **HÌNH THỨC THAY THẾ TRONG KHUNG CHAT**:
   - Khi cần giải thích kiến trúc hoặc luồng xử lý trong chat, Agent sử dụng:
     - **Bảng Markdown (Tables)**: Trực quan, so sánh rõ ràng giữa các thực thể.
     - **Danh sách có cấu trúc (Bullet points / Numbered lists)**: Mô tả các bước tuần tự.
     - **Sơ đồ văn bản ASCII / Mũi tên đơn giản**: Ví dụ `Client -> Gateway -> State Machine -> LLM`.

---

## 2. CHỈ ĐƯỢC PHÉP VẼ MERMAID KHI GHI VÀO TỆP TÀI LIỆU MARKDOWN (`.md`)

1. **VÙNG ĐƯỢC PHÉP ÁP DỤNG**:
   - Agent **CHỈ ĐƯỢC PHÉP** vẽ khối mã ` ```mermaid ` khi thực hiện thao tác tạo mới hoặc chỉnh sửa nội dung bên trong các tệp tài liệu Markdown chính thức:
     - Các tệp tài liệu kiến trúc và đặc tả trong `docs/` (ví dụ `docs/GASCOLAE_Kien_Truc_He_Thong_Mermaid.md`, `docs/spec/*.md`).
     - Các tệp báo cáo tiến độ và nghiên cứu trong `reports/` (ví dụ `reports/day-01/*.md`).
     - Tệp hướng dẫn `README.md`.
     - Tệp sổ tay quan sát minh bạch `scratch/agent_observations.md`.
2. **QUY CHUẨN KHI GHI VÀO TỆP MARKDOWN**:
   - Bắt buộc tuân thủ kỹ năng [`mermaid-architect`](../skills/mermaid-architect/SKILL.md): Safe Label Quoting (bọc nháy kép nhãn có ký tự đặc biệt), bố cục cân đối (tránh dàn ngang quá 5 node trên 1 hàng để tránh bị nén bẹp trong preview).
3. **QUY ĐỊNH VẼ SƠ ĐỒ GIT TRONG `agent_observations.md` (LINH HOẠT THEO NGỮ CẢNH)**:
   - **CẤM RẬP KHUÔN CỐ ĐỊNH**: Tuyệt đối không vẽ cứng nhắc một sơ đồ 4 trạm tĩnh cho mọi trường hợp.
   - **Đa dạng hóa theo bản chất thao tác Git**:
     * *Khi thao tác Nhánh (Branch / Rename / Delete Remote)*: Dùng `gitGraph` hoặc Flowchart cấu trúc nhánh thể hiện topology nhánh cục bộ vs remote và vị trí con trỏ HEAD.
     * *Khi thao tác Staging & Commit (`git add`, `git commit`, `git push`)*: Dùng sơ đồ luồng 4 trạm `Working Directory → Staging Area → Local Repository → Remote Repository`.
     * *Khi kiểm tra Trạng thái (`git status`, `git diff`)*: Dùng sơ đồ trạng thái `stateDiagram-v2` hoặc Flowchart phân loại trạng thái tệp (Untracked vs Modified vs Staged).
     * *Khi thao tác Stash, Revert, Reset*: Dùng sơ đồ ngăn xếp (Stack) hoặc sơ đồ dịch chuyển con trỏ HEAD giữa các commit.


---

## 3. CHECKLIST KIỂM TOÁN TỰ ĐỘNG
- [ ] Phản hồi trong khung chat không chứa bất kỳ khối ` ```mermaid ` nào.
- [ ] Mọi sơ đồ Mermaid đều nằm bên trong các tệp `.md` cụ thể trên hệ thống tệp.
- [ ] Báo cáo tóm tắt trong chat chỉ dẫn link đến tệp `.md` chứa sơ đồ để Người Dùng mở xem.
