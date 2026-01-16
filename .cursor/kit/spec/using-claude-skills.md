目的使用claude code的skill


步骤1. 了解skills
a.访问https://agentskills.io/what-are-skills了解什么是claude skill
b.访问/Users/soso/Documents/code/agent-skills/项目了解skill具体实现
c.给出结论，什么是skills,如何使用skills
d.输出一个文档在history目录

步骤2.了解项目
a.现在的项目是使用spec/plan/task/check的流程
b.了解自动化脚本执行
c.了解项目实现逻辑

步骤3.给出思路
a.结合项目以及skills
b.如何使用skills
c.给出不同的思路和方案，


步骤4.继续思考
a.Skills 在安装后自动可用。Claude 会在检测到相关任务时使用它们。
b.步骤a这个是如何实现的 
c.可以在task阶段也实现
d.给出思路

方案 3: 智能代理模式 (推荐)
核心思路
在 task 阶段引入一个"规范代理",自动分析任务并推荐/应用规范。
实现方式
1. 创建规范代理 Skill
---name: soso-kit-standards-agentdescription: 自动分析任务并推荐适用的规范和 Skills。在 task 阶段自动激活,分析任务描述和文件类型,推荐最相关的规范和检查项。---# soso-kit Standards Agent自动分析任务并推荐适用的规范。## How It Works1. 分析任务描述   - 提取关键词 (React, 组件, 性能, UI 等)   - 识别任务类型 (创建, 修改, 重构, 优化)2. 分析涉及文件   - 识别文件类型 (.tsx, .css, .ts 等)   - 提取文件路径模式 (components/, utils/, styles/ 等)3. 匹配规范和 Skills   - 基于关键词匹配   - 基于文件类型匹配   - 计算相关度并排序4. 生成检查清单   - 列出适用的规范   - 列出适用的 Skills   - 生成具体的检查项## Usage此 Skill 在 task 阶段自动激活,无需手动调用。## Output Format📋 **规范分析结果****任务类型**: 组件修改**涉及文件**: components/UserProfile.tsx**适用规范**:1. react.mdc (高优先级)   - 组件结构规范   - Props 类型定义   - Hooks 使用规范2. clean-code.mdc (中优先级)   - 命名规范   - 注释规范   - 代码结构**适用 Skills**:1. react-best-practices (推荐)   - 重点关注: 重渲染优化 (rerender-*)   - 重点关注: 性能优化 (bundle-*)2. web-design-guidelines (可选)   - 如果涉及 UI 修改,建议应用**自动生成检查清单**:- [ ] 组件命名使用 PascalCase- [ ] Props 类型完整定义- [ ] 避免内联对象/数组作为依赖- [ ] 使用 useMemo/useCallback 优化性能- [ ] 注释使用中文

**2. task.md 集成**## 执行步骤### 0. 自动规范分析 (新增)**⚠️ 自动执行: 在开始任务前,自动分析适用规范**# 自动调用 standards-agent Skill# 分析任务描述和文件列表# 输出适用规范和检查清单```### 1. 获取任务列表[原有内容]### 2. 逐步执行对于每个步骤:### 执行 Step [N]: [步骤名称]🔄 状态: 进行中📋 **适用规范** (自动检测):- react.mdc- clean-code.mdc🎯 **适用 Skills** (自动检测):- react-best-practices (重点: rerender-*, bundle-*)**操作内容:**[具体的代码修改]**规范检查** (自动):- ✅ 组件命名符合规范- ✅ Props 类型定义完整- ✅ 性能优化已应用- ⚠️ 建议: 使用 useMemo 优化计算✅ 完成

3. 实现脚本
#!/bin/bash# .cursor/commands/k/scripts/analyze-standards.sh# 分析任务并推荐规范TASK_DESC="$1"FILES=("${@:2}")echo "📋 分析任务..."echo "任务描述: $TASK_DESC"echo "涉及文件: ${FILES[*]}"echo ""# 分析文件类型echo "🔍 文件类型分析:"for file in "${FILES[@]}"; do  case "$file" in    *.tsx|*.jsx)      echo "  - React 组件: $file"      STANDARDS+=("react.mdc")      SKILLS+=("react-best-practices")      ;;    *.ts|*.js)      echo "  - TypeScript/JavaScript: $file"      STANDARDS+=("clean-code.mdc")      ;;    *.css|*.scss)      echo "  - 样式文件: $file"      SKILLS+=("web-design-guidelines")      ;;  esacdoneecho ""echo "📋 适用规范:"printf '  - %s\n' "${STANDARDS[@]}" | sort -uecho ""echo "🎯 适用 Skills:"printf '  - %s\n' "${SKILLS[@]}" | sort -u
优势
✅ 高度自动化
✅ 智能推荐
✅ 易于扩展
✅ 符合 Skills 理念

步骤5.优化现在的项目结构 .cursor/commands/k
a.保留spec,plan,check,task, research
b.rules迁移到.cursor目录下
c.其余的的文件都迁移到kit目录下
d.更新script里的.cursor/commands/k/scripts/check-prerequisites.sh文件
e.更新完之后应该保持了commands/k目录的整洁，而不影响整个已有的流程

步骤6，新增skill
a.在.cursor/commands/k新增practice.md
    第一点.这个文档的作用是详细的指导如何写出规范专业的skill文档,
    第二点, 执行这个命名的时候会读取.cursor/kit/coach里面的所有文档，将依次阅读里面的文档，将里面的文档生成skill文档，生成到.cursor/skills
c..cursor/kit/scripts新增一个script支持这个新增practice的自动化
d.核心逻辑
- 用户执行pratice.md
- 获取coach目录下面所有的文档
- 根据practice的指导/模版和规范生产对应的skill目录
- 具体细节参考.cursor/kit/history/20260116-understanding-claude-skills.md

步骤7，执行skill
a.在.cursor/commands/k新增mastery.md
b.有两种模式
c.模式1 通过command唤起，结合prompt执行对应的skills
b.模式2，结合步骤3里的方案， 智能代理模式 在执行task阶段执行
e.为了自动化 有必要可以新增一个scripts
f.更新task阶段，task阶段默认不执行skills

