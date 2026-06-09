# lm-skills install script for Windows
# Usage:
#   .\install.ps1                        # 全局安装（复制）
#   .\install.ps1 -Project               # 项目级安装
#   .\install.ps1 -Symlink               # 全局 + symlink 模式
#   .\install.ps1 -Update                # 更新：git pull + 重装
#   .\install.ps1 -Update -Project       # 更新项目级安装
#   .\install.ps1 -Target <dir>          # 装到指定目录

param(
  [switch]$Project,
  [switch]$Global,
  [switch]$Symlink,
  [switch]$Update,
  [string]$Target
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ---- Update: git pull first ----
if ($Update) {
  Write-Host "==> Updating lm-skills repo..." -ForegroundColor Cyan
  Push-Location $ScriptDir
  try {
    git pull --ff-only origin main 2>$null
    if ($LASTEXITCODE -ne 0) {
      git pull --ff-only origin master 2>$null
    }
    if ($LASTEXITCODE -ne 0) {
      Write-Host "[WARN] git pull failed — continuing with local version" -ForegroundColor Yellow
    }
  } finally {
    Pop-Location
  }
  Write-Host ""
}

# ---- Determine target directory ----
if ($Target) {
  $SkillsDir = $Target
} elseif ($Project) {
  $SkillsDir = "$(Get-Location)\.claude\skills"
} else {
  $SkillsDir = "$env:USERPROFILE\.claude\skills"
}

Write-Host "==> lm-skills installer" -ForegroundColor Cyan
Write-Host "    Repo:      $ScriptDir"
Write-Host "    Mode:      $(if ($Project) { 'project' } else { 'global' })"
Write-Host "    Symlink:   $Symlink"
Write-Host "    Target:    $SkillsDir"
Write-Host ""

New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null

$Skills = @("lm-shared", "lm-backup", "lm-clarify", "lm-solution", "lm-prd", "lm-review")

foreach ($skill in $Skills) {
  $Src = Join-Path $ScriptDir $skill
  $Dst = Join-Path $SkillsDir $skill

  if (-not (Test-Path $Src)) {
    Write-Host "[WARN] $Src not found, skipping" -ForegroundColor Yellow
    continue
  }

  Remove-Item -Recurse -Force -Path $Dst -ErrorAction SilentlyContinue

  if ($Symlink) {
    New-Item -ItemType Junction -Path $Dst -Target $Src | Out-Null
    Write-Host "[OK] $skill -> junction" -ForegroundColor Green
  } else {
    Copy-Item -Recurse -Path $Src -Destination $Dst
    Write-Host "[OK] $skill -> copied" -ForegroundColor Green
  }
}

Write-Host ""
Write-Host "Done! lm-skills installed to $SkillsDir" -ForegroundColor Cyan
Write-Host "Restart Claude Code or start a new conversation to use."
