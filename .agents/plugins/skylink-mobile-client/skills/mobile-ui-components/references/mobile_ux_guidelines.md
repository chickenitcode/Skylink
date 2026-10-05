# HƯỚNG DẪN THIẾT KẾ TRẢI NGHIỆM NGƯỜI DÙNG HIỆN TRƯỜNG (mobile_ux_guidelines.md)

## 1. BỐI CẢNH SỬ DỤNG NGOÀI TRỜI (FIELD OPERATION UX)
Đội ngũ Sales / BD của GASCOLAE thường xuyên gặp khách hàng tại các nông trường, khu công nghiệp hoặc vườn đồi có ánh sáng mặt trời mạnh và mạng di động chập chờn.

### Quy Chuẩn Thiết Kế Bắt Buộc:
1. **Độ tương phản cao (High Contrast)**:
   - Tỷ lệ tương phản chữ trên nền tối thiểu đạt chuẩn WCAG AA ($4.5:1$).
   - Nút hành động chính (Primary CTA) sử dụng màu xanh đậm thương hiệu `#1E3A8A` với chữ trắng rõ nét.
2. **Kích thước vùng bấm (Touch Target)**:
   - Các nút bấm, chip dẫn chứng tối thiểu phải đạt kích thước $44 \times 44$ pt để dễ dàng thao tác bằng một tay hoặc khi người dùng đang di chuyển.
3. **Phản hồi ngoại tuyến (Offline Graceful Degradation)**:
   - Khi mất mạng, không hiển thị màn hình trắng hay popup báo lỗi chặn màn hình.
   - Hiển thị thanh thông báo nhẹ ở đầu màn hình và cho phép tiếp tục duyệt dữ liệu danh mục dịch vụ đã lưu trong cache.
