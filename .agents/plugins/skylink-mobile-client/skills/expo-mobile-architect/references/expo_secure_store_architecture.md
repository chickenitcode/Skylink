# KIẾN TRÚC LƯU TRỮ TOKEN AN TOÀN TRÊN THIẾT BỊ DI ĐỘNG (expo_secure_store_architecture.md)

## 1. SO SÁNH SECURESTORE VS ASYNCSTORAGE
- **`AsyncStorage`**: Dữ liệu lưu trữ dạng văn bản thuần (plaintext) trong tệp SQLite hoặc XML trên bộ nhớ trong của điện thoại. Nếu thiết bị bị root/jailbreak hoặc ứng dụng bị tấn công malware, Access/Refresh Token sẽ bị đánh cắp hoàn toàn.
- **`expo-secure-store`**: Tận dụng cơ chế mã hóa phần cứng chuyên biệt của hệ điều hành:
  - Trên **iOS**: Sử dụng **iOS Keychain Services**, dữ liệu được mã hóa bằng khóa phần cứng Secure Enclave.
  - Trên **Android**: Sử dụng **Android Keystore system** kết hợp chuẩn mã hóa AES-256 GCM.

---

## 2. NGUYÊN TẮC QUẢN TRỊ TOKEN TRONG SKYLINK
1. **Thời gian sống của Token**:
   - Access Token: 15 phút (ngắn hạn, dùng cho mọi request thông thường).
   - Refresh Token: 7 ngày (dài hạn, chỉ dùng duy nhất khi gọi endpoint `/auth/refresh`).
2. **Cơ chế Token Rotation**:
   - Mỗi lần gọi `/auth/refresh`, backend thu hồi Refresh Token cũ và cấp mới cả cặp (Access Token mới + Refresh Token mới).
   - Nếu phát hiện Refresh Token cũ bị sử dụng lại (Replay Attack), hệ thống lập tức khóa phiên và buộc đăng xuất toàn bộ thiết bị.
