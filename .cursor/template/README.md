# 精简版 Spec Kit (中文版)

轻量级规范驱动开发模板。

---

## 目录结构

```
templates/zh/
├── spec-template.md       # 需求规范
├── task-template.md       # 任务清单
├── check-template.md      # 检查清单
├── plan/
│   ├── plan-template.md   # 实现计划
│   ├── research-template.md # 技术研究
│   └── rules-template.md  # 项目规则
└── history/
    └── flow-template.md   # 需求流程图
```

---

## 工作流程

```
spec.md → plan/ → task.md → 开发 → check.md → history/
 (做什么)  (怎么做) (执行)         (验收)     (归档)
```

---

## 快速开始

```bash
# 创建功能目录
mkdir -p specs/001-功能名/plan specs/001-功能名/history

# 复制模板
cp templates/zh/spec-template.md specs/001-功能名/spec.md
cp templates/zh/task-template.md specs/001-功能名/task.md
cp templates/zh/check-template.md specs/001-功能名/check.md
cp templates/zh/plan/*.md specs/001-功能名/plan/
cp templates/zh/history/*.md specs/001-功能名/history/
```

---

## 模板说明

| 模板 | 用途 | 行数 |
|------|------|------|
| spec | 用户故事、验收标准、功能需求 | ~60 |
| task | 按故事分阶段的任务清单 | ~70 |
| check | 验收检查清单 | ~50 |
| plan | 技术方案、数据模型、API | ~80 |
| research | 技术选型研究 | ~50 |
| rules | 项目规则约束 | ~70 |
| flow | 需求流程图(Mermaid) | ~40 |

---

## 特点

- ✅ **精简**: 每个模板 < 100 行
- ✅ **实用**: 只保留必要内容
- ✅ **中文**: 全中文模板
- ✅ **流程图**: check 后自动更新
