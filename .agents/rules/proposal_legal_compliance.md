# QUY TẮC PHÁP LÝ & BẢO VỆ DỮ LIỆU ĐỀ XUẤT (proposal_legal_compliance.md)

## 1. NGUYÊN TẮC CỐT TỬ
Hệ thống **GASCOLAE SkyLink** đóng vai trò là trợ lý kỹ thuật hỗ trợ lập bản thảo đề xuất dịch vụ sơ bộ. Hệ thống **KHÔNG CÓ TƯ CÁCH PHÁP NHÂN** để đưa ra các cam kết ràng buộc về mặt pháp lý, đơn giá chính thức hoặc tiến độ nghiệm thu cuối cùng thay cho Ban Lãnh đạo GASCOLAE.

---

## 2. ĐIỀU KHOẢN MIỄN TRỪ PHÁP LÝ BẮT BUỘC (MANDATORY DISCLAIMER)

Mọi tài liệu đề xuất giải pháp (kể cả bản xem trước JSON trên ứng dụng di động và bản xuất DOCX/PDF chính thức) **BẮT BUỘC** phải in nguyên văn điều khoản tuyên bố miễn trừ trách nhiệm pháp lý tại trang đầu tiên:

> **TUYÊN BỐ MIỄN TRỪ TRÁCH NHIỆM PHÁP LÝ SƠ BỘ**:
> *"Tài liệu này là bản thảo đề xuất kỹ thuật sơ bộ do Nền tảng Trợ lý Nội bộ GASCOLAE SkyLink hỗ trợ lập dựa trên các thông số nhu cầu ban đầu do khách hàng cung cấp và tri thức dịch vụ đã được chuẩn hóa. Tài liệu này KHÔNG CẤU THÀNH một báo giá thương mại ràng buộc, hợp đồng cung ứng dịch vụ, hay cam kết pháp lý cuối cùng giữa GASCOLAE Platform và Quý Khách hàng. Toàn bộ các thông số kỹ thuật, tiến độ triển khai thực tế, phương án giá và các điều kiện nghiệm thu phải trải qua quy trình khảo sát hiện trường chuyên sâu và được phê duyệt chính thức bằng văn bản bởi đại diện có thẩm quyền của GASCOLAE."*

---

## 3. KỶ LUẬT CÁCH LY THÔNG TIN CHƯA XÁC MINH (UNGROUNDED CLAIMS ISOLATION)

### 3.1. Cấm Tuyệt Đối Bịa Đặt Số Liệu (Zero Hallucinated Numbers):
- **Về Đơn giá & Chiết khấu**: Nếu trong các đoạn dẫn chứng (`Evidence Chunks`) được truy xuất không có mức giá cụ thể bằng văn bản, LLM tuyệt đối **KHÔNG ĐƯỢC PHÉP** tự tính toán hoặc tự bịa ra một mức giá giả định (ví dụ: "giá khoảng 50.000.000 VNĐ/tháng").
- **Về Tiến độ (Timeline)**: Không được cam kết thời gian hoàn thành cụ thể (ví dụ: "chính xác 3 ngày") nếu chưa có thông số phê duyệt trong Service Level.
- **Về Độ chính xác (Accuracy / SLA)**: Không tự tuyên bố "độ chính xác đạt 100%" nếu tài liệu dịch vụ chỉ ghi "độ chính xác nhận diện nấm bệnh $\ge 92\%$".

### 3.2. Cơ Chế Chuyển Hướng Sang `items_to_confirm`:
- Bất kỳ yếu tố nào khách hàng yêu cầu nhưng trong cơ sở dữ liệu dịch vụ chưa có căn cứ xác thực, LLM bắt buộc phải chuyển toàn bộ các yếu tố đó vào danh mục:
  ```json
  "items_to_confirm": [
    "Khảo sát địa hình thực tế tại 500ha đồi dốc để chốt trạm phát sóng điều khiển máy bay không người lái.",
    "Thẩm định diện tích tán cây thực tế để thống nhất phương án tính đơn giá và tiến độ bay theo mùa vụ.",
    "Kiểm tra giấy phép bay tại tọa độ khu vực canh tác với cơ quan quản lý không phận địa phương."
  ]
  ```
- Hành vi chuyển vào `items_to_confirm` vừa thể hiện tính trung thực, chuyên nghiệp của đội ngũ tư vấn, vừa bảo vệ tối đa uy tín pháp lý cho GASCOLAE.

---

## 4. QUY TRÌNH PHÊ DUYỆT BẮT BUỘC (MANDATORY HUMAN REVIEW)
1. Proposal sau khi sinh ra từ mô hình AI chỉ có trạng thái tối đa là `REVIEW_REQUIRED`.
2. Chỉ có người dùng sở hữu vai trò `REVIEWER` hoặc `ADMIN` và có quyền `PROPOSAL_APPROVE` mới có thẩm quyền chuyển trạng thái Proposal sang `APPROVED`.
3. Chỉ sau khi đạt trạng thái `APPROVED`, hệ thống mới cho phép kích hoạt tiến trình render và đóng dấu bản PDF xuất ra ngoài doanh nghiệp.
