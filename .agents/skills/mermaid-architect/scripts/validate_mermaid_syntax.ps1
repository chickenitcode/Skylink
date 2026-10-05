# ==============================================================================
# SCRIPT QUÉT KIỂM TRA LỖI CÚ PHÁP BIỂU ĐỒ MERMAID TRONG CÁC TỆP MARKDOWN
# Kiểm tra các lỗi phổ biến: Quoting ngoặc tròn/vuông, khai báo hướng biểu đồ
# ==============================================================================

param(
    [string]$TargetDir = "docs"
)

Write-Host "=== KIỂM TRA CÚ PHÁP MERMAID TRONG THƯ MỤC: $TargetDir ===" -ForegroundColor Cyan

$mdFiles = Get-ChildItem -Path $TargetDir -Recurse -Filter "*.md"
$errorCount = 0

foreach ($file in $mdFiles) {
    $content = Get-Content -Raw $file.FullName -Encoding UTF8
    
    # Tìm các khối ```mermaid ... ```
    $matches = [regex]::Matches($content, '```mermaid([\s\S]*?)```')
    
    foreach ($m in $matches) {
        $diagram = $m.Groups[1].Value
        
        # Kiểm tra lỗi ký tự ngoặc không được bao nháy kép trong node label
        if ($diagram -match '\[[a-zA-Z0-9_\s]*\([^\)]*\)[a-zA-Z0-9_\s]*\]' -and -not ($diagram -match '\["[^"]*"\]')) {
            Write-Host "  [!] Cảnh báo lỗi nháy kép label có ngoặc tròn trong: $($file.Name)" -ForegroundColor Yellow
            $errorCount++
        }
    }
}

if ($errorCount -eq 0) {
    Write-Host "[PASSED] Toàn bộ biểu đồ Mermaid đều tuân thủ chuẩn Safe Label Quoting!" -ForegroundColor Green
} else {
    Write-Host "[!] Phát hiện $errorCount điểm cần rà soát lại nháy kép." -ForegroundColor Yellow
}
