---
name: proposal-pipeline
description: Hướng dẫn kỹ thuật sinh tài liệu Proposal doanh nghiệp từ JSON có cấu trúc bằng docxtemplater, PizZip và xuất bản PDF chuẩn qua headless LibreOffice cho GASCOLAE SkyLink.
---

# KỸ NĂNG ĐƯỜNG ỐNG XUẤT BẢN ĐỀ XUẤT PROPOSAL (proposal-pipeline)

## 1. NGUYÊN TẮC THIẾT KẾ ĐỘNG (DYNAMIC TEMPLATE RENDERING)
Trong doanh nghiệp, mẫu hợp đồng và bản đề xuất dịch vụ (Proposal Templates) thường xuyên thay đổi các trường dữ liệu (thêm thông tin người phụ trách, số điện thoại khẩn cấp, phương án thanh toán chia kỳ, phụ lục đính kèm...). 

Nếu mã nguồn ánh xạ (mapping) bị ghi cứng từng trường, bất kỳ sự thay đổi nào trên template DOCX cũng sẽ làm hỏng quy trình.

Kỹ năng này cung cấp giải pháp **Render Động (Context-Agnostic Docx Rendering)**:
- **Ánh xạ Dictionary mở rộng**: Toàn bộ dữ liệu Proposal JSON được truyền trực tiếp vào template context, cho phép mở rộng không giới hạn các trường biến số.
- **Xử lý giá trị trống (Null/Undefined Resilience)**: Tự động thay thế giá trị trống bằng chuỗi rỗng hoặc nhãn thông báo thay vì ném ngoại lệ làm dừng tiến trình.
- **Watermark động theo trạng thái**: Tự động chèn hình mờ cảnh báo *"BẢN THẢO SƠ BỘ — CHƯA PHÊ DUYỆT"* nếu trạng thái khác `APPROVED`.

---

## 2. QUY TRÌNH KỸ THUẬT

```text
Proposal Structured JSON (Được Zod Validate)
                    ↓
    Context Enrichment (Bổ sung ngày in, Watermark, Định dạng số tiền)
                    ↓
    Docxtemplater Engine (Null-safe Dynamic Binding)
                    ↓
    Tệp DOCX Tạm Thời
                    ↓
    Worker LibreOffice (Chuyển đổi PDF)
                    ↓
    Tải về / Lưu trữ Storage
```

---

## 3. MÃ NGUỒN ÁNH XẠ ĐỘNG (`services/proposalCompiler.ts`)

```typescript
import PizZip from 'pizzip';
import Docxtemplater from 'docxtemplater';
import * as fs from 'fs';

export interface ProposalCompileOptions {
  watermarkText?: string;
  dateFormatLocale?: string;
  customFormatters?: Record<string, (val: any) => string>;
}

export function compileDocxProposal(
  templatePath: string,
  proposalData: Record<string, any>,
  options: ProposalCompileOptions = {}
): Buffer {
  if (!fs.existsSync(templatePath)) {
    throw new Error(`Không tìm thấy tệp template DOCX tại đường dẫn: ${templatePath}`);
  }

  const content = fs.readFileSync(templatePath, 'binary');
  const zip = new PizZip(content);

  const doc = new Docxtemplater(zip, {
    paragraphLoop: true,
    linebreaks: true,
    // Hàm xử lý giá trị trống linh hoạt: không để lộ thẻ lỗi {field} trên văn bản
    nullGetter: (part) => {
      if (!part.module) {
        return '';
      }
      if (part.module === 'raw') {
        return '';
      }
      return '';
    },
  });

  // Tạo ngữ cảnh render động kết hợp siêu dữ liệu hệ thống
  const renderContext = {
    ...proposalData,
    _system_rendered_at: new Date().toLocaleDateString(options.dateFormatLocale || 'vi-VN'),
    _watermark: options.watermarkText || (proposalData.status === 'APPROVED' ? '' : 'BẢN THẢO SƠ BỘ'),
    // Hỗ trợ hàm định dạng tiền tệ động nếu template cần dùng
    formatCurrency: (amount: number) => {
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
    }
  };

  doc.render(renderContext);

  return doc.getZip().generate({
    type: 'nodebuffer',
    compression: 'DEFLATE',
  });
}
```

---

## 4. CHECKLIST NGHIỆM THU TÀI LIỆU
- [ ] Template DOCX có thể bổ sung trường mới mà không cần sửa đổi mã TypeScript backend.
- [ ] Các trường không có giá trị sẽ tự động ẩn đi một cách an toàn mà không làm lỗi template.
- [ ] Bản Proposal chưa được duyệt hiển thị hình mờ (watermark) sơ bộ rõ ràng.
- [ ] Toàn bộ tài liệu xuất ra đều chứa điều khoản miễn trừ pháp lý sơ bộ theo đúng quy định doanh nghiệp.
