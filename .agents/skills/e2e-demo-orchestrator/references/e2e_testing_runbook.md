# SỔ TAY VẬN HÀNH KIỂM THỬ TÍCH HỢP END-TO-END (e2e_testing_runbook.md)

## 1. QUY TRÌNH DIỄN TẬP KHÔNG LỖI (ZERO-FAIL DEMO RUNBOOK)
Tài liệu này là cẩm nang vận hành dành cho cả 3 thành viên (A, B, C) chuẩn bị cho buổi nghiệm thu Ngày 7:

### Các bước chuẩn bị trước giờ G 30 phút:
1. **Khởi động Docker Containers**:
   ```bash
   docker-compose up -d
   ```
2. **Kiểm tra Health Endpoint**:
   - Truy cập `GET http://localhost:3000/api/health` bảo đảm trả về `{ "status": "ok", "db": "connected", "pgvector": "ready" }`.
3. **Seed dữ liệu sạch**:
   - Chạy lệnh `npm run prisma:seed` để bảo đảm dữ liệu của `S0112` và `S0118` ở trạng thái nguyên vẹn.
4. **Kiểm tra mạng nội bộ**:
   - Kết nối thiết bị di động Expo vào cùng mạng Wi-Fi với máy chủ NestJS hoặc cấu hình ngrok tunnel dự phòng.

---

## 2. PHƯƠNG ÁN XỬ LÝ KHẨN CẤP (DISASTER RECOVERY)
- **Nếu mạng Wi-Fi chập chờn**: Sử dụng chế độ cache offline của TanStack Query trên Mobile để duyệt danh mục đã tải sẵn.
- **Nếu worker LibreOffice chậm**: Hệ thống đã có sẵn bản PDF mẫu được sinh trước đó tại `assets/cached_proposals/` để fallback hiển thị trên màn hình Mobile.
