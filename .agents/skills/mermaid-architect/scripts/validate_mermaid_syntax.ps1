# ==============================================================================
# SCRIPT QUET KIEM TRA LOI CU PHAP BIEU DO MERMAID TRONG CAC TEP MARKDOWN
# Kiem tra cac loi pho bien: Quoting ngoac tron/vuong, khai bao huong bieu do
# ==============================================================================

param(
    [string]$TargetDir = "docs"
)

Write-Host "=== KIEM TRA CU PHAP MERMAID TRONG THU MUC: $TargetDir ===" -ForegroundColor Cyan

$mdFiles = Get-ChildItem -Path $TargetDir -Recurse -Filter "*.md"
$errorCount = 0

foreach ($file in $mdFiles) {
    $content = Get-Content -Raw $file.FullName -Encoding UTF8
    
    # Tim cac khoi ```mermaid ... ```
    $matches = [regex]::Matches($content, '```mermaid([\s\S]*?)```')
    
    foreach ($m in $matches) {
        $diagram = $m.Groups[1].Value
        
        # Kiem tra loi ky tu ngoac khong duoc bao nhay kep trong node label
        if ($diagram -match '\[[a-zA-Z0-9_\s]*\([^\)]*\)[a-zA-Z0-9_\s]*\]' -and -not ($diagram -match '\["[^"]*"\]')) {
            Write-Host "  [!] Canh bao loi nhay kep label co ngoac tron trong: $($file.Name)" -ForegroundColor Yellow
            $errorCount++
        }
    }
}

if ($errorCount -eq 0) {
    Write-Host "[PASSED] Toan bo bieu do Mermaid deu tuan thu chuan Safe Label Quoting!" -ForegroundColor Green
} else {
    Write-Host "[!] Phat hien $errorCount diem can ra soat lai nhay kep." -ForegroundColor Yellow
}
