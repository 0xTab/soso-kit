---
name: git-worktree-new-folder
description: Git worktree management for creating branch directories. Use when creating new branch directories, managing multiple worktrees, or working on multiple branches simultaneously.
license: MIT
metadata:
  author: soso-kit
  version: "1.0.0"
---

# Git Worktree 分支目录操作

使用 Git worktree 功能在同一仓库中创建多个工作目录,每个目录对应不同的分支,实现并行开发。

## When to Apply

在以下场景使用此 Skill:
- 需要同时在多个分支上工作
- 想要快速切换分支而不影响当前工作
- 需要对比不同分支的代码
- 创建独立的开发环境用于测试
- 为当前分支创建新的工作目录

## How It Works

1. **查看现有 worktree**: 使用 `git worktree list` 查看所有工作树
2. **创建新 worktree**: 使用 `git worktree add` 创建新的分支目录
3. **独立开发**: 在新目录中独立进行开发工作
4. **清理 worktree**: 完成后使用 `git worktree remove` 删除

## Usage

### 查看当前 Worktree

```bash
git worktree list
```

### 创建新的分支目录

**选项 1: 基于现有分支创建新分支**
```bash
# 在父目录创建新目录,并创建新分支
git worktree add ../project-name-new-branch feature/new-branch
```

**选项 2: 基于当前分支创建新分支到新目录**
```bash
# 创建新分支并关联到新目录
git worktree add ../project-name-feature -b feature/my-feature
```

**选项 3: 使用现有分支(如 main)**
```bash
git worktree add ../project-name-main main
```

### 实际案例

假设当前项目在 `/Users/user/code/sodex-web`,当前分支是 `feature/appkit`:

```bash
# 创建新的工作目录 sodex-web-appkit
git worktree add ../sodex-web-appkit -b feature/appkit-worktree

# 结果:
# - 原目录: /Users/user/code/sodex-web (feature/appkit)
# - 新目录: /Users/user/code/sodex-web-appkit (feature/appkit-worktree)
```

### 删除 Worktree

```bash
# 方式 1: 直接删除
git worktree remove ../project-name-branch

# 方式 2: 手动删除后清理
rm -rf ../project-name-branch
git worktree prune
```

## Output

成功创建 worktree 后,你将看到:
- 新的目录被创建在指定位置
- 新目录包含完整的项目文件
- 可以在新目录中独立进行 git 操作
- 两个目录共享同一个 `.git` 仓库

## Key Benefits

- ✅ **并行开发**: 同时在多个分支工作,无需频繁切换
- ✅ **独立环境**: 每个 worktree 有独立的工作区和暂存区
- ✅ **节省空间**: 共享 `.git` 目录,不重复存储对象
- ✅ **快速对比**: 方便对比不同分支的代码差异

## Important Notes

⚠️ **限制**:
- 同一个分支不能同时被多个 worktree 使用
- 如果分支已被 checkout,需要创建新分支或使用其他分支

💡 **最佳实践**:
- 为 worktree 目录使用清晰的命名规范
- 完成工作后及时清理不需要的 worktree
- 定期使用 `git worktree prune` 清理无效引用

## References

- Source: cursor_git_worktree.md
- [Git Worktree 官方文档](https://git-scm.com/docs/git-worktree)
