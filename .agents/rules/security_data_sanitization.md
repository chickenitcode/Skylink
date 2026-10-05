# QUY TẮC BẢO MẬT & KIỂM SOÁT DỮ LIỆU TRI THỨC (security_data_sanitization.md)

## 1. NGUYÊN TẮC CỐT LÕI
Hệ thống **GASCOLAE SkyLink** xử lý dữ liệu dịch vụ kỹ thuật cao của doanh nghiệp. Để bảo đảm an toàn dữ liệu, chống rò rỉ thông tin nhạy cảm và duy trì trải nghiệm người dùng chuyên nghiệp, toàn bộ các module phải tuân thủ nghiêm ngặt các điều khoản dưới đây.

---

## 2. CHỐNG RÒ RỈ DỮ LIỆU NỘI BỘ (DATA LEAK PREVENTION)

### 2.1. Lớp Kiểm Soát Pre-check Bắt Buộc:
- Trước khi nạp bất kỳ đoạn dữ liệu tri thức (Evidence Chunks) nào vào ngữ cảnh (Context Window) của Mô hình Ngôn ngữ Lớn (LLM), tầng Backend **BẮT BUỘC** phải chạy bộ lọc tiền kiểm:
  1. **Trạng thái xác minh (`status`)**: Chỉ cho phép các chunk có nhãn `status: "verified"`. Tuyệt đối loại bỏ các chunk có nhãn `draft`, `deprecated`, hoặc `under_review`.
  2. **Phạm vi hiển thị (`visibility`)**: 
     - Người dùng có vai trò `SALES`: Chỉ được phép truy cập chunk có nhãn `public` hoặc `internal`. Tuyệt đối cấm nạp các chunk `restricted` (chỉ dành riêng cho Lãnh đạo hoặc Pháp chế).
     - Người dùng có vai trò `REVIEWER` hoặc `ADMIN`: Được phép truy cập các chunk `restricted` phục vụ mục đích kiểm toán và thẩm định.

### 2.2. Kiểm Soát API Response:
- Khi trả kết quả tìm kiếm dịch vụ hoặc danh mục về cho ứng dụng di động của Sales, backend phải tự động khử (strip) toàn bộ các trường nhạy cảm như: chi phí gốc của nhà cung cấp (`cost_price`), biên lợi nhuận nội bộ (`internal_margin`), và ghi chú nội bộ không được công khai.

---

## 3. BẢO VỆ TRẢI NGHIỆM NGƯỜI DÙNG — ẨN ĐIỂM VECTOR THÔ

1. **CẤM HIỂN THỊ RAW VECTOR SCORE**:
   - Khoảng cách Cosine (`cosine_distance`) hoặc điểm số băm vector thô (`raw float score` ví dụ: `0.874213`) tuyệt đối không được hiển thị trực tiếp lên giao diện người dùng di động của Sales.
   - Điểm số thô gây khó hiểu và giảm tính chuyên nghiệp khi Sales tư vấn cho khách hàng.
2. **CHUẨN HÓA THÀNH NHÃN ĐỊNH TÍNH**:
   - Backend hoặc Mobile ViewModel phải quy đổi điểm số tương đồng thành nhãn định tính dễ hiểu kèm màu sắc trực quan:
     - Điểm số tương thích cao ($\ge 0.85$): Gắn nhãn `"Tương thích cao"` (Badge Xanh lá).
     - Điểm số tương thích khá ($0.70 \le \text{score} < 0.85$): Gắn nhãn `"Phù hợp tiêu chuẩn"` (Badge Xanh dương).
     - Điểm số tương thích thấp hoặc cần bổ sung điều kiện ($< 0.70$): Gắn nhãn `"Cần khảo sát thêm"` (Badge Vàng cam).
3. **LUÔN ĐÍNH KÈM CHIP DẪN CHỨNG**:
   - Mọi đề xuất dịch vụ bắt buộc phải hiển thị kèm các chip mã nguồn dẫn chứng (ví dụ: `[SRC-01]`, `[SRC-04]`) để Sales có thể bấm vào xem chi tiết cơ sở dữ liệu.

---

## 4. BẢO MẬT KHÓA TRUY CẬP (SECRET & CREDENTIAL MANAGEMENT)
- Tuyệt đối không ghi cứng (hard-code) API Key (Gemini, OpenAI), mật khẩu Database, hoặc JWT Secret vào bất kỳ tệp mã nguồn nào.
- Mọi bí mật cấu hình phải được nạp qua biến môi trường (`.env`), có tệp mẫu `.env.example` và được khai báo trong `.gitignore`.
- Mobile Client tuyệt đối không chứa Secret Key của LLM. Mọi tương tác với mô hình AI bắt buộc phải đi qua Backend Gateway của SkyLink.
