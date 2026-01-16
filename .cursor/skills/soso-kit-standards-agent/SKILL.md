---
name: soso-kit-standards-agent
description: 自动分析任务并推荐适用的规范和 Skills。在 task 阶段自动激活,分析任务描述和文件类型,推荐最相关的规范和检查项。Use when executing tasks, analyzing code standards, or checking best practices.
license: MIT
metadata:
  author: soso-kit
  version: "1.0.0"
---

# soso-kit Standards Agent

自动分析任务并推荐适用的规范和 Skills。

## When to Apply

在以下场景使用此 Skill:
- 执行 `/k/task` 任务时
- 需要分析代码规范时
- 执行 `/k/mastery` 智能代理模式时
- 想要了解当前任务适用哪些规范和 Skills

## How It Works

### 1. 分析任务描述
- 提取关键词 (React, 组件, 性能, UI, API 等)
- 识别任务类型 (创建, 修改, 重构, 优化)

### 2. 分析涉及文件
- 识别文件类型 (.tsx, .css, .ts, .md 等)
- 提取文件路径模式 (components/, utils/, styles/ 等)

### 3. 匹配规范和 Skills
- 基于关键词匹配
- 基于文件类型匹配
- 计算相关度并排序

### 4. 生成检查清单
- 列出适用的规范
- 列出适用的 Skills
- 生成具体的检查项

## Usage

### 自动激活
此 Skill 在 task 阶段可选激活,通过 `/k/mastery` 命令调用。

### 手动调用
```bash
# 分析任务并推荐规范
bash .cursor/kit/scripts/analyze-standards.sh "任务描述" file1.tsx file2.ts
```

## Matching Rules

### 文件类型 → 规范/Skills 映射

| 文件类型 | 适用规范 | 适用 Skills |
|----------|----------|-------------|
| `.tsx`, `.jsx` | react.mdc, clean-code.mdc | react-best-practices |
| `.ts`, `.js` | clean-code.mdc | - |
| `.css`, `.scss` | - | web-design-guidelines |
| `.md` | regular.mdc | - |

### 关键词 → 规范/Skills 映射

| 关键词 | 适用规范 | 适用 Skills |
|--------|----------|-------------|
| React, 组件, Component | react.mdc | react-best-practices |
| 性能, 优化, Performance | clean-code.mdc | react-best-practices |
| UI, 样式, Style | - | web-design-guidelines |
| API, 接口, Fetch | clean-code.mdc | - |
| Git, 分支, Worktree | - | git-worktree-new-folder |

## Output Format

```
📋 **规范分析结果**

**任务类型**: [创建/修改/重构/优化]
**涉及文件**: [文件列表]

**适用规范**:
1. react.mdc (高优先级)
   - 组件结构规范
   - Props 类型定义
   - Hooks 使用规范
2. clean-code.mdc (中优先级)
   - 命名规范
   - 注释规范
   - 代码结构

**适用 Skills**:
1. react-best-practices (推荐)
   - 重点关注: 重渲染优化
   - 重点关注: 性能优化
2. web-design-guidelines (可选)
   - 如果涉及 UI 修改,建议应用

**自动生成检查清单**:
- [ ] 组件命名使用 PascalCase
- [ ] Props 类型完整定义
- [ ] 避免内联对象/数组作为依赖
- [ ] 使用 useMemo/useCallback 优化性能
- [ ] 注释使用中文
```

## Integration with Task

当在 task 阶段启用智能代理模式时:

```markdown
### 执行 Step [N]: [步骤名称]

🔄 状态: 进行中

📋 **适用规范** (自动检测):
- react.mdc
- clean-code.mdc

🎯 **适用 Skills** (自动检测):
- react-best-practices (重点: rerender-*, bundle-*)

**操作内容:**
[具体的代码修改]

**规范检查** (自动):
- ✅ 组件命名符合规范
- ✅ Props 类型定义完整
- ✅ 性能优化已应用
- ⚠️ 建议: 使用 useMemo 优化计算

✅ 完成
```

## Advantages

- ✅ **高度自动化**: 无需手动查找适用规范
- ✅ **智能推荐**: 基于任务和文件类型智能匹配
- ✅ **易于扩展**: 可以轻松添加新的匹配规则
- ✅ **符合 Skills 理念**: 按需加载,上下文高效

## References

- `.cursor/rules/react.mdc` - React 组件规范
- `.cursor/rules/clean-code.mdc` - 代码规范
- `.cursor/rules/regular.mdc` - 通用规范
- `.cursor/kit/scripts/analyze-standards.sh` - 分析脚本
