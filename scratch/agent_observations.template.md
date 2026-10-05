# NHẬT KÝ QUAN SÁT TỨC THỜI CỦA AGENT (Agent Working Snapshot Template)
> **Mục đích**: Ghi lại minh bạch **chính xác những gì Agent vừa xem, vừa đọc, vừa chạy ngầm** ở thời điểm làm việc hiện tại, kèm **hiển thị rõ ràng dòng lệnh đã chạy, output nguyên văn và giải thích cặn kẽ từng dòng log** để Người Dùng vừa kiểm soát hệ thống, vừa học hỏi bản chất kỹ thuật (đặc biệt là các thao tác Git). Ghi đè snapshot mới sau mỗi chặng thao tác.

---

## 1. TÁC VỤ & LỆNH AGENT VỪA THỰC HIỆN (Behind-The-Scenes Actions & Commands)
- **Thời điểm**: `YYYY-MM-DD HH:mm:ss`
- **Mục tiêu chặng này**: `[Ví dụ: Kiểm tra trạng thái Git, đọc log commit, soi thay đổi diff, kiểm tra cấu hình]`
- **Tệp vừa mở đọc (`view_file`)**: `[Đường dẫn tệp cụ thể]`
- **Lệnh Terminal Agent vừa chạy (nếu có)**:
  - Dòng lệnh (CommandLine): `[Ví dụ: git status hoặc git log --oneline -n 5]`
  - Thư mục thực thi (Cwd): `[c:\Users\Admin\Desktop\CT_Group_Intern_project]`
  - Exit Code: `[0 (Thành công) / Mã lỗi nếu có]`
  *(Nếu không chạy lệnh nào: Ghi rõ "Không chạy lệnh terminal (chỉ thao tác đọc/sửa file qua tool)" )*

---

## 2. NGUYÊN VĂN ĐẦU RA TERMINAL & BÓC TÁCH HỌC TẬP (Raw Output & Learning Breakdown)
- **Nguồn đầu ra**: `[Stdout / Stderr từ lệnh terminal vừa chạy]`
- **Đầu ra nguyên văn (Raw Output)**:
  ```text
  [Trích dẫn 100% nguyên văn toàn bộ output/log mà hệ thống trả về, không cắt gọt]
  ```

- **Bóc tách & Giải thích chi tiết từng dòng (Góc Học Tập & Hiểu Bản Chất Git)**:
  - `[Dòng lệnh / Cờ lệnh]`: `[Giải thích ý nghĩa câu lệnh: Lệnh này làm gì? Từng tham số/cờ lệnh (flag) có tác dụng gì?]`
  - `[Dòng log output thứ nhất]`: `[Giải thích ý nghĩa kỹ thuật: Cơ chế hoạt động là gì? Tại sao hệ thống lại in ra dòng này?]`
  - `[Dòng log output thứ hai]`: `[Giải thích trạng thái: Ví dụ file đang ở Untracked, Staged, hay Modified? Nguyên lý Staging Area là gì?]`
  - `[Dòng log / Cảnh báo / Mã lỗi]`: `[Giải thích nguyên nhân: Nếu có lỗi hoặc trạng thái đặc biệt, tại sao lại xảy ra và cách xử lý ra sao?]`

---

## 3. TRẠNG THÁI GIT & TÍNH TOÀN VẸN CÂY LÀM VIỆC (Git & Workspace State Inspection)
- **Trạng thái Git tức thời**:
  - Tình trạng Repository: `[Đã khởi tạo (.git) / Chưa khởi tạo]`
  - Nhánh hiện tại (Current Branch): `[main / master / feature-branch]`
  - Commit Head: `[Mã commit gần nhất kèm message]`
  - Tình trạng cây làm việc (Working Tree): `[Clean (sạch sẽ) / Có file untracked / Có file modified]`
- **Kiểm toán an toàn thư mục & tệp nhạy cảm**:
  - Thư mục tài liệu (`docs/`): `[Được bảo toàn / Có file mới]`
  - Thư mục báo cáo (`reports/`): `[Bảo toàn]`
  - Thư mục đệm (`scratch/`): `[Sạch sẽ, không có script rác]`
  - File nhạy cảm / Tệp rác: `[Không phát hiện file .env, token, secret]`

---

## 4. KẾT LUẬN & ĐỀ XUẤT HÀNH ĐỘNG TIẾP THEO (Conclusion & Next Step)
- **Tóm tắt hiện trạng**: `[1-2 câu kết luận ngắn gọn, dễ hiểu về trạng thái hệ thống sau tác vụ vừa rồi]`
- **Bước hành động tiếp theo đề xuất cho Người Dùng**:
  - Việc cần làm: `[Mô tả cụ thể]`
  - Lệnh thực hành (Người dùng có thể tự copy & chạy trên terminal để làm quen):
    ```powershell
    [Lệnh terminal mẫu]
    ```
