# QUY ĐỊNH ĐÓNG GÓP (CONTRIBUTING)

## 1. Branching Model
- Luôn tạo nhánh mới từ `develop`.
- Prefix:
  - Mobile: `feature/mobile/`
  - Backend: `feature/api/`
  - AI/Data: `feature/ai/`
  - Fix bug: `fix/`

## 2. API Contract
- `packages/contracts/openapi.yaml` là NGUỒN CHÂN LÝ DUY NHẤT.
- Nếu bạn cần thay đổi một API (thêm field, đổi kiểu dữ liệu), BẠN PHẢI:
  1. Thảo luận với người phụ trách module liên quan.
  2. Cập nhật `openapi.yaml`.
  3. Commit sự thay đổi hợp đồng API TRƯỚC, sau đó mới viết code implement.

## 3. Pull Requests
- PR phải gọn gàng, xử lý một chức năng cụ thể.
- Yêu cầu tối thiểu 1 người khác (không phải tác giả) review code trước khi merge.
- Đảm bảo code pass linter và compile thành công.

## 4. Migrations (Backend)
- Tuyệt đối KHÔNG sửa file migration cũ trong Prisma.
- Luôn tạo migration mới: `npx prisma migrate dev --name mo_ta_su_thay_doi`

## 5. Environment Secrets
- Không commit file `.env` lên repository.
- Bất kỳ biến môi trường mới nào được thêm vào `.env`, PHẢI được phản ánh vào file `.env.example`.
