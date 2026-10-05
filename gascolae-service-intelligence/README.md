# GASCOLAE Service Intelligence (SkyLink)

Trợ lý di động thông minh hỗ trợ đội ngũ Sales/BD tư vấn giải pháp máy bay không người lái (UAV), tra cứu tri thức, đối sánh dịch vụ và tự động lập Proposal dựa trên AI.

Dự án MVP (7 Ngày) - Phát triển bởi Nhóm 03 CT Group Interns.

## 🏛 Kiến trúc dự án
Dự án được cấu trúc theo mô hình **Modular Monolith** kết nối với ứng dụng **Native Android**, phân bổ rõ ràng cho 3 thành viên:
1. **Tầng Mobile (Thành viên A)**: App Native Android (Java, MVVM, Retrofit) cho phép Sales tra cứu, chat tư vấn và duyệt Proposal.
2. **Tầng Backend Gateway (Thành viên B)**: NestJS, quản trị Workflow State Machine, RBAC Auth và Document Generation Pipeline (LibreOffice).
3. **Tầng AI & Knowledge (Thành viên C)**: PostgreSQL + pgvector, Schema-aware Chunking, Hybrid Retrieval (RRF), Google Gemini LLM kết hợp Guardrails.

## 📁 Cấu trúc Repository
- `apps/mobile/`: Ứng dụng Android Native.
- `apps/api/`: Máy chủ Backend NestJS.
- `packages/contracts/`: Giao thức API dùng chung (`openapi.yaml`).
- `knowledge/`: Dữ liệu gốc và công cụ chuẩn hóa.
- `docs/`: Tài liệu đặc tả và quy trình dự án.

## 🚀 Quick Start
Mọi hướng dẫn khởi chạy dự án, cài đặt môi trường và quy trình làm việc được quy định chi tiết tại:
👉 **[Tài liệu Hướng dẫn Phát triển - GUIDE.md](./GUIDE.md)**

## 🤝 Đóng góp
Vui lòng tham khảo **[CONTRIBUTING.md](./CONTRIBUTING.md)** để biết quy ước Git branch, Commit conventions và cách thức gửi Pull Request.
