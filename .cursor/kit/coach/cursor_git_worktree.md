# Git worktree 分支目录操作
_Exported on 1/15/2026 at 11:25:05 GMT+8 from Cursor (2.3.29)_

---

**User**

 创建分支目录

git worktree list   （查看当前创建的分支目录）
git worktree add [文件夹路径] [分支名称]     （添加新的分支目录）
 举例：git worktree add ../demo feature/demo c  1.参考上面的命令 2.将不同的分支新建一个目录 3将目前的分支生成新的目录sode-web-appkit 和sodex-web在同一个父目录

---

**Cursor**

我来帮你使用 git worktree 创建新的分支目录。让我先查看当前的状态。

当前状态：
- **工作区**：`/Users/soso/Documents/code/sodex-web`
- **当前分支**：`feature/appkit`

现在我帮你创建新的 worktree 目录 `sodex-web-appkit`。

**注意**：Git worktree 不能为已经 checkout 的分支创建新目录。你有两个选择：

### 选项 1：基于当前分支创建新分支到新目录
```bash
git worktree add ../sodex-web-appkit feature/appkit-dev -b feature/appkit-dev
```

### 选项 2：创建一个新的独立 worktree（基于 main/master）
```bash
git worktree add ../sodex-web-appkit main
```

请问你想要哪种方式？或者告诉我：
1. 新目录要使用什么分支？
2. 是否需要创建新分支？

---

如果你只是想**快速创建**一个基于当前 `feature/appkit` 的新工作目录，我可以执行：

创建成功！让我确认一下结果：

✅ **创建成功！**

### 当前 Worktree 列表

| 目录路径 | 分支 |
|---------|------|
| `/Users/soso/Documents/code/sodex-web` | `feature/appkit` |
| `/Users/soso/Documents/code/sodex-web-appkit` | `feature/appkit-worktree` (新) |

### 说明

- 新目录 `sodex-web-appkit` 已创建，与 `sodex-web` 在同一父目录下
- 新分支 `feature/appkit-worktree` 基于当前 HEAD 创建
- 两个目录共享同一个 Git 仓库，但可以独立工作在不同分支

### 常用 Worktree 命令

```bash
# 查看所有 worktree
git worktree list

# 删除 worktree（先删目录，再清理）
git worktree remove ../sodex-web-appkit

# 或手动删除后清理
rm -rf ../sodex-web-appkit
git worktree prune
```

现在你可以在 `sodex-web-appkit` 目录中独立进行开发了！

