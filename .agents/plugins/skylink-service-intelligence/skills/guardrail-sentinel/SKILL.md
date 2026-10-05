---
name: guardrail-sentinel
description: Bộ công cụ triển khai 2 tầng Guardrails (Pre-check Policy Filter & Post-check Citation Grounding Auditor) để phát hiện và ngăn chặn 100% ảo giác về giá, tiến độ, SLA trong hệ thống GASCOLAE SkyLink.
---

# KỸ NĂNG BẢO VỆ 2 TẦNG GUARDRAIL SENTINEL (guardrail-sentinel)

## 1. NGUYÊN TẮC THIẾT KẾ ĐỘNG (POLICY-DRIVEN GUARDRAILS)
Để tránh tình trạng quy tắc kiểm soát bị "đóng cứng", hệ thống Guardrail của SkyLink được thiết kế theo mô hình **Chính Sách Cấu Hình (Policy-Driven)**:
- **Tách biệt Logic và Quy tắc**: Danh sách tiền tệ, từ khóa nhạy cảm, mức độ tương thích và quyền truy cập được định nghĩa qua đối tượng cấu hình hoặc cơ sở dữ liệu.
- **Tiền kiểm linh hoạt (Pre-check Policy)**: Lọc dữ liệu dựa trên quyền hạn thực tế (`Permission-based`) thay vì gán cứng tên Role.
- **Hậu kiểm mở rộng (Post-check Rules)**: Cho phép thêm các bộ kiểm tra tùy biến (Custom Validators) mà không phải sửa mã nguồn lõi.

---

## 2. TRIỂN KHAI TẦNG 1: PRE-CHECK POLICY FILTER LINH HOẠT

```typescript
export interface ChunkContext {
  chunk_id: string;
  service_id: string;
  content: string;
  visibility: 'public' | 'internal' | 'restricted';
  status: string;
}

export interface PreCheckPolicy {
  allowedStatuses: string[];       // Mặc định: ['verified']
  canViewRestricted: boolean;      // Suy luận từ quyền SERVICE_VIEW_RESTRICTED
  maxContextBudget?: number;       // Giới hạn số chunk tối đa nạp vào LLM
}

export function applyPreCheckGuardrail(
  chunks: ChunkContext[],
  policy: PreCheckPolicy
): ChunkContext[] {
  const allowedSet = new Set(policy.allowedStatuses);

  const filtered = chunks.filter(chunk => {
    // 1. Kiểm tra trạng thái xác minh theo cấu hình
    if (!allowedSet.has(chunk.status)) {
      return false;
    }
    // 2. Chặn chunk restricted nếu không có quyền
    if (chunk.visibility === 'restricted' && !policy.canViewRestricted) {
      return false;
    }
    return true;
  });

  return policy.maxContextBudget ? filtered.slice(0, policy.maxContextBudget) : filtered;
}
```

---

## 3. TRIỂN KHAI TẦNG 2: POST-CHECK DỰA TRÊN POLICY (`postCheckGuardrail.ts`)

```typescript
import { z } from 'zod';

export interface GuardrailValidationRule {
  name: string;
  validate: (output: any, context: { providedChunkIds: Set<string> }) => { passed: boolean; message?: string };
}

export interface GuardrailPolicyConfig {
  pricePatterns?: RegExp[];
  prohibitedClaims?: string[];
  customRules?: GuardrailValidationRule[];
}

// Cấu hình mặc định có thể ghi đè
export const defaultGuardrailPolicy: GuardrailPolicyConfig = {
  pricePatterns: [
    /(\b\d+[\.,]?\d*\s*(vnđ|vnd|triệu|ngàn|k|usd|\$)\b)/i,
    /(chiết khấu\s*\d+%\b)/i,
  ],
  prohibitedClaims: [
    'cam kết 100%',
    'chính xác tuyệt đối',
    'hoàn tiền ngay',
    'không thể xảy ra lỗi',
  ],
};

export class GuardrailAuditor {
  constructor(private readonly policy: GuardrailPolicyConfig = defaultGuardrailPolicy) {}

  verifyResponse(
    output: { rationale: string; evidence_chunk_ids: string[]; items_to_confirm?: string[] },
    providedChunkIds: Set<string>
  ): { valid: boolean; violations: string[] } {
    const violations: string[] = [];

    // 1. Kiểm toán Citation (Bắt buộc)
    for (const cid of output.evidence_chunk_ids) {
      if (!providedChunkIds.has(cid)) {
        violations.push(`ẢO GIÁC DẪN CHỨNG: Chunk '${cid}' không nằm trong tập tri thức tra cứu!`);
      }
    }

    // 2. Kiểm toán Từ khóa Báo Giá (theo danh sách regex cấu hình)
    const patterns = this.policy.pricePatterns || [];
    for (const regex of patterns) {
      if (regex.test(output.rationale)) {
        violations.push(`VI PHẠM BÁO GIÁ: Phát hiện tuyên bố giá chưa kiểm chứng theo mẫu '${regex.source}'`);
        break;
      }
    }

    // 3. Kiểm toán Tuyên bố Tuyệt đối Cấm Đoán
    const blockedClaims = this.policy.prohibitedClaims || [];
    const lowerRationale = output.rationale.toLowerCase();
    for (const claim of blockedClaims) {
      if (lowerRationale.includes(claim.toLowerCase())) {
        violations.push(`TUYÊN BỐ CẤM: Phát hiện cam kết tuyệt đối vi phạm kỷ luật pháp lý: '${claim}'`);
      }
    }

    // 4. Chạy các rule tùy biến bổ sung nếu có
    if (this.policy.customRules) {
      for (const rule of this.policy.customRules) {
        const result = rule.validate(output, { providedChunkIds });
        if (!result.passed && result.message) {
          violations.push(result.message);
        }
      }
    }

    return {
      valid: violations.length === 0,
      violations,
    };
  }
}
```

---

## 4. CHECKLIST BẢO MẬT & TELEMETRY
- [ ] Cho phép nạp cấu hình chính sách từ biến môi trường hoặc bảng `system_policies`.
- [ ] Mọi vi phạm đều được đóng gói thành mảng `violations` chi tiết và ghi nhận vào bảng `audit_logs` với loại sự kiện `GUARDRAIL_VIOLATION`.
- [ ] Cơ chế Fallback an toàn tự động chuyển các câu trả lời vi phạm sang trạng thái yêu cầu xác minh tại hiện trường.
