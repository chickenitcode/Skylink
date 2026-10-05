---
name: expo-mobile-architect
description: Hướng dẫn thiết lập kiến trúc ứng dụng di động React Native / Expo cho SkyLink, bao gồm quản trị Token an toàn với expo-secure-store, Axios Interceptor với Silent Refresh Queue chống race condition và caching TanStack Query.
---

# KỸ NĂNG KIẾN TRÚC DI ĐỘNG EXPO (expo-mobile-architect)

## 1. MỤC TIÊU KỸ THUẬT & NGUYÊN TẮC THIẾT KẾ MỀM (FLEXIBLE ARCHITECTURE)
Kỹ năng này cung cấp kiến trúc ứng dụng di động linh hoạt (configurable & extensible) cho Thành viên A (Mobile):
- **Cấu hình động qua biến môi trường**: Tách biệt toàn bộ Endpoint URL, Timeout, và Key lưu trữ ra tệp môi trường (`.env`), không ghi cứng giá trị cụ thể trong mã nguồn.
- **Lưu trữ Token an toàn đa nền tảng**: Quản trị Access/Refresh Token với `expo-secure-store` kèm tiền tố namespace có thể tùy biến.
- **Axios Interceptor với Silent Refresh Queue**: Tự động giải quyết race-condition khi nhiều request đồng thời gặp lỗi 401.
- **Đồng bộ hóa TanStack Query**: Cơ chế cache có thể tinh chỉnh thời gian sống (`staleTime`) theo từng môi trường (Development / Staging / Production).

---

## 2. MODULE CẤU HÌNH LINH HOẠT (`config/apiConfig.ts`)

```typescript
export interface AppApiConfig {
  baseUrl: string;
  timeoutMs: number;
  refreshPath: string;
  tokenNamespace: string;
  maxRetryAttempts: number;
}

// Đọc động từ biến môi trường của Expo (EXPO_PUBLIC_*) kèm giá trị mặc định dự phòng
export const getApiConfig = (): AppApiConfig => ({
  baseUrl: process.env.EXPO_PUBLIC_API_BASE_URL || 'http://localhost:3000/api',
  timeoutMs: Number(process.env.EXPO_PUBLIC_API_TIMEOUT_MS) || 15000,
  refreshPath: process.env.EXPO_PUBLIC_AUTH_REFRESH_PATH || '/auth/refresh',
  tokenNamespace: process.env.EXPO_PUBLIC_TOKEN_NAMESPACE || 'skylink',
  maxRetryAttempts: Number(process.env.EXPO_PUBLIC_MAX_RETRY_ATTEMPTS) || 3,
});
```

---

## 3. MODULE LƯU TRỮ TOKEN AN TOÀN (`services/tokenStorage.ts`)

```typescript
import * as SecureStore from 'expo-secure-store';
import { getApiConfig } from '../config/apiConfig';

export class TokenStorageService {
  private readonly accessKey: string;
  private readonly refreshKey: string;

  constructor(namespace: string = getApiConfig().tokenNamespace) {
    this.accessKey = `${namespace}_access_token`;
    this.refreshKey = `${namespace}_refresh_token`;
  }

  async setTokens(accessToken: string, refreshToken: string): Promise<void> {
    await Promise.all([
      SecureStore.setItemAsync(this.accessKey, accessToken),
      SecureStore.setItemAsync(this.refreshKey, refreshToken),
    ]);
  }

  async getAccessToken(): Promise<string | null> {
    return await SecureStore.getItemAsync(this.accessKey);
  }

  async getRefreshToken(): Promise<string | null> {
    return await SecureStore.getItemAsync(this.refreshKey);
  }

  async clearTokens(): Promise<void> {
    await Promise.all([
      SecureStore.deleteItemAsync(this.accessKey),
      SecureStore.deleteItemAsync(this.refreshKey),
    ]);
  }
}

export const TokenStorage = new TokenStorageService();
```

---

## 4. AXIOS CLIENT VỚI SILENT REFRESH QUEUE LINH HOẠT (`services/apiClient.ts`)

```typescript
import axios, { AxiosError, AxiosInstance, InternalAxiosRequestConfig } from 'axios';
import { getApiConfig, AppApiConfig } from '../config/apiConfig';
import { TokenStorage, TokenStorageService } from './tokenStorage';

export function createConfiguredApiClient(
  config: AppApiConfig = getApiConfig(),
  tokenService: TokenStorageService = TokenStorage,
  onSessionExpired?: () => void
): AxiosInstance {
  const instance = axios.create({
    baseURL: config.baseUrl,
    timeout: config.timeoutMs,
    headers: { 'Content-Type': 'application/json' },
  });

  let isRefreshing = false;
  let failedQueue: Array<{
    resolve: (value?: unknown) => void;
    reject: (reason?: unknown) => void;
  }> = [];

  const processQueue = (error: AxiosError | null, token: string | null = null) => {
    failedQueue.forEach(prom => {
      if (error) {
        prom.reject(error);
      } else {
        prom.resolve(token);
      }
    });
    failedQueue = [];
  };

  // Request Interceptor: Tự động gắn Bearer token nếu có
  instance.interceptors.request.use(async (reqConfig: InternalAxiosRequestConfig) => {
    const token = await tokenService.getAccessToken();
    if (token && reqConfig.headers) {
      reqConfig.headers.Authorization = `Bearer ${token}`;
    }
    return reqConfig;
  });

  // Response Interceptor: Xử lý 401 Silent Refresh không chặn UI
  instance.interceptors.response.use(
    (response) => response,
    async (error: AxiosError) => {
      const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean };

      if (error.response?.status === 401 && !originalRequest._retry) {
        if (isRefreshing) {
          return new Promise((resolve, reject) => {
            failedQueue.push({ resolve, reject });
          })
            .then((token) => {
              if (originalRequest.headers) {
                originalRequest.headers.Authorization = `Bearer ${token}`;
              }
              return instance(originalRequest);
            })
            .catch((err) => Promise.reject(err));
        }

        originalRequest._retry = true;
        isRefreshing = true;

        try {
          const refreshToken = await tokenService.getRefreshToken();
          if (!refreshToken) {
            throw new Error('Refresh token is absent in SecureStore');
          }

          // Gọi endpoint làm mới token động theo config
          const refreshUrl = `${config.baseUrl}${config.refreshPath}`;
          const refreshResponse = await axios.post(refreshUrl, { refresh_token: refreshToken });

          const { access_token, refresh_token: newRefreshToken } = refreshResponse.data.data;
          await tokenService.setTokens(access_token, newRefreshToken);

          processQueue(null, access_token);
          if (originalRequest.headers) {
            originalRequest.headers.Authorization = `Bearer ${access_token}`;
          }
          return instance(originalRequest);
        } catch (refreshErr) {
          processQueue(refreshErr as AxiosError, null);
          await tokenService.clearTokens();
          if (onSessionExpired) {
            onSessionExpired();
          }
          return Promise.reject(refreshErr);
        } finally {
          isRefreshing = false;
        }
      }

      return Promise.reject(error);
    }
  );

  return instance;
}

// Instance mặc định dùng cho toàn ứng dụng
const apiClient = createConfiguredApiClient();
export default apiClient;
```

---

## 5. CHECKLIST NGHIỆM THU DI ĐỘNG
- [ ] Không có URL, Port hoặc Secret nào bị ghi cứng trong mã TypeScript.
- [ ] Tệp `.env.example` khai báo đầy đủ các biến môi trường `EXPO_PUBLIC_*`.
- [ ] Token được quản lý qua namespace cách ly, không ghi đè dữ liệu của ứng dụng khác trên cùng thiết bị.
- [ ] Hàng đợi Silent Refresh giải quyết mượt mà trường hợp 3 request đồng thời bị 401 mà không văng ra màn hình đăng nhập.
