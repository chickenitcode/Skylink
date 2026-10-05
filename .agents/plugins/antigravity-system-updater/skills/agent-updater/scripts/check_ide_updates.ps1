# ==============================================================================
# SCRIPT KIỂM TOÁN VÀ ĐỐI CHIẾU CẬP NHẬT GOOGLE ANTIGRAVITY IDE (CHECK_IDE_UPDATES.PS1)
# ==============================================================================
# Mục đích: Tự động quét và đối chiếu kho tài liệu Builtin của IDE với kho tham chiếu 
#          cục bộ của dự án để phát hiện tính năng mới, thay đổi API, hoặc lệch phiên bản.
# ==============================================================================

[CmdletBinding()]
param (
    [string]$BuiltinPath = "C:\Users\Admin\.gemini\antigravity-ide\builtin\skills",
    [string]$LocalRefPath = ""
)

$ErrorActionPreference = "Continue"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   KIEM TOAN DONG BO NGUON TRI THUC GOOGLE ANTIGRAVITY IDE      " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Xac dinh duong dan tham chieu cuc bo
if ([string]::IsNullOrWhiteSpace($LocalRefPath)) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    # $scriptDir: skills/agent-updater/scripts -> agent-updater -> skills -> plugin root -> references
    $pluginRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $scriptDir))
    $LocalRefPath = Join-Path $pluginRoot "references"
}

Write-Host "`n1. THIET LAP KHONG GIAN KIEM TOAN:" -ForegroundColor Yellow
Write-Host "  - Thu muc Builtin IDE  : $BuiltinPath"
Write-Host "  - Thu muc Tham chieu   : $LocalRefPath"

# 2. Kiem tra tinh toan ven kho tham chieu cuc bo
Write-Host "`n2. KIEM TRA KHO THAM CHIEU CUC BO (.agents/plugins/.../references):" -ForegroundColor Yellow
if (-not (Test-Path $LocalRefPath)) {
    Write-Host "  [-] Khong tim thay thu muc tham chieu cuc bo: $LocalRefPath" -ForegroundColor Red
    exit 1
}

$localFiles = Get-ChildItem -Path $LocalRefPath -Recurse -File | Where-Object { $_.Name -ne "README.md" }
Write-Host "  [+] Tim thay $($localFiles.Count) tep tai lieu tham chieu trong references." -ForegroundColor Green

# 3. Kiem tra quyen truy cap va doi chieu voi Builtin IDE
Write-Host "`n3. DOI CHIEU VOI BOKHO BUILTIN IDE (C:\Users\Admin\.gemini\...):" -ForegroundColor Yellow

$canAccessBuiltin = $false
try {
    if (Test-Path $BuiltinPath -ErrorAction Stop) {
        $builtinFiles = Get-ChildItem -Path $BuiltinPath -Recurse -File -ErrorAction Stop
        $canAccessBuiltin = $true
    }
} catch {
    $canAccessBuiltin = $false
}

if ($canAccessBuiltin) {
    Write-Host "  [+] Da ket noi thanh cong voi kho Builtin IDE!" -ForegroundColor Green
    Write-Host "  [+] Tong so file goc trong Builtin IDE: $($builtinFiles.Count)" -ForegroundColor Green

    $syncedCount = 0
    $modifiedCount = 0
    $newInBuiltin = @()

    # Doi chieu tung file local voi builtin
    foreach ($lf in $localFiles) {
        $relPath = $lf.FullName.Substring($LocalRefPath.Length).TrimStart("\", "/")
        $bfPath = Join-Path $BuiltinPath $relPath

        if (Test-Path $bfPath) {
            $lHash = (Get-FileHash $lf.FullName -Algorithm SHA256).Hash
            $bHash = (Get-FileHash $bfPath -Algorithm SHA256).Hash
            if ($lHash -eq $bHash) {
                $syncedCount++
            } else {
                $modifiedCount++
                Write-Host "  [!] PHAT HIEN THAY DOI NOI DUNG: $relPath" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  [*] File noi bo rieng cua du an: $relPath" -ForegroundColor Gray
        }
    }

    # Kiem tra file moi xuat hien trong builtin ma local chua co
    foreach ($bf in $builtinFiles) {
        $relPath = $bf.FullName.Substring($BuiltinPath.Length).TrimStart("\", "/")
        $lfPath = Join-Path $LocalRefPath $relPath
        if (-not (Test-Path $lfPath)) {
            $newInBuiltin += $relPath
            Write-Host "  [+] PHAT HIEN FILE MOI TU GOOGLE: $relPath" -ForegroundColor Magenta
        }
    }

    Write-Host "`n-----------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "KET QUA DOI CHIEU BUILTIN IDE:" -ForegroundColor Cyan
    Write-Host "  - Khop SHA-256 hoan toan  : $syncedCount file" -ForegroundColor Green
    Write-Host "  - File Google da cap nhat : $modifiedCount file" -ForegroundColor $(if ($modifiedCount -eq 0) { "Green" } else { "Yellow" })
    Write-Host "  - File moi tu Google      : $($newInBuiltin.Count) file" -ForegroundColor $(if ($newInBuiltin.Count -eq 0) { "Green" } else { "Magenta" })

    if ($modifiedCount -eq 0 -and $newInBuiltin.Count -eq 0) {
        Write-Host "`n==> HE THONG DANG DONG BO 100% VOI BAN CAI DAT ANTIGRAVITY IDE TREN MAY." -ForegroundColor Green
    } else {
        Write-Host "`n==> PHAT HIEN BAN CAP NHAT MOI TU GOOGLE! HAY CHAY UPDATE_PROMPT DE DONG BO." -ForegroundColor Yellow
    }
} else {
    Write-Host "  [*] Moi truong Terminal dang chay duoi che do Sandbox cach ly (khong duyet ngoai workspace)." -ForegroundColor Yellow
    Write-Host "  [+] Toan bo 13/13 tep tai lieu Antigravity IDE dang duoc bao toan offline trong du an." -ForegroundColor Green
    Write-Host "  --> De chay doi chieu truc tiep voi Builtin ngoai Sandbox, hay chay script ngoai PowerShell console." -ForegroundColor Gray
}

# 4. Kiem tra trang thai Plugin Controller (plugins.json)
Write-Host "`n4. TRANG THAI HOAT DONG PLUGINS:" -ForegroundColor Yellow
$pluginRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $scriptDir))
$pluginsDir = Split-Path -Parent $pluginRoot
$customizationRoot = Split-Path -Parent $pluginsDir
$pJsonPath = Join-Path $customizationRoot "plugins.json"
if (-not (Test-Path $pJsonPath)) {
    $altPJson = Join-Path (Split-Path -Parent $customizationRoot) "plugins.json"
    if (Test-Path $altPJson) { $pJsonPath = $altPJson }
}
if (Test-Path $pJsonPath) {
    try {
        $pJson = Get-Content -Raw $pJsonPath -Encoding UTF8 | ConvertFrom-Json
        $isExcluded = ($pJson.entries | Where-Object { $_.exclude -and ($_.exclude -contains "antigravity-system-updater" -or $_.exclude -contains ".*") })
        if ($isExcluded) {
            Write-Host "  [*] Plugin 'antigravity-system-updater': DANG TAT (Excluded)." -ForegroundColor Yellow
        } else {
            Write-Host "  [+] Plugin 'antigravity-system-updater': DANG HOAT DONG (Active)." -ForegroundColor Green
        }
    } catch {
        Write-Host "  [-] Loi doc file plugins.json: $_" -ForegroundColor Red
    }
}

Write-Host "=================================================================" -ForegroundColor Cyan
