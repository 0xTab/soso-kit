#!/bin/bash

# analyze-standards.sh
# 分析任务并推荐适用的规范和 Skills
# 用法: bash analyze-standards.sh "任务描述" [file1] [file2] ...

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_DIR="$(dirname "$SCRIPT_DIR")"
CURSOR_DIR="$(dirname "$KIT_DIR")"
RULES_DIR="$CURSOR_DIR/rules"
SKILLS_DIR="$CURSOR_DIR/skills"

# 参数
TASK_DESC="$1"
shift
FILES=("$@")

# 数组存储结果
declare -a STANDARDS
declare -a SKILLS
declare -a CHECKLIST

echo -e "${BLUE}📋 规范分析结果${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 分析任务描述
echo -e "${CYAN}📝 任务描述${NC}: $TASK_DESC"
echo ""

# 识别任务类型
TASK_TYPE="修改"
if [[ "$TASK_DESC" =~ (创建|新建|添加|新增|create|add|new) ]]; then
    TASK_TYPE="创建"
elif [[ "$TASK_DESC" =~ (重构|refactor|restructure) ]]; then
    TASK_TYPE="重构"
elif [[ "$TASK_DESC" =~ (优化|性能|performance|optimize) ]]; then
    TASK_TYPE="优化"
elif [[ "$TASK_DESC" =~ (修复|fix|bug) ]]; then
    TASK_TYPE="修复"
fi
echo -e "${CYAN}🎯 任务类型${NC}: $TASK_TYPE"
echo ""

# 分析关键词
echo -e "${BLUE}🔍 关键词分析${NC}"

# React 相关
if [[ "$TASK_DESC" =~ (React|组件|Component|Hook|useState|useEffect) ]]; then
    STANDARDS+=("react.mdc")
    SKILLS+=("react-best-practices")
    CHECKLIST+=("组件命名使用 PascalCase")
    CHECKLIST+=("Props 类型完整定义")
    CHECKLIST+=("Hooks 使用规范")
    echo "  - 检测到 React 相关关键词"
fi

# 性能相关
if [[ "$TASK_DESC" =~ (性能|优化|Performance|useMemo|useCallback) ]]; then
    STANDARDS+=("clean-code.mdc")
    SKILLS+=("react-best-practices")
    CHECKLIST+=("避免内联对象/数组作为依赖")
    CHECKLIST+=("使用 useMemo/useCallback 优化性能")
    echo "  - 检测到性能相关关键词"
fi

# Git/分支相关
if [[ "$TASK_DESC" =~ (Git|git|分支|branch|worktree|目录) ]]; then
    SKILLS+=("git-worktree-new-folder")
    echo "  - 检测到 Git 相关关键词"
fi

# UI/样式相关
if [[ "$TASK_DESC" =~ (UI|样式|Style|CSS|设计|design) ]]; then
    SKILLS+=("web-design-guidelines")
    echo "  - 检测到 UI/样式相关关键词"
fi

echo ""

# 分析涉及文件
if [ ${#FILES[@]} -gt 0 ]; then
    echo -e "${BLUE}📂 涉及文件${NC}"
    for file in "${FILES[@]}"; do
        echo "  - $file"
        case "$file" in
            *.tsx|*.jsx)
                STANDARDS+=("react.mdc")
                STANDARDS+=("clean-code.mdc")
                SKILLS+=("react-best-practices")
                CHECKLIST+=("组件结构规范")
                ;;
            *.ts|*.js)
                STANDARDS+=("clean-code.mdc")
                CHECKLIST+=("命名规范一致")
                CHECKLIST+=("错误处理完善")
                ;;
            *.css|*.scss|*.less)
                SKILLS+=("web-design-guidelines")
                CHECKLIST+=("样式命名规范")
                ;;
            *.md)
                STANDARDS+=("regular.mdc")
                CHECKLIST+=("注释使用中文")
                ;;
        esac
    done
    echo ""
fi

# 始终添加通用规范
STANDARDS+=("regular.mdc")
CHECKLIST+=("注释使用中文，简洁格式")

# 去重
STANDARDS=($(printf '%s\n' "${STANDARDS[@]}" | sort -u))
SKILLS=($(printf '%s\n' "${SKILLS[@]}" | sort -u))
CHECKLIST=($(printf '%s\n' "${CHECKLIST[@]}" | sort -u))

# 输出适用规范
echo -e "${GREEN}📋 适用规范${NC}"
if [ ${#STANDARDS[@]} -gt 0 ]; then
    priority=1
    for std in "${STANDARDS[@]}"; do
        if [ -f "$RULES_DIR/$std" ]; then
            if [ "$std" = "react.mdc" ]; then
                echo "  $priority. $std (高优先级) ✅"
                echo "     - 组件结构规范"
                echo "     - Props 类型定义"
                echo "     - Hooks 使用规范"
            elif [ "$std" = "clean-code.mdc" ]; then
                echo "  $priority. $std (中优先级) ✅"
                echo "     - 命名规范"
                echo "     - 注释规范"
                echo "     - 代码结构"
            else
                echo "  $priority. $std ✅"
            fi
        else
            echo "  $priority. $std ⚠️ (文件不存在)"
        fi
        ((priority++))
    done
else
    echo "  无特定规范"
fi
echo ""

# 输出适用 Skills
echo -e "${GREEN}🎯 适用 Skills${NC}"
if [ ${#SKILLS[@]} -gt 0 ]; then
    priority=1
    for skill in "${SKILLS[@]}"; do
        skill_dir="$SKILLS_DIR/$skill"
        if [ -d "$skill_dir" ]; then
            echo "  $priority. $skill (推荐) ✅"
            # 读取 description
            if [ -f "$skill_dir/SKILL.md" ]; then
                desc=$(grep "^description:" "$skill_dir/SKILL.md" | head -1 | sed 's/description: //')
                echo "     - ${desc:0:60}..."
            fi
        else
            echo "  $priority. $skill ⚠️ (Skill 不存在)"
        fi
        ((priority++))
    done
else
    echo "  无特定 Skills"
fi
echo ""

# 输出检查清单
echo -e "${YELLOW}✅ 自动生成检查清单${NC}"
for item in "${CHECKLIST[@]}"; do
    echo "  - [ ] $item"
done
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}分析完成!${NC}"
