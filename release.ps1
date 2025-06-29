#!/usr/bin/env pwsh
# 发布独立版本的脚本

param(
    [string]$Version,
    [string]$Message = "Release OttoSU v$Version"
)

if (-not $Version) {
    Write-Host "❌ 请提供版本号！" -ForegroundColor Red
    Write-Host "用法: .\release.ps1 -Version '1.0.0' [-Message 'Release message']" -ForegroundColor Yellow
    exit 1
}

Write-Host "🚀 开始发布 OttoSU v$Version..." -ForegroundColor Yellow

# 1. 检查工作区状态
$status = git status --porcelain
if ($status) {
    Write-Host "⚠️  工作区有未提交的更改：" -ForegroundColor Red
    git status --short
    $continue = Read-Host "是否继续？[y/N]"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        exit 1
    }
}

# 2. 创建版本标签
Write-Host "🏷️  创建版本标签..." -ForegroundColor Blue
git tag -a "v$Version" -m "$Message"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 创建标签失败！" -ForegroundColor Red
    exit 1
}

# 3. 推送到远程仓库
Write-Host "📤 推送代码和标签到远程仓库..." -ForegroundColor Blue
git push origin main
git push origin "v$Version"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 推送失败！" -ForegroundColor Red
    Write-Host "🔄 删除本地标签..." -ForegroundColor Yellow
    git tag -d "v$Version"
    exit 1
}

Write-Host "✅ OttoSU v$Version 发布成功！" -ForegroundColor Green
Write-Host "🔗 GitHub地址: https://github.com/axelpln/OttoSU/releases" -ForegroundColor Cyan
