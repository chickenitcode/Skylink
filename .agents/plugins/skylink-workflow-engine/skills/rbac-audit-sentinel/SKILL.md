---
name: rbac-audit-sentinel
description: Hướng dẫn quản trị phân quyền 11 quyền (Sales vs Reviewer vs Admin), bảo vệ route API bằng NestJS Guards và cơ chế ghi nhận nhật ký kiểm toán bất biến (Audit Trail Telemetry) cho GASCOLAE SkyLink.
---

# KỸ NĂNG BẢO VỆ PHÂN QUYỀN RBAC & NHẬT KÝ KIỂM TOÁN (rbac-audit-sentinel)

## 1. MA TRẬN PHÂN QUYỀN LINH HOẠT THEO ACTION (RBAC MATRIX)
Thay vì kiểm tra vai trò cứng nhắc (`if role === 'SALES'`), hệ thống SkyLink bảo vệ endpoint thông qua **Ma trận Quyền hạn (Permission-Based Guards)**. Điều này cho phép doanh nghiệp tùy biến gán thêm quyền cho các vai trò mới (ví dụ: `SUPPORT`, `PARTNER`) trong tương lai:

| Mã Quyền | Quyền Hạn Nghiệp Vụ | SALES | REVIEWER | ADMIN |
| :--- | :--- | :---: | :---: | :---: |
| `SERVICE_VIEW` | Xem danh mục Service và chi tiết Public/Internal | ✅ | ✅ | ✅ |
| `SERVICE_VIEW_RESTRICTED` | Xem các chunk nhạy cảm/pháp lý bí mật | ❌ | ✅ | ✅ |
| `CONSULTATION_CREATE` | Tạo phiên tư vấn mới và gửi tin nhắn chat | ✅ | ✅ | ✅ |
| `CONSULTATION_RESUME` | Xem lại và tiếp tục phiên tư vấn dở dang | ✅ | ✅ | ✅ |
| `PROPOSAL_CREATE_DRAFT` | Yêu cầu hệ thống sinh bản thảo Proposal | ✅ | ✅ | ✅ |
| `PROPOSAL_VIEW_OWN` | Xem các Proposal do chính mình lập | ✅ | ✅ | ✅ |
| `PROPOSAL_VIEW_ALL` | Xem toàn bộ Proposal trong hệ thống | ❌ | ✅ | ✅ |
| `PROPOSAL_APPROVE` | Phê duyệt chính thức hoặc yêu cầu chỉnh sửa | ❌ | ✅ | ✅ |
| `PROPOSAL_DOWNLOAD_PDF` | Tải về tệp PDF chính thức đã được đóng dấu | ✅ | ✅ | ✅ |
| `KNOWLEDGE_INGEST` | Nạp mới hoặc cập nhật Service Assets | ❌ | ❌ | ✅ |
| `AUDIT_VIEW` | Tra cứu nhật ký kiểm toán và cảnh báo vi phạm | ❌ | ❌ | ✅ |

---

## 2. GHI NHẬN NHẬT KÝ KIỂM TOÁN BẤT BIẾN THAM SỐ HÓA (`auditLogger.service.ts`)

Bảng `audit_logs` là kho dữ liệu ghi tiếp (Append-only) phục vụ giám sát và tuân thủ. Hàm ghi nhận được thiết kế mở rộng:

```typescript
export type StandardAuditEventType = 
  | 'STATE_TRANSITION' 
  | 'RETRIEVAL_TRACE' 
  | 'GUARDRAIL_VIOLATION' 
  | 'PROPOSAL_EVENT';

export interface AuditEventPayload<TDetails = Record<string, any>> {
  event_type: StandardAuditEventType | string; // Cho phép mở rộng event type tùy biến
  actor_id: string;
  actor_role: string;
  session_id?: string;
  proposal_id?: string;
  ip_address?: string;
  details: TDetails;
}

export class AuditLoggerService {
  constructor(private readonly prisma: any) {}

  async recordEvent<T>(payload: AuditEventPayload<T>): Promise<void> {
    try {
      await this.prisma.audit_logs.create({
        data: {
          event_type: payload.event_type,
          actor_id: payload.actor_id,
          actor_role: payload.actor_role,
          session_id: payload.session_id || null,
          proposal_id: payload.proposal_id || null,
          ip_address: payload.ip_address || null,
          details: payload.details as any,
          created_at: new Date(),
        }
      });
    } catch (err) {
      // Ghi log cục bộ dự phòng, không để lỗi ghi audit làm sập luồng chính của người dùng
      console.error('[CRITICAL] Không thể ghi audit log vào cơ sở dữ liệu:', err);
    }
  }
}
```

---

## 3. CHECKLIST KIỂM TOÁN
- [ ] Bảo vệ endpoint bằng `@Permissions('PROPOSAL_APPROVE')` thay vì `@Roles('REVIEWER')`.
- [ ] Mọi sự kiện vi phạm Guardrail đều kèm IP và Actor ID để điều tra bảo mật.
- [ ] Cơ chế `try-catch` dự phòng bảo đảm giao dịch nghiệp vụ của người dùng không bị gián đoạn nếu mạng DB ghi log gặp sự cố tạm thời.
