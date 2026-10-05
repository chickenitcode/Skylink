# SCRATCHPAD DIRECTORY (scratch/)

Thư mục này là **vùng đệm kỹ thuật tạm thời (Scratchpad)** của dự án dành riêng cho Agent và Lập trình viên:

### 1. Mục đích sử dụng:
- Chứa các script thử nghiệm nhanh (`.ps1`, `.py`, `.sh`), các đoạn mã kiểm tra dữ liệu, trích xuất ad-hoc (ví dụ: inspect XML, test regex, benchmark nhỏ).
- Lưu trữ các tệp log tạm thời, output nháp trong quá trình debug.

### 2. Kỷ luật bắt buộc (Zero Root Pollution & Self-Cleaning):
- **CẤM TUYỆT ĐỐI** tạo script tạm, file rác trực tiếp tại thư mục gốc workspace (`/`). Mọi script tạm bắt buộc phải đặt trong `scratch/`.
- **Tự động dọn dẹp (Self-Cleaning)**: Sau khi hoàn thành tác vụ kiểm tra hoặc xử lý dữ liệu, Agent có trách nhiệm xóa bỏ các tệp script tạm trong thư mục này để bảo đảm workspace luôn tinh gọn và sạch đẹp.
