# HƯỚNG DẪN KỸ THUẬT RENDER DOCX VÀ PDF AN TOÀN (docxtemplater_libreoffice_guide.md)

## 1. NGUYÊN LÝ HOẠT ĐỘNG
Quy trình xuất bản Proposal trong SkyLink kết hợp hai công cụ mã nguồn mở mạnh mẽ:
1. **`docxtemplater` + `PizZip` (Node.js)**: Điền dữ liệu JSON vào tệp mẫu Microsoft Word (`.docx`). Không can thiệp vào định dạng đồ họa hay layout trang, bảo toàn 100% bố cục thiết kế của doanh nghiệp.
2. **`soffice` (LibreOffice Headless CLI)**: Chuyển đổi tệp DOCX hoàn chỉnh thành PDF chuẩn công nghiệp.

---

## 2. CÁC LỖI THƯỜNG GẶP VÀ CÁCH KHẮC PHỤC

### 2.1. Lỗi Lộ Thẻ Placeholder `{undefined}`:
- **Hiện tượng**: Khi dữ liệu JSON bị thiếu một trường (ví dụ: khách chưa có số điện thoại), tài liệu Word sẽ in ra chữ `{client_info.phone}`.
- **Giải pháp**: Cấu hình hàm `nullGetter` trong Docxtemplater để trả về chuỗi rỗng `''` thay vì để nguyên cú pháp biến.

### 2.2. Lỗi Zombie Process Khi Chuyển Đổi PDF:
- **Hiện tượng**: Lệnh `soffice` bị treo khi xử lý bảng dữ liệu phức tạp hoặc file quá lớn, chiếm dụng CPU 100%.
- **Giải pháp**:
  - Luôn bọc lệnh trong `child_process.exec` với cờ `timeout: 30000` (tối đa 30 giây).
  - Sử dụng cờ `-env:UserInstallation=file:///tmp/LibreOffice_Conversion_...` để mỗi tiến trình chạy trên một profile tạm cách ly, không bị tranh chấp khóa file (lock file collision).
