# ==============================================================================
# PreInvocation Guardrail Reminder in PowerShell
# Fast, native, zero dependency
# Output pure ASCII JSON with \uXXXX escaping to prevent console codepage corruption
# ==============================================================================

$reminderText = @'
🔴 [NHẮC NHỞ KỶ LUẬT CỐT TỬ AGENT - TUYỆT ĐỐI KHÔNG ĐƯỢC QUÊN]:
1. MINH BẠCH THAO TÁC NGẦM & HỌC TẬP GIT (scratch/agent_observations.md):
   - Khi chạy lệnh Git (git status, git log, git diff...) hoặc quét hệ thống ngầm, BẮT BUỘC cập nhật snapshot vào scratch/agent_observations.md.
   - BẮT BUỘC áp dụng quy chuẩn 3 phần cho người nhập môn: Mã lệnh & Cờ lệnh -> Output nguyên văn 100% -> Bóc tách giải nghĩa chi tiết từng dòng.
2. KỶ LUẬT THƯ MỤC & SCRATCHPAD (ZERO ROOT POLLUTION & SELF-CLEANING):
   - CẤM TUYỆT ĐỐI tạo script tạm (.ps1, .py, .sh, .tmp) tại thư mục gốc workspace (/).
   - Mọi công cụ kiểm tra ad-hoc, debug nhanh BẮT BUỘC đặt trong scratch/.
   - TỰ ĐỘNG DỌN DẸP: Xóa sạch các script tạm trong scratch/ ngay sau khi hoàn thành tác vụ.
3. BẢO TOÀN TRI THỨC TUYỆT ĐỐI (ZERO CONTENT LOSS):
   - Bất biến 13 tệp tài liệu tham chiếu gốc của Google Antigravity trong references/.
   - Bất biến các tài liệu dự án trong docs/ (GASCOLAE_Ke_Hoach_MVP_7_Ngay_VI.md, SkyLink_Bao_Cao_De_Xuat_Du_An.md).
4. KIỂM TOÁN TRƯỚC - SỬA ĐỔI SAU (AUDIT-FIRST):
   - Đối chiếu diff, giải thích lý do, xin ý kiến Người Dùng trước khi can thiệp vào các tệp cấu hình cốt lõi.
   - Bắt buộc chạy kiểm định sau khi sửa: powershell -ExecutionPolicy Bypass -File .agents/scripts/verify_refactoring.ps1.
5. TIẾT LỘ LŨY TIẾN (PROGRESSIVE DISCLOSURE):
   - Thư mục references/ là tri thức kỹ thuật tĩnh; chỉ mở ra khi Người Dùng yêu cầu cập nhật/bảo trì để tối ưu token.
'@

$payload = @{
    injectSteps = @(
        @{
            ephemeralMessage = $reminderText
        }
    )
}

$rawJson = $payload | ConvertTo-Json -Depth 5 -Compress
$sb = [System.Text.StringBuilder]::new()
foreach ($ch in $rawJson.ToCharArray()) {
    $code = [int]$ch
    if ($code -gt 127) {
        [void]$sb.AppendFormat('\u{0:x4}', $code)
    } else {
        [void]$sb.Append($ch)
    }
}

[Console]::Out.Write($sb.ToString())
exit 0
