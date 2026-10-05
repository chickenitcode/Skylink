# ĐẶC TẢ MODULE 00: XÁC THỰC, QUẢN LÝ PHIÊN & PHÂN QUYỀN RBAC (AUTH & RBAC SPEC)

> **Mã hồ sơ**: `SPEC-MOD-00`  
> **Module**: Authentication & Role-Based Access Control (Auth & RBAC)  
> **Vị trí tài liệu**: `docs/spec/00_auth_rbac_spec.md`  
> **Phụ trách triển khai**: Thành viên B (Backend NestJS) + Thành viên A (Mobile Expo SecureStore)  
> **Điều hướng liên kết**: [📋 Mục Lục Toàn Bộ Đặc Tả](./README.md) | [Tiếp theo: Module 01 (Workflow) ➡️](./01_consultation_workflow_spec.md)

---

## 1. TỔNG QUAN KIẾN TRÚC XÁC THỰC
Hệ thống SkyLink áp dụng cơ chế xác thực kép **JWT (Access Token hạn ngắn + Refresh Token hạn dài)** kết hợp phân quyền theo vai trò (**Role-Based Access Control - RBAC**). 
Token được sinh bởi NestJS Gateway thông qua thư viện `@nestjs/jwt` + `Passport-JWT` và lưu trữ mã hóa phần cứng trên thiết bị di động bằng `expo-secure-store`.

```mermaid
flowchart LR
    Client["📱 Mobile App<br/>(Expo SecureStore)"]
    Gateway["🚪 NestJS Gateway<br/>(JwtAuthGuard)"]
    AuthSvc["🔐 AuthService<br/>(Bcrypt / JWT Signer)"]
    UserDB[("PostgreSQL<br/>(users / roles / permissions)")]

    Client -- "1. POST /auth/login (Email, Pass)" --> Gateway
    Gateway --> AuthSvc
    AuthSvc -- "2. Đối soát mật khẩu hash" --> UserDB
    AuthSvc -- "3. Trả về Access + Refresh Token" --> Gateway
    Gateway -- "4. Lưu an toàn vào Keychain/Keystore" --> Client
    Client -- "5. Gửi Bearer Token trong Header" --> Gateway
    Gateway -- "6. JwtStrategy giải mã & PermissionsGuard kiểm tra" --> UserDB
```

---

## 2. CHI TIẾT CÁC ENDPOINT API

### 2.1. Endpoint Đăng nhập (User Login)
- **Giao thức**: `POST /api/auth/login`
- **Quyền hạn**: Public (Không yêu cầu Token)
- **Mục đích**: Xác thực danh tính người dùng và cấp cặp token làm việc.

#### Payload Request (Client $\to$ Backend):
```json
{
  "email": "giap.mt@gascolae.ctgroupvietnam.com",
  "password": "SecurePassword@2026",
  "device_info": {
    "device_id": "dvc_ios_a1b2c3d4e5f6",
    "device_name": "iPhone 15 Pro",
    "platform": "ios",
    "app_version": "1.0.0"
  }
}
```

#### Payload Response khi THÀNH CÔNG (HTTP `200 OK`):
```json
{
  "status_code": 200,
  "message": "Đăng nhập thành công",
  "token_type": "Bearer",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c3Jfc2FsZXNfMDEiLCJlbWFpbCI6ImdpYXAubXRAZ2FzY29sYWUuY3Rncm91cHZpZXRuYW0uY29tIiwiZnVsbF9uYW1lIjoiTWFpIFThuqVuIEdpw6FwIiwicm9sZSI6IlNBTEVTIiwicGVybWlzc2lvbnMiOlsic2VydmljZTpyZWFkIiwiY29uc3VsdGF0aW9uOmNyZWF0ZSIsImNvbnN1bHRhdGlvbjpvd24iLCJwcm9wb3NhbDpjcmVhdGUiLCJwcm9wb3NhbDpvd24iXSwiaXNzIjoiZ2FzY29sYWUuc2t5bGluayIsImlhdCI6MTc3MDAwMDAwMCwiZXhwIjoxNzcwMDAzNjAwfQ.SignatureExampleXYZ123",
  "refresh_token": "rft_7f9c8d1e2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f",
  "expires_in": 3600,
  "user": {
    "id": "usr_sales_01",
    "email": "giap.mt@gascolae.ctgroupvietnam.com",
    "full_name": "Mai Tấn Giáp",
    "role": "SALES",
    "permissions": [
      "service:read",
      "consultation:create",
      "consultation:own",
      "proposal:create",
      "proposal:own"
    ],
    "department": "Phòng Kinh Doanh & Phát Triển Dịch Vụ Không Phận",
    "avatar_url": "/static/avatars/usr_sales_01.jpg",
    "last_login_at": "2026-10-05T10:35:00Z"
  }
}
```

#### Payload Response khi THẤT BÀI (HTTP `401 Unauthorized`):
```json
{
  "status_code": 401,
  "error": "UNAUTHORIZED",
  "message": "Email hoặc mật khẩu không chính xác",
  "timestamp": "2026-10-05T10:35:02Z",
  "path": "/api/auth/login"
}
```

---

### 2.2. Endpoint Gia hạn phiên làm việc (Refresh Token)
- **Giao thức**: `POST /api/auth/refresh`
- **Quyền hạn**: Public (Sử dụng Refresh Token để gia hạn ngầm)
- **Mục đích**: Cấp Access Token mới khi token cũ hết hạn (Silent Token Refresh) và áp dụng cơ chế **Token Rotation** thu hồi Refresh Token cũ.

#### Payload Request:
```json
{
  "refresh_token": "rft_7f9c8d1e2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f"
}
```

#### Payload Response khi THÀNH CÔNG (HTTP `200 OK`):
```json
{
  "status_code": 200,
  "token_type": "Bearer",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c3Jfc2FsZXNfMDEi...NewSignature456",
  "refresh_token": "rft_rotated_99a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0",
  "expires_in": 3600
}
```

#### Payload Response khi REFRESH TOKEN HẾT HẠN (HTTP `401 Unauthorized`):
```json
{
  "status_code": 401,
  "error": "TOKEN_EXPIRED",
  "message": "Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại",
  "action_required": "NAVIGATE_TO_LOGIN"
}
```

---

### 2.3. Endpoint Lấy hồ sơ tài khoản hiện tại (Current User Profile)
- **Giao thức**: `GET /api/auth/me`
- **Headers**: `Authorization: Bearer <ACCESS_TOKEN>`

#### Payload Response (HTTP `200 OK`):
```json
{
  "id": "usr_sales_01",
  "email": "giap.mt@gascolae.ctgroupvietnam.com",
  "full_name": "Mai Tấn Giáp",
  "role": "SALES",
  "permissions": [
    "service:read",
    "consultation:create",
    "consultation:own",
    "proposal:create",
    "proposal:own"
  ],
  "session_stats": {
    "active_consultations_count": 3,
    "pending_proposals_count": 1
  }
}
```

---

### 2.4. Endpoint Đăng xuất (User Logout)
- **Giao thức**: `POST /api/auth/logout`
- **Headers**: `Authorization: Bearer <ACCESS_TOKEN>`
- **Payload Request**:
```json
{
  "refresh_token": "rft_rotated_99a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0"
}
```
- **Payload Response** (HTTP `200 OK`):
```json
{
  "status_code": 200,
  "message": "Đăng xuất thành công, phiên làm việc đã được hủy"
}
```

---

## 3. CẤU TRÚC GIẢI MÃ JWT TOKEN PAYLOAD (DECODED JWT CLAIMS)

Khi Access Token được gửi lên qua Header `Authorization: Bearer <token>`, NestJS `JwtStrategy` giải mã payload theo chuẩn RFC 7519:

```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "usr_sales_01",
    "email": "giap.mt@gascolae.ctgroupvietnam.com",
    "full_name": "Mai Tấn Giáp",
    "role": "SALES",
    "permissions": [
      "service:read",
      "consultation:create",
      "consultation:own",
      "proposal:create",
      "proposal:own"
    ],
    "iss": "gascolae.skylink",
    "iat": 1770000000,
    "exp": 1770003600
  }
}
```

---

## 4. MA TRẬN PHÂN QUYỀN VAI TRÒ (RBAC PERMISSIONS MATRIX)

| Mã Quyền (Permission) | Ý Nghĩa Chức Năng | SALES / BD | REVIEWER | ADMIN |
| :--- | :--- | :---: | :---: | :---: |
| `service:read` | Xem thông tin dịch vụ public & internal | ✅ Cho phép | ✅ Cho phép | ✅ Cho phép |
| `service:restricted` | Xem tài liệu dịch vụ bảo mật cấp lãnh đạo | ❌ Bị chặn | ❌ Bị chặn | ✅ Cho phép |
| `consultation:create` | Khởi tạo phiên tư vấn mới | ✅ Cho phép | ❌ Bị chặn | ✅ Cho phép |
| `consultation:own` | Đọc/Gửi tin nhắn trong phiên của mình | ✅ Cho phép | ✅ Cho phép | ✅ Cho phép |
| `consultation:all` | Xem toàn bộ lịch sử tư vấn của toàn công ty | ❌ Bị chặn | ✅ Cho phép | ✅ Cho phép |
| `proposal:create` | Sinh bản thảo Proposal từ phiên tư vấn | ✅ Cho phép | ❌ Bị chặn | ✅ Cho phép |
| `proposal:approve` | Phê duyệt Proposal chuyển trạng thái `APPROVED` | ❌ Bị chặn | ✅ Cho phép | ✅ Cho phép |
| `proposal:reject` | Yêu cầu sửa đổi hoặc từ chối Proposal | ❌ Bị chặn | ✅ Cho phép | ✅ Cho phép |
| `knowledge:ingest` | Nạp Service Assets mới vào hệ thống | ❌ Bị chặn | ❌ Bị chặn | ✅ Cho phép |
| `knowledge:reindex` | Trigger tính toán lại Vector Embeddings | ❌ Bị chặn | ❌ Bị chặn | ✅ Cho phép |
| `user:manage` | Thêm, sửa, cấp quyền và khóa tài khoản | ❌ Bị chặn | ❌ Bị chặn | ✅ Cho phép |

---

## 5. CHIẾN LƯỢC BẢO MẬT & LƯU TRỮ PHÍA MOBILE
1. **Lưu trữ an toàn bằng Phần Cứng**:
   - Sử dụng `expo-secure-store` để lưu trữ `access_token` và `refresh_token` trong **iOS Keychain** và **Android Keystore**. Tuyệt đối không lưu token vào `AsyncStorage` để phòng ngừa rò rỉ bộ nhớ.
2. **Cơ chế Silent Refresh với Axios Interceptor**:
   - Khi bất kỳ API nào phản hồi mã lỗi `401 Unauthorized` do Access Token hết hạn, Interceptor tự động tạm dừng request, kích hoạt Endpoint `POST /api/auth/refresh` bằng Refresh Token lưu trong SecureStore để lấy Access Token mới, sau đó thử lại request ban đầu mà không làm gián đoạn trải nghiệm của người dùng.
