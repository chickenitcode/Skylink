import axios from 'axios';

// Mã nguồn cấu hình Axios Client mẫu kết nối Backend NestJS SkyLink
export const apiClient = axios.create({
  baseURL: process.env.EXPO_PUBLIC_API_BASE_URL || 'https://api.skylink.gascolae.internal/api',
  timeout: Number(process.env.EXPO_PUBLIC_API_TIMEOUT_MS) || 15000,
  headers: {
    'Content-Type': 'application/json',
    'X-Client-Platform': 'mobile-expo',
  },
});

// Hàm mẫu gọi API tra cứu danh mục dịch vụ
export async function fetchServiceCatalog(category?: string) {
  const response = await apiClient.get('/services', {
    params: { category, status: 'verified' }
  });
  return response.data;
}

// Hàm mẫu gửi tin nhắn tư vấn
export async function sendConsultationMessage(sessionId: string, message: string) {
  const response = await apiClient.post(`/consultations/${sessionId}/messages`, {
    message
  });
  return response.data;
}
