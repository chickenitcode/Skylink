# CẨM NANG KHẮC PHỤC SỰ CỐ LIBREOFFICE HEADLESS TRÊN LINUX CONTAINER (libreoffice_troubleshooting.md)

## 1. LỖI LỆCH HOẶC Ô VUÔNG FONT TIẾNG VIỆT (TÔN TRỌNG UNICODE)
- **Nguyên nhân**: Bản phân phối Linux Alpine/Ubuntu mặc định không có font Unicode tiếng Việt (như Times New Roman, Arial hoặc Noto Sans), dẫn đến khi render PDF các ký tự tiếng Việt có dấu như `ấ, ệ, ổ, ỹ` sẽ bị biến thành ô vuông hoặc ký tự rác.
- **Cách xử lý**:
  - Cài đặt gói `font-noto`, `msttcorefonts-installer`.
  - Bắt buộc chạy lệnh `fc-cache -f` trong Dockerfile để cập nhật cache font chữ của hệ điều hành.

---

## 2. LỖI ZOMBIE PROCESS & TREO TIẾN TRÌNH CONVERSION
- **Hiện tượng**: Tiến trình `soffice.bin` không tự giải phóng sau khi xuất file, biến thành tiến trình thây ma (zombie) ngốn sạch RAM và CPU sau vài chục lần tạo Proposal.
- **Cách xử lý**:
  1. Thêm cờ `--headless --invisible --nodefault --nofirststartwizard --nolockcheck --nologo`.
  2. Bổ sung tham số profile cô lập: `-env:UserInstallation=file:///tmp/LibreOffice_Conversion_${PID}`.
  3. Xử lý timeout trong Node.js: Tự động kích hoạt `kill -9` nếu tiến trình kéo dài quá 30 giây.
