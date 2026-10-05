# CƠ SỞ TOÁN HỌC & NGUYÊN LÝ RECIPROCAL RANK FUSION (rrf_mathematical_foundation.md)

## 1. BÀI TOÁN KẾT HỢP HAI THANG ĐIỂM DỊ BIỆT
Trong tìm kiếm lai (Hybrid Search), hai hệ thống tính điểm có bản chất toán học hoàn toàn khác nhau:
- **BM25 / Full-Text Search**: Điểm số phụ thuộc vào tần suất xuất hiện từ khóa ($TF-IDF$), là số thực dương không có chặn trên ($[0, +\infty)$).
- **Cosine Similarity (pgvector)**: Điểm số nằm trong khoảng $[-1, 1]$ hoặc khoảng cách Cosine $[0, 2]$.

Nếu cộng gộp điểm số trực tiếp (Linear Combination $\alpha \cdot \text{Score}_{\text{FTS}} + \beta \cdot \text{Score}_{\text{Vec}}$), sự khác biệt về phân phối giá trị và scale sẽ làm méo mó kết quả, đòi hỏi phải chuẩn hóa Min-Max phức tạp và rất dễ vỡ khi phân bố dữ liệu thay đổi.

---

## 2. CÔNG THỨC RECIPROCAL RANK FUSION (RRF)
Thuật toán RRF do Cormack et al. đề xuất (2009) bỏ qua điểm số thô và chỉ quan tâm đến **Thứ Hạng (Rank)** của tài liệu trong từng danh sách kết quả:

$$RRF(d) = \sum_{m \in M} \frac{w_m}{k + r_m(d)}$$

Trong đó:
- $M$: Tập hợp các bộ máy tìm kiếm (ở đây là FTS và Dense Vector).
- $r_m(d)$: Thứ hạng của tài liệu $d$ trong hệ thống $m$ (bắt đầu từ $1, 2, 3...$). Nếu tài liệu không xuất hiện trong Top ứng viên của hệ thống đó, giá trị thành phần là $0$.
- $k$: Hệ số điều hòa (smoothing constant), thường chọn là **60**.
- $w_m$: Trọng số ưu tiên của hệ thống $m$ (mặc định $1.0$).

### Tại sao $k = 60$?
Hệ số $k$ đóng vai trò giảm độ dốc của hàm nghịch đảo:
- Nếu $k$ quá nhỏ (ví dụ $k=1$): Chênh lệch giữa hạng 1 ($\frac{1}{2} = 0.5$) và hạng 2 ($\frac{1}{3} = 0.33$) là quá lớn, khiến tài liệu đứng đầu ở 1 hệ thống áp đảo hoàn toàn tài liệu đứng thứ 2 ở cả 2 hệ thống.
- Với $k=60$: Tài liệu đứng hạng 1 có điểm $\frac{1}{61} \approx 0.01639$; đứng hạng 2 có điểm $\frac{1}{62} \approx 0.01612$. Sự chênh lệch nhẹ nhàng này bảo đảm: **Một tài liệu xuất hiện ở thứ hạng cao ở CẢ HAI hệ thống sẽ luôn có tổng điểm cao hơn một tài liệu chỉ đứng đầu ở một hệ thống duy nhất.**
