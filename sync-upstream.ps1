#!/usr/bin/env pwsh
# 同步上游代码的脚本

Write-Host "🔄 开始同步上游代码..." -ForegroundColor Yellow

# 1. 获取上游最新代码
Write-Host "📥 获取上游最新代码..." -ForegroundColor Blue
git fetch upstream

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 获取上游代码失败！" -ForegroundColor Red
    exit 1
}

# 2. 显示上游更新
Write-Host "📊 上游更新情况:" -ForegroundColor Green
git log --oneline main..upstream/main --no-merges | Select-Object -First 10

$commitCount = (git rev-list main..upstream/main --count)
if ($commitCount -eq 0) {
    Write-Host "✅ 已是最新，无需同步！" -ForegroundColor Green
    exit 0
}

Write-Host "🔢 上游有 $commitCount 个新提交" -ForegroundColor Yellow

# 3. 询问是否继续
$continue = Read-Host "是否继续同步？[y/N]"
if ($continue -ne 'y' -and $continue -ne 'Y') {
    Write-Host "🚫 取消同步" -ForegroundColor Yellow
    exit 0
}

# 4. 创建备份分支
$backupBranch = "backup-before-sync-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Write-Host "💾 创建备份分支: $backupBranch" -ForegroundColor Blue
git branch $backupBranch

# 5. 合并上游代码
Write-Host "🔀 开始合并上游代码..." -ForegroundColor Blue
git merge upstream/main --no-edit

if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  合并过程中出现冲突！" -ForegroundColor Red
    Write-Host "请手动解决冲突后运行: git commit" -ForegroundColor Yellow
    Write-Host "如需回滚，运行: git reset --hard $backupBranch" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ 上游代码同步完成！" -ForegroundColor Green
Write-Host "💡 建议运行测试确保一切正常" -ForegroundColor Cyan
Write-Host "📤 如需推送到你的仓库，运行: git push origin main" -ForegroundColor Cyan
