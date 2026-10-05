# KỶ LUẬT KIẾN TRÚC ỨNG DỤNG DI ĐỘNG (mobile_architecture_discipline.md)

## 1. NGUYÊN TẮC CỐT LÕI
Ứng dụng di động **SkyLink Mobile** được xây dựng trên nền tảng **React Native / Expo** nhằm phục vụ trực tiếp đội ngũ Sales và Business Development khi đi công tác và tư vấn hiện trường. Để bảo đảm an toàn, mượt mà và nhất quán dữ liệu, lập trình viên phía Mobile phải tuân thủ nghiêm ngặt các kỷ luật sau:

---

## 2. QUẢN TRỊ TOKEN & BẢO MẬT TRÊN THIẾT BỊ (TOKEN DISCIPLINE)

1. **BẮT BUỘC DÙNG EXPO SECURESTORE**:
   - Access Token và Refresh Token **BẮT BUỘC** phải được lưu trữ trong `expo-secure-store` (được mã hóa phần cứng qua iOS Keychain / Android KeyStore).
   - **CẤM TUYỆT ĐỐI** lưu trữ token nhạy cảm trong `AsyncStorage` hoặc `localStorage` vì dữ liệu không được mã hóa và rất dễ bị trích xuất trái phép.
2. **CƠ CHẾ SILENT REFRESH WITH REQUEST QUEUE**:
   - Khi nhận mã lỗi `HTTP 401 Unauthorized`, ứng dụng không được tự ý đăng xuất người dùng ngay lập tức.
   - Axios Interceptor phải tạm dừng (pause) các request đang chờ và kích hoạt luồng gia hạn token ngầm (`POST /api/auth/refresh`) bằng Refresh Token.
   - Sử dụng cơ chế hàng đợi (Queue Callback) để khi lấy được Access Token mới thành công, toàn bộ các request đang nghẽn sẽ tự động được gửi lại (retry) mà người dùng không hề nhận thấy sự gián đoạn.
   - Chỉ khi việc Refresh Token thất bại (ví dụ: Refresh Token hết hạn 7 ngày hoặc bị thu hồi), ứng dụng mới xóa sạch SecureStore và điều hướng về màn hình Đăng nhập.

---

## 3. ĐỒNG BỘ TRẠNG THÁI VỚI BACKEND (STATE SYNC DISCIPLINE)

1. **MOBILE KHÔNG TỰ SÁNG TẠO TRẠNG THÁI**:
   - Mọi tiến trình từ `DISCOVERY` đến `APPROVED` hoàn toàn do Backend phản hồi.
   - Mobile không tự ý chuyển màn hình hay giả định trạng thái nếu chưa nhận được phản hồi thành công từ API.
2. **ẨN ĐIỂM VECTOR SỐ THỰC**:
   - Mobile Client tuyệt đối không render các con số float vector thô (như `0.8521`) lên thẻ dịch vụ.
   - Bắt buộc render Badge định tính: `Tương thích cao`, `Phù hợp tiêu chuẩn`, `Cần khảo sát thêm`.

---

## 4. TỐI ƯU HÓA TRẢI NGHIỆM NGOẠI TUYẾN & HIỆN TRƯỜNG (OFFLINE RESILIENCE)
- Sử dụng **TanStack Query (React Query)** với thời gian `staleTime: 5 phút` cho danh mục dịch vụ (`GET /api/services`).
- Khi mất kết nối internet tại hiện trường, ứng dụng vẫn cho phép Sales mở xem các dịch vụ đã tải trong cache và hiển thị thanh thông báo nhẹ: *"Đang xem dữ liệu ngoại tuyến — Kết nối mạng để tiếp tục tư vấn AI."*
