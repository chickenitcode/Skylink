# ==============================================================================
# SCRIPT KIỂM TOÁN TOÀN DIỆN HỆ THỐNG AGENT & PLUGINS (.AGENTS / .AGENT)
# Chuẩn Google Antigravity Customization Architecture
# ==============================================================================

$ErrorActionPreference = "Continue"
$allPassed = $true

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   KIEM TOAN TOAN DIEN HE THONG AGENT & PLUGINS (ANTIGRAVITY)    " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$agentsRoot = Split-Path -Parent $scriptDir
$workspaceRoot = Split-Path -Parent $agentsRoot

Write-Host "`n1. KIEM TRA KHONG GIAN CUSTOMIZATION ROOT (.agents):" -ForegroundColor Yellow
if (Test-Path $agentsRoot) {
    Write-Host "  [+] Thu muc goc .agents ton tai: $agentsRoot" -ForegroundColor Green
} else {
    Write-Host "  [-] Khong tim thay thu muc goc .agents!" -ForegroundColor Red
    $allPassed = $false
}

Write-Host "`n2. KIEM TRA BANG DIEU KHIEN PLUGINS.JSON:" -ForegroundColor Yellow
$pluginsJsonPath = Join-Path $agentsRoot "plugins.json"
if (Test-Path $pluginsJsonPath) {
    try {
        $pJson = Get-Content -Raw $pluginsJsonPath -Encoding UTF8 | ConvertFrom-Json
        $hasUpdater = $pJson.entries | Where-Object { $_.path -like "*antigravity-system-updater*" }
        if ($hasUpdater) {
            Write-Host "  [+] plugins.json hop le: da dang ky 'antigravity-system-updater'." -ForegroundColor Green
        } else {
            Write-Host "  [-] plugins.json chua dang ky plugin 'antigravity-system-updater'!" -ForegroundColor Red
            $allPassed = $false
        }
    } catch {
        Write-Host "  [-] plugins.json bi loi cu phap JSON: $_" -ForegroundColor Red
        $allPassed = $false
    }
} else {
    Write-Host "  [-] Thieu file .agents/plugins.json!" -ForegroundColor Red
    $allPassed = $false
}

Write-Host "`n3. KIEM TRA PLUGIN antigravity-system-updater:" -ForegroundColor Yellow
$pluginDir = Join-Path $agentsRoot "plugins\antigravity-system-updater"
if (-not (Test-Path $pluginDir)) {
    Write-Host "  [-] Khong tim thay thu muc plugin: $pluginDir" -ForegroundColor Red
    $allPassed = $false
} else {
    # 3.1 plugin.json
    $pManifest = Join-Path $pluginDir "plugin.json"
    if (Test-Path $pManifest) {
        try {
            $manifestJson = Get-Content -Raw $pManifest -Encoding UTF8 | ConvertFrom-Json
            if ($manifestJson.name -eq "antigravity-system-updater") {
                Write-Host "  [+] plugin.json hop le (name: $($manifestJson.name))." -ForegroundColor Green
            } else {
                Write-Host "  [-] plugin.json name khong hop le: $($manifestJson.name)" -ForegroundColor Red
                $allPassed = $false
            }
        } catch {
            Write-Host "  [-] plugin.json loi cu phap: $_" -ForegroundColor Red
            $allPassed = $false
        }
    } else {
        Write-Host "  [-] Thieu plugin.json trong thu muc plugin!" -ForegroundColor Red
        $allPassed = $false
    }

    # 3.2 rules/updater_discipline.md
    $ruleFile = Join-Path $pluginDir "rules\updater_discipline.md"
    if (Test-Path $ruleFile) {
        Write-Host "  [+] rules/updater_discipline.md ton tai hop le." -ForegroundColor Green
    } else {
        Write-Host "  [-] Thieu rules/updater_discipline.md!" -ForegroundColor Red
        $allPassed = $false
    }

    # 3.3 skills/agent-updater/SKILL.md
    $skillMd = Join-Path $pluginDir "skills\agent-updater\SKILL.md"
    if (Test-Path $skillMd) {
        $content = Get-Content -Raw $skillMd -Encoding UTF8
        if ($content -match '^---\s*\r?\nname:\s*agent-updater\r?\ndescription:\s*>?-?([\s\S]*?)\r?\n---') {
            Write-Host "  [+] skills/agent-updater/SKILL.md hop le frontmatter chuẩn Antigravity." -ForegroundColor Green
        } else {
            Write-Host "  [-] skills/agent-updater/SKILL.md frontmatter khong dung chuan!" -ForegroundColor Red
            $allPassed = $false
        }
    } else {
        Write-Host "  [-] Thieu skills/agent-updater/SKILL.md!" -ForegroundColor Red
        $allPassed = $false
    }

    # 3.4 resources/UPDATE_PROMPT.md
    $promptMd = Join-Path $pluginDir "skills\agent-updater\resources\UPDATE_PROMPT.md"
    if (Test-Path $promptMd) {
        Write-Host "  [+] skills/agent-updater/resources/UPDATE_PROMPT.md ton tai." -ForegroundColor Green
    } else {
        Write-Host "  [-] Thieu resources/UPDATE_PROMPT.md!" -ForegroundColor Red
        $allPassed = $false
    }

    # 3.5 scripts/check_ide_updates.ps1
    $scriptCheck = Join-Path $pluginDir "skills\agent-updater\scripts\check_ide_updates.ps1"
    if (Test-Path $scriptCheck) {
        Write-Host "  [+] skills/agent-updater/scripts/check_ide_updates.ps1 ton tai." -ForegroundColor Green
    } else {
        Write-Host "  [-] Thieu scripts/check_ide_updates.ps1!" -ForegroundColor Red
        $allPassed = $false
    }

    # 3.6 references kho tai lieu
    $refDir = Join-Path $pluginDir "references"
    if (Test-Path $refDir) {
        $refFiles = Get-ChildItem -Path $refDir -Recurse -File
        Write-Host "  [+] references: Tim thay $($refFiles.Count) tep tai lieu tham chieu goc." -ForegroundColor Green
        if ($refFiles.Count -ge 13) {
            Write-Host "  [+] references day du 13/13 tep theo chuan Antigravity IDE." -ForegroundColor Green
        } else {
            Write-Host "  [!] references thieu tep: hien co $($refFiles.Count)/13!" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [-] Thieu thu muc references!" -ForegroundColor Red
        $allPassed = $false
    }

    # 3.7 hooks.json va script guardrail_reminder.ps1
    $hookFile = Join-Path $pluginDir "hooks.json"
    if (Test-Path $hookFile) {
        try {
            $hJson = Get-Content -Raw $hookFile -Encoding UTF8 | ConvertFrom-Json
            if ($hJson."guardrail-reminder".PreInvocation) {
                Write-Host "  [+] hooks.json ton tai va da cau hinh PreInvocation hook." -ForegroundColor Green
            } else {
                Write-Host "  [-] hooks.json chua cau hinh PreInvocation!" -ForegroundColor Red
                $allPassed = $false
            }
        } catch {
            Write-Host "  [-] hooks.json loi cu phap JSON: $_" -ForegroundColor Red
            $allPassed = $false
        }
    } else {
        Write-Host "  [-] Thieu file hooks.json trong plugin!" -ForegroundColor Red
        $allPassed = $false
    }

    $reminderScript = Join-Path $pluginDir "scripts\guardrail_reminder.ps1"
    if (Test-Path $reminderScript) {
        try {
            $outReminder = & powershell.exe -ExecutionPolicy Bypass -File $reminderScript
            if ($LASTEXITCODE -eq 0 -and $outReminder -like "*injectSteps*") {
                Write-Host "  [+] scripts/guardrail_reminder.ps1 chay thanh cong, sinh injectSteps hop le." -ForegroundColor Green
            } else {
                Write-Host "  [-] scripts/guardrail_reminder.ps1 tra ve loi hoac khong dung dinh dang!" -ForegroundColor Red
                $allPassed = $false
            }
        } catch {
            Write-Host "  [-] Loi thuc thi scripts/guardrail_reminder.ps1: $_" -ForegroundColor Red
            $allPassed = $false
        }
    } else {
        Write-Host "  [-] Thieu script scripts/guardrail_reminder.ps1!" -ForegroundColor Red
        $allPassed = $false
    }
}

# 3.8 Kiem tra SKILL mermaid-architect
Write-Host "`n3.8 KIEM TRA WORKSPACE SKILL: mermaid-architect:" -ForegroundColor Yellow
$mermaidDir = Join-Path $agentsRoot "skills\mermaid-architect"
if (Test-Path $mermaidDir) {
    $mSkillMd = Join-Path $mermaidDir "SKILL.md"
    if (Test-Path $mSkillMd) {
        $mContent = Get-Content -Raw $mSkillMd -Encoding UTF8
        if ($mContent -match '^---\s*\r?\nname:\s*mermaid-architect') {
            Write-Host "  [+] skills/mermaid-architect/SKILL.md hop le frontmatter chuẩn Antigravity." -ForegroundColor Green
        } else {
            Write-Host "  [-] skills/mermaid-architect/SKILL.md frontmatter khong dung chuan!" -ForegroundColor Red
            $allPassed = $false
        }
    } else {
        Write-Host "  [-] Thieu skills/mermaid-architect/SKILL.md!" -ForegroundColor Red
        $allPassed = $false
    }

    $subDirs = @("scripts", "examples", "resources", "references")
    $hasAllSubs = $true
    foreach ($sd in $subDirs) {
        if (-not (Test-Path (Join-Path $mermaidDir $sd))) { $hasAllSubs = $false }
    }
    if ($hasAllSubs) {
        Write-Host "  [+] Day du 4 thanh phan: scripts/, examples/, resources/, references/." -ForegroundColor Green
    }
} else {
    Write-Host "  [-] Thieu thu muc skills/mermaid-architect!" -ForegroundColor Red
    $allPassed = $false
}

# 3.9 Kiem tra WORKSPACE SKILL: e2e-demo-orchestrator
Write-Host "`n3.9 KIEM TRA WORKSPACE SKILL: e2e-demo-orchestrator:" -ForegroundColor Yellow
$e2eDir = Join-Path $agentsRoot "skills\e2e-demo-orchestrator"
if (Test-Path $e2eDir) {
    $e2eSkillMd = Join-Path $e2eDir "SKILL.md"
    if (Test-Path $e2eSkillMd) {
        $e2eContent = Get-Content -Raw $e2eSkillMd -Encoding UTF8
        if ($e2eContent -match '^---\s*\r?\nname:\s*e2e-demo-orchestrator') {
            Write-Host "  [+] skills/e2e-demo-orchestrator/SKILL.md hop le frontmatter chuẩn Antigravity." -ForegroundColor Green
        } else {
            Write-Host "  [-] skills/e2e-demo-orchestrator/SKILL.md frontmatter khong dung chuan!" -ForegroundColor Red
            $allPassed = $false
        }
    } else {
        Write-Host "  [-] Thieu skills/e2e-demo-orchestrator/SKILL.md!" -ForegroundColor Red
        $allPassed = $false
    }

    $subDirs = @("scripts", "examples", "resources", "references")
    $hasAllSubs = $true
    foreach ($sd in $subDirs) {
        if (-not (Test-Path (Join-Path $e2eDir $sd))) { $hasAllSubs = $false }
    }
    if ($hasAllSubs) {
        Write-Host "  [+] Day du 4 thanh phan: scripts/, examples/, resources/, references/." -ForegroundColor Green
    }
} else {
    Write-Host "  [-] Thieu skills/e2e-demo-orchestrator/!" -ForegroundColor Red
    $allPassed = $false
}

# 3.10 Kiem tra 3 SKYLINK BUSINESS PLUGINS
Write-Host "`n3.10 KIEM TRA CAC SKYLINK PLUGINS MO RONG:" -ForegroundColor Yellow
$skylinkPlugins = @(
    @{ name = "skylink-service-intelligence"; skills = @("canonical-chunker", "hybrid-retrieval", "guardrail-sentinel", "ai-golden-evaluator"); rule = "rules/guardrail_discipline.md" },
    @{ name = "skylink-workflow-engine"; skills = @("stateful-consultation", "proposal-pipeline", "devops-docker-libreoffice", "rbac-audit-sentinel"); rule = "rules/workflow_state_discipline.md" },
    @{ name = "skylink-mobile-client"; skills = @("expo-mobile-architect", "mobile-ui-components"); rule = "rules/mobile_architecture_discipline.md" }
)

foreach ($sp in $skylinkPlugins) {
    $spDir = Join-Path $agentsRoot "plugins\$($sp.name)"
    if (Test-Path $spDir) {
        $spManifest = Join-Path $spDir "plugin.json"
        if (Test-Path $spManifest) {
            Write-Host "  [+] Plugin '$($sp.name)': plugin.json hop le." -ForegroundColor Green
        } else {
            Write-Host "  [-] Plugin '$($sp.name)': Thieu plugin.json!" -ForegroundColor Red
            $allPassed = $false
        }

        $spRule = Join-Path $spDir $sp.rule
        if (Test-Path $spRule) {
            Write-Host "  [+] Plugin '$($sp.name)': rule $($sp.rule) ton tai." -ForegroundColor Green
        } else {
            Write-Host "  [-] Plugin '$($sp.name)': Thieu rule $($sp.rule)!" -ForegroundColor Red
            $allPassed = $false
        }

        foreach ($sk in $sp.skills) {
            $skDir = Join-Path $spDir "skills\$sk"
            $skPath = Join-Path $skDir "SKILL.md"
            if (Test-Path $skPath) {
                Write-Host "      [+] Skill '$sk' ton tai hop le." -ForegroundColor Green
                $subDirs = @("scripts", "examples", "resources", "references")
                $hasAllSubs = $true
                foreach ($sd in $subDirs) {
                    $sdPath = Join-Path $skDir $sd
                    if (-not (Test-Path $sdPath)) {
                        $hasAllSubs = $false
                    }
                }
                if ($hasAllSubs) {
                    Write-Host "          [+] Day du 4 thanh phan: scripts/, examples/, resources/, references/." -ForegroundColor Green
                } else {
                    Write-Host "          [!] Chua du 4 thanh phan mo rong!" -ForegroundColor Yellow
                }
            } else {
                Write-Host "      [-] Thieu Skill '$sk' tai $skPath!" -ForegroundColor Red
                $allPassed = $false
            }
        }
    } else {
        Write-Host "  [-] Khong tim thay thu muc plugin: $spDir" -ForegroundColor Red
        $allPassed = $false
    }
}

# 3.11 Kiem tra WORKSPACE RULES (.agents/rules/)
Write-Host "`n3.11 KIEM TRA QUY TAC QUAN TRI WORKSPACE (.agents/rules/):" -ForegroundColor Yellow
$rulesDir = Join-Path $agentsRoot "rules"
$expectedRules = @("skylink_monorepo.md", "security_data_sanitization.md", "proposal_legal_compliance.md")
if (Test-Path $rulesDir) {
    foreach ($rFile in $expectedRules) {
        $rPath = Join-Path $rulesDir $rFile
        if (Test-Path $rPath) {
            Write-Host "  [+] Quy tac $rFile ton tai hop le." -ForegroundColor Green
        } else {
            Write-Host "  [-] Thieu quy tac $rFile!" -ForegroundColor Red
            $allPassed = $false
        }
    }
} else {
    Write-Host "  [-] Thieu thu muc .agents/rules/!" -ForegroundColor Red
    $allPassed = $false
}

Write-Host "`n4. CHAY THUC TE SCRIPT check_ide_updates.ps1:" -ForegroundColor Yellow
try {
    $scriptCheck = Join-Path $pluginDir "skills\agent-updater\scripts\check_ide_updates.ps1"
    & powershell -ExecutionPolicy Bypass -File $scriptCheck
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [+] Script check_ide_updates.ps1 thuc thi thanh cong (Exit code 0)." -ForegroundColor Green
    } else {
        Write-Host "  [-] Script check_ide_updates.ps1 bao loi (Exit code $LASTEXITCODE)!" -ForegroundColor Red
        $allPassed = $false
    }
} catch {
    Write-Host "  [-] Loi thuc thi script check_ide_updates.ps1: $_" -ForegroundColor Red
    $allPassed = $false
}

Write-Host "`n5. KIEM TRA KHONG GIAN WORKSPACE & MINH BACH SCRATCH/:" -ForegroundColor Yellow
$docsDir = Join-Path $workspaceRoot "docs"
$reportsDir = Join-Path $workspaceRoot "reports"
$scratchDir = Join-Path $workspaceRoot "scratch"

if (Test-Path $docsDir) {
    $docFiles = Get-ChildItem -Path $docsDir -File
    Write-Host "  [+] docs/ ton tai ($($docFiles.Count) tep tai lieu)." -ForegroundColor Green
} else {
    Write-Host "  [-] Thieu thu muc docs/!" -ForegroundColor Red
    $allPassed = $false
}

if (Test-Path $reportsDir) {
    Write-Host "  [+] reports/ ton tai hop le." -ForegroundColor Green
} else {
    Write-Host "  [-] Thieu thu muc reports/!" -ForegroundColor Red
    $allPassed = $false
}

if (Test-Path $scratchDir) {
    Write-Host "  [+] scratch/ ton tai hop le." -ForegroundColor Green
    $obsTemplate = Join-Path $scratchDir "agent_observations.template.md"
    if (Test-Path $obsTemplate) {
        Write-Host "  [+] scratch/agent_observations.template.md ton tai hop le." -ForegroundColor Green
    } else {
        Write-Host "  [-] Thieu scratch/agent_observations.template.md!" -ForegroundColor Red
        $allPassed = $false
    }

    $obsLog = Join-Path $scratchDir "agent_observations.md"
    if (Test-Path $obsLog) {
        Write-Host "  [+] scratch/agent_observations.md ton tai (Co nhat ky minh bach)." -ForegroundColor Green
    } else {
        Write-Host "  [!] scratch/agent_observations.md chua khoi tao." -ForegroundColor Yellow
    }
} else {
    Write-Host "  [-] Thieu thu muc scratch/!" -ForegroundColor Red
    $allPassed = $false
}

Write-Host "`n=================================================================" -ForegroundColor Cyan
if ($allPassed) {
    Write-Host "   KET QUA: 100% TAT CA CAC TIEU CHI KIEM TOAN DEU PASSED!       " -ForegroundColor Green
} else {
    Write-Host "   KET QUA: CO TIEU CHI CHUA DAT YEU CAU (FAILED).              " -ForegroundColor Red
    exit 1
}
Write-Host "=================================================================" -ForegroundColor Cyan
