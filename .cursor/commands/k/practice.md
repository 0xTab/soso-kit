---
description: 从 coach 文档生成标准 Skills
scripts:
  sh: ../../kit/scripts/generate-skill.sh
---

# Practice: Skill 生成器

**目的**: 将 coach 目录中的文档转换为标准的 Claude Skills

---

## 📚 什么是 Skills?

Skills 是模块化的指令包,用于扩展 AI 编码助手的能力。它们遵循 [agentskills.io](https://agentskills.io/) 标准。

### Skills 的核心特性

- **按需加载**: 仅在相关时加载,优化上下文使用
- **自动触发**: 通过 description 字段自动匹配任务
- **标准化**: 遵循开放标准,跨平台可移植
- **模块化**: 独立的目录结构,易于维护

---

## 🎯 使用场景

### 何时使用 practice 命令?

当你有以下需求时:
1. **规范文档** → 转换为 Skill,让 AI 自动应用
2. **最佳实践** → 封装为 Skill,确保一致性
3. **知识文档** → 转换为 Skill,按需加载
4. **指南手册** → 转换为 Skill,智能推荐

---

## 📝 Skill 编写规范

### 标准目录结构

```
.cursor/skills/
└── {skill-name}/              # kebab-case 命名
    ├── SKILL.md               # 必需: Skill 定义 (大写!)
    ├── scripts/               # 可选: 可执行脚本
    ├── references/            # 可选: 参考文档
    └── metadata.json          # 可选: 元数据
```

### SKILL.md 必需格式

```markdown
---
name: skill-name               # kebab-case
description: 一句话描述,包含触发短语
license: MIT
metadata:
  author: author-name
  version: "1.0.0"
---

# Skill 标题

简要描述 Skill 的功能和用途。

## When to Apply

列出何时应该使用此 Skill:
- 场景 1
- 场景 2

## How It Works

1. 步骤 1
2. 步骤 2
3. 步骤 3

## Usage

```bash
# 使用示例或说明
```

## Output

描述 Skill 的输出格式

## References

- 参考资料链接
```

### 关键设计原则

| 原则 | 要求 | 说明 |
|------|------|------|
| **简洁性** | SKILL.md < 500 行 | 详细内容放 references/ |
| **清晰性** | description 包含触发短语 | 帮助 Claude 自动匹配 |
| **效率性** | 渐进式披露 | 按需加载详细内容 |
| **可执行性** | 优先使用脚本 | 脚本不消耗 token |

---

## 🚀 工作流程

### 步骤 1: 准备源文档

将你的文档放入 `.cursor/kit/coach/` 目录:

```bash
.cursor/kit/coach/
├── react-best-practices.md
├── typescript-guidelines.md
└── api-design-principles.md
```

**文档要求**:
- Markdown 格式 (.md)
- 第一行为标题 (# 标题)
- 内容清晰,结构完整

### 步骤 2: 执行生成命令

```bash
# 方式 1: 通过 Cursor 命令
/k/practice

# 方式 2: 直接运行脚本
bash .cursor/kit/scripts/generate-skill.sh
```

### 步骤 3: 验证生成结果

检查 `.cursor/skills/` 目录:

```bash
.cursor/skills/
├── react-best-practices/
│   ├── SKILL.md
│   └── references/
│       └── original.md
├── typescript-guidelines/
│   └── SKILL.md
└── api-design-principles/
    └── SKILL.md
```

### 步骤 4: 优化 Skill (可选)

生成后,你可以手动优化:
1. 完善 description (添加更多触发短语)
2. 补充 "When to Apply" 场景
3. 添加 scripts/ 目录实现自动化
4. 在 references/ 添加更多参考资料

---

## 📋 生成规则

### 自动处理

脚本会自动:
- ✅ 将文件名转换为 kebab-case 作为 skill 名称
- ✅ 提取第一行作为 Skill 标题
- ✅ 创建标准的目录结构
- ✅ 生成符合规范的 SKILL.md
- ✅ 复制原始文档到 references/

### 命名规范

| 源文件名 | Skill 目录名 |
|----------|-------------|
| `React Best Practices.md` | `react-best-practices/` |
| `TypeScript_Guidelines.md` | `typescript-guidelines/` |
| `API Design.md` | `api-design/` |

### 跳过规则

如果 Skill 目录已存在,脚本会跳过,避免覆盖已优化的 Skill。

---

## 💡 最佳实践

### 1. 源文档质量

**好的源文档**:
```markdown
# React Performance Optimization

## Core Principles

1. Minimize re-renders
2. Optimize bundle size
3. Use proper memoization

## Guidelines

### Avoid Inline Objects
...
```

**不好的源文档**:
```markdown
一些零散的笔记
没有清晰的结构
...
```

### 2. Description 优化

**好的 description**:
```yaml
description: React performance optimization guidelines. Use when optimizing React components, reducing re-renders, or improving bundle size.
```

**不好的 description**:
```yaml
description: React stuff
```

### 3. 渐进式优化

```
第一次生成 → 基础 Skill
     ↓
手动优化 → 完善 description 和场景
     ↓
添加脚本 → 实现自动化
     ↓
持续迭代 → 根据使用反馈优化
```

---

## 🔍 验证检查

生成后,检查以下项目:

- [ ] SKILL.md 文件存在且格式正确
- [ ] name 字段使用 kebab-case
- [ ] description 包含触发短语
- [ ] 标题清晰明确
- [ ] references/ 目录包含原始文档
- [ ] 目录结构符合标准

---

## 📚 参考资料

- [agentskills.io](https://agentskills.io/) - Skills 官方标准
- `.cursor/kit/docs/what-is-claude-skills.md` - Skills 深度理解
- [anthropics/skills](https://github.com/anthropics/skills) - 官方示例

---

## 🎉 下一步

生成 Skills 后:

1. **测试触发**: 尝试相关任务,看 Skill 是否自动激活
2. **优化 description**: 添加更多触发短语
3. **添加自动化**: 在 scripts/ 目录添加脚本
4. **分享复用**: 可以打包为 .zip 分享给团队

---

**提示**: 这是一个迭代过程。先快速生成基础 Skill,然后根据实际使用情况持续优化!
