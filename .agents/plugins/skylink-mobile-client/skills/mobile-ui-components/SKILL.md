---
name: mobile-ui-components
description: Hướng dẫn xây dựng các component giao diện React Native đặc thù cho SkyLink Mobile, bao gồm Thanh tiến độ trích xuất nhu cầu, Form bổ sung thông tin thiếu, Thẻ dịch vụ đề xuất kèm ngăn kéo dẫn chứng Evidence Drawer và Trình xem PDF.
---

# KỸ NĂNG XÂY DỰNG COMPONENT GIAO DIỆN DI ĐỘNG (mobile-ui-components)

## 1. NGUYÊN TẮC THIẾT KẾ ĐỘNG (PROP-DRIVEN MOBILE COMPONENTS)
Component giao diện phía Mobile Client cần được thiết kế có tính tái sử dụng cao, không gắn cứng số lượng trường hoặc tên miền cố định:
- **Thanh tiến độ linh hoạt**: Tính toán tỷ lệ phần trăm động dựa trên `completedCount / totalRequiredCount` thay vì chia cứng mẫu số `4`.
- **Form nhập liệu động (`MissingFieldsClarificationInput`)**: Render input type thích hợp (textarea, number, selector) dựa trên metadata của trường thiếu.
- **Evidence Drawer & Comparison**: Cho phép truyền mảng linh hoạt 2–N dịch vụ hoặc N dẫn chứng.

---

## 2. CÁC COMPONENT GIAO DIỆN CỐT LÕI

### 2.1. Thanh Tiến Độ Nhu Cầu Tự Động (`RequirementsProgressBar.tsx`):
```tsx
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

interface RequirementsProgressBarProps {
  requiredFieldKeys: string[];
  fulfilledFieldKeys: string[];
  themeColors?: {
    low?: string;
    medium?: string;
    complete?: string;
    background?: string;
  };
}

export const RequirementsProgressBar: React.FC<RequirementsProgressBarProps> = ({
  requiredFieldKeys,
  fulfilledFieldKeys,
  themeColors = {
    low: '#F59E0B',     // Cam
    medium: '#3B82F6',  // Xanh dương
    complete: '#10B981',// Xanh lá
    background: '#E5E7EB'
  }
}) => {
  const total = Math.max(requiredFieldKeys.length, 1);
  const completed = fulfilledFieldKeys.filter(k => requiredFieldKeys.includes(k)).length;
  const ratio = Math.min(completed / total, 1.0);
  const percentage = Math.round(ratio * 100);

  const getProgressColor = () => {
    if (ratio >= 1.0) return themeColors.complete;
    if (ratio >= 0.5) return themeColors.medium;
    return themeColors.low;
  };

  return (
    <View style={styles.container}>
      <View style={styles.labelRow}>
        <Text style={styles.titleText}>Tiến độ thu thập nhu cầu</Text>
        <Text style={[styles.percentText, { color: getProgressColor() }]}>
          {completed}/{total} ({percentage}%)
        </Text>
      </View>
      <View style={[styles.track, { backgroundColor: themeColors.background }]}>
        <View style={[styles.bar, { width: `${percentage}%`, backgroundColor: getProgressColor() }]} />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { marginVertical: 8, paddingHorizontal: 12 },
  labelRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 4 },
  titleText: { fontSize: 13, fontWeight: '600', color: '#374151' },
  percentText: { fontSize: 13, fontWeight: '700' },
  track: { height: 8, borderRadius: 4, overflow: 'hidden' },
  bar: { height: '100%', borderRadius: 4 },
});
```

---

### 2.2. Ngăn Kéo Dẫn Chứng Đa Dạng (`EvidenceDrawerBottomSheet.tsx`):
- Nhận mảng `evidenceChunks: Array<{ sourceId: string; title: string; quote: string; verified: boolean }>` qua props.
- Khi người dùng bấm chip dẫn chứng, ngăn kéo vuốt từ dưới lên hiển thị chi tiết căn cứ và tên cơ quan thẩm định.

---

### 2.3. Thẻ So Sánh Dịch Vụ Mở Rộng (`ServiceComparisonView.tsx`):
- Nhận danh sách 2–3 dịch vụ cần đối đầu.
- Tự động quét các thông số chung (Tải trọng, SLA, Cảm biến, Độ dốc) và highlight điểm khác biệt.

---

### 2.4. Trình Xem Proposal PDF Nhúng:
- Cho phép truyền `pdfUrl` hoặc `base64String` linh hoạt.
- Tự động hiển thị huy hiệu xác thực hoặc hình mờ sơ bộ tùy theo trạng thái `proposal.status`.
