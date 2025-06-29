# OttoSU 开发工作流程

## 仓库结构说明

- **origin**: `https://github.com/axelpln/OttoSU.git` (你的独立仓库)
- **upstream**: `https://github.com/SukiSU-Ultra/SukiSU-Ultra.git` (上游源仓库)

## 日常开发流程

### 1. 独立开发
在main分支上直接开发你的独立功能：
```powershell
# 正常的开发流程
git add .
git commit -m "Add new feature for OttoSU"
git push origin main
```

### 2. 同步上游代码
使用提供的脚本同步上游更新：
```powershell
# 运行同步脚本
.\sync-upstream.ps1

# 如果有冲突，手动解决后：
git add .
git commit -m "Merge upstream changes"
git push origin main
```

### 3. 发布版本
使用发布脚本创建版本：
```powershell
# 发布新版本
.\release.ps1 -Version "1.0.0" -Message "First stable release of OttoSU"
```

## 分支策略建议

### 主要分支
- `main`: 主开发分支，包含你的独立功能和上游同步

### 特性分支（可选）
如果开发大功能，可以创建特性分支：
```powershell
# 创建特性分支
git checkout -b feature/new-awesome-feature

# 开发完成后合并
git checkout main
git merge feature/new-awesome-feature
git branch -d feature/new-awesome-feature
```

## 冲突处理策略

### 同步上游时的冲突
1. 运行 `.\sync-upstream.ps1`
2. 如果出现冲突，脚本会提示
3. 手动解决冲突文件
4. 运行 `git add .` 和 `git commit`
5. 推送：`git push origin main`

### 常见冲突文件
- `README.md`: 保留你的版本，必要时合并上游的重要更新
- 配置文件: 优先保留你的自定义配置
- 核心功能: 仔细评估上游修改，选择性合并

## 备份策略

每次同步上游前，脚本会自动创建备份分支：
```powershell
# 查看备份分支
git branch | grep backup

# 如需回滚到某个备份
git reset --hard backup-before-sync-20250629-143000
```

## 最佳实践

1. **定期同步**: 建议每周或每月同步一次上游代码
2. **小步提交**: 经常提交你的更改，便于冲突解决
3. **测试验证**: 同步后务必测试核心功能
4. **文档更新**: 及时更新你的独立功能文档
5. **版本标签**: 重要版本及时打标签

## 紧急回滚

如果同步出现严重问题：
```powershell
# 回滚到最近的备份
git reset --hard backup-before-sync-YYYYMMDD-HHMMSS

# 或回滚到指定提交
git reset --hard HEAD~1

# 强制推送（谨慎使用）
git push origin main --force
```
