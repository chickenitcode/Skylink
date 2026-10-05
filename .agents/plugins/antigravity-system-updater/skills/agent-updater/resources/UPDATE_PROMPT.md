# 🔄 KỊCH BẢN KIỂM TOÁN & ĐỒNG BỘ CẬP NHẬT ANTIGRAVITY (UPDATE_PROMPT.md)

Tài liệu này lưu trữ **Prompt tiêu chuẩn** dùng khi Antigravity IDE phát hành phiên bản mới, hoặc khi bạn muốn kiểm tra xem có tính năng, công cụ, lifecycle hook hay quy chuẩn cấu hình mới nào được bổ sung vào hệ thống hay không.

---

## CÁCH SỬ DỤNG
Khi Antigravity IDE cập nhật hoặc định kỳ hàng quý, bạn chỉ cần **copy nguyên văn khối lệnh Prompt bên dưới** và dán vào khung chat với Agent:

```markdown
=== YÊU CẦU KIỂM TOÁN VÀ ĐỒNG BỘ CẬP NHẬT GOOGLE ANTIGRAVITY ===

Hệ thống vừa có bản cập nhật mới (hoặc tôi muốn kiểm tra tính năng mới của Antigravity IDE).
Hãy thực hiện quy trình kiểm toán 4 bước nghiêm ngặt sau mà KHÔNG ĐƯỢC trả lời nịnh nọt/làm hài lòng:

1. QUÉT TÀI LIỆU & BUILTIN MỚI:
   - Quét toàn bộ thư mục builtin của IDE tại:
     `C:\Users\Admin\.gemini\antigravity-ide\builtin\skills/`
     hoặc tài liệu tham chiếu chuẩn tại `.agents/plugins/antigravity-system-updater/references/`.
   - Tìm kiếm xem có:
     * Hook events mới nào không? (ngoài PreInvocation, PreToolUse, PostToolUse, PostInvocation, Stop).
     * Tool schema hoặc format mới nào trong SKILL.md không?
     * Cấu trúc JSON config mới nào không? (ngoài hooks.json, mcp_config.json, skills.json, plugins.json).
     * Slash commands hay subagent workflows mới nào không?

2. ĐỐI CHIẾU DIFF VỚI KHÔNG GIAN HIỆN TẠI:
   - So sánh trực tiếp với thư mục `.agents/` hiện tại của workspace.
   - Lập bảng so sánh rõ ràng:
     [Tính năng mới] | [Ý nghĩa kỹ thuật] | [Workspace hiện tại đã có chưa?] | [Có nên áp dụng không và Tại sao?]

3. NGUYÊN TẮC BẢO TOÀN DỮ LIỆU (ZERO CONTENT LOSS):
   - Mọi đề xuất cập nhật TUYỆT ĐỐI KHÔNG ĐƯỢC làm mất hay ghi đè 12 file tài liệu kỹ thuật cá nhân trong `references/` và 8 bộ quy tắc trong `rules/`.
   - Nếu có tính năng mới hữu ích: Hãy soạn sẵn plan để tích hợp mà vẫn giữ nguyên tri thức cũ.
   - Nếu KHÔNG CÓ GÌ MỚI: Báo cáo trung thực "Không có thay đổi kỹ thuật nào mới, hệ thống hiện tại đã tương thích 100% với bản cập nhật".

4. HỎI Ý KIẾN TRƯỚC KHI GHI FILE:
   - Trình bày báo cáo diff và chờ tôi xác nhận trước khi thực hiện bất kỳ chỉnh sửa nào vào `.agents/`.
```

---

## NGUYÊN TẮC TIẾT LỘ LŨY TIẾN LIÊN QUAN
Theo [updater_discipline.md](../../../rules/updater_discipline.md):
- Thư mục `.agents/plugins/antigravity-system-updater/references/` là tài liệu tham khảo kỹ thuật tĩnh của IDE.
- Agent **CHỈ ĐƯỢC PHÉP ĐỌC** khi bạn kích hoạt Prompt cập nhật này hoặc khi bạn yêu cầu tạo/sửa Skills và Rules.
- Trong mọi phiên làm việc thông thường, thư mục này được cách ly hoàn toàn để tiết kiệm 70-85% token.
