#!/usr/bin/env bash

# Kit 工作流前置检查脚本
# 用于检查工作流执行的前置条件
# 包括：target 目录文档检测、history 目录检测、history 更新策略

set -e

JSON_MODE=false
TARGET_DIR=""
FEATURE_KEYWORD=""

while [ $# -gt 0 ]; do
    case "$1" in
        --json) JSON_MODE=true ;;
        --target)
            shift
            TARGET_DIR="$1"
            ;;
        --feature)
            shift
            FEATURE_KEYWORD="$1"
            ;;
        --help|-h)
            echo "Usage: $0 [--json] [--target <dir>] [--feature <keyword>]"
            echo ""
            echo "检查 Kit 工作流的前置条件"
            echo ""
            echo "Options:"
            echo "  --json              输出 JSON 格式"
            echo "  --target <dir>      指定 target 目录路径"
            echo "  --feature <keyword> 功能关键词（用于匹配 history 文档）"
            echo "  --help              显示帮助信息"
            exit 0
            ;;
    esac
    shift
done

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_DIR="$(dirname "$SCRIPT_DIR")"
HISTORY_DIR="$KIT_DIR/history"

# 尝试获取项目根目录
if git rev-parse --show-toplevel >/dev/null 2>&1; then
    PROJECT_ROOT=$(git rev-parse --show-toplevel)
else
    PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$KIT_DIR")")")"
fi

# 默认 target 目录为 specs/
if [ -z "$TARGET_DIR" ]; then
    TARGET_DIR="$PROJECT_ROOT/specs"
fi

# ============================================
# 检查 target 目录（需求文档）
# ============================================
TARGET_EXISTS=false
TARGET_FILES=()
TARGET_HAS_SPEC=false

if [ -d "$TARGET_DIR" ]; then
    TARGET_EXISTS=true
    # 获取 target 目录下的 .md 文件
    while IFS= read -r -d '' file; do
        filename="$(basename "$file")"
        TARGET_FILES+=("$filename")
        # 检查是否有 spec.md 文件
        if [ "$filename" = "spec.md" ]; then
            TARGET_HAS_SPEC=true
        fi
    done < <(find "$TARGET_DIR" -maxdepth 2 -name "*.md" -print0 2>/dev/null)
fi

TARGET_COUNT=${#TARGET_FILES[@]}

# 确定需求来源
if [ "$TARGET_HAS_SPEC" = true ] || [ $TARGET_COUNT -gt 0 ]; then
    SPEC_SOURCE="target"
else
    SPEC_SOURCE="prompt"
fi

# ============================================
# 检查 history 目录
# ============================================
HISTORY_EXISTS=false
HISTORY_FILES=()
HISTORY_MATCHED_FILE=""
HISTORY_UPDATE_MODE="new"  # new = 新建, incremental = 增量更新

if [ -d "$HISTORY_DIR" ]; then
    HISTORY_EXISTS=true
    while IFS= read -r -d '' file; do
        filename="$(basename "$file")"
        HISTORY_FILES+=("$filename")
        
        # 如果提供了功能关键词，尝试匹配相关文档
        if [ -n "$FEATURE_KEYWORD" ]; then
            # 将关键词转为小写进行匹配
            keyword_lower=$(echo "$FEATURE_KEYWORD" | tr '[:upper:]' '[:lower:]')
            filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
            
            if [[ "$filename_lower" == *"$keyword_lower"* ]]; then
                HISTORY_MATCHED_FILE="$filename"
                HISTORY_UPDATE_MODE="incremental"
            fi
        fi
    done < <(find "$HISTORY_DIR" -maxdepth 1 -name "*.md" -print0 2>/dev/null)
fi

HISTORY_COUNT=${#HISTORY_FILES[@]}

# 如果有历史文件但没有匹配到，取最新的文件作为参考
if [ $HISTORY_COUNT -gt 0 ] && [ -z "$HISTORY_MATCHED_FILE" ]; then
    # 获取最新修改的文件
    LATEST_FILE=$(ls -t "$HISTORY_DIR"/*.md 2>/dev/null | head -1)
    if [ -n "$LATEST_FILE" ]; then
        HISTORY_LATEST_FILE="$(basename "$LATEST_FILE")"
    fi
fi

# ============================================
# 输出结果
# ============================================
if $JSON_MODE; then
    # JSON 输出
    printf '{'
    printf '"PROJECT_ROOT":"%s",' "$PROJECT_ROOT"
    printf '"KIT_DIR":"%s",' "$KIT_DIR"
    
    # Target 信息
    printf '"TARGET_DIR":"%s",' "$TARGET_DIR"
    printf '"TARGET_EXISTS":%s,' "$TARGET_EXISTS"
    printf '"TARGET_COUNT":%d,' "$TARGET_COUNT"
    printf '"TARGET_HAS_SPEC":%s,' "$TARGET_HAS_SPEC"
    printf '"TARGET_FILES":['
    first=true
    for file in "${TARGET_FILES[@]}"; do
        if $first; then first=false; else printf ','; fi
        printf '"%s"' "$file"
    done
    printf '],'
    
    # 需求来源
    printf '"SPEC_SOURCE":"%s",' "$SPEC_SOURCE"
    
    # History 信息
    printf '"HISTORY_DIR":"%s",' "$HISTORY_DIR"
    printf '"HISTORY_EXISTS":%s,' "$HISTORY_EXISTS"
    printf '"HISTORY_COUNT":%d,' "$HISTORY_COUNT"
    printf '"HISTORY_UPDATE_MODE":"%s",' "$HISTORY_UPDATE_MODE"
    printf '"HISTORY_MATCHED_FILE":"%s",' "$HISTORY_MATCHED_FILE"
    printf '"HISTORY_LATEST_FILE":"%s",' "${HISTORY_LATEST_FILE:-}"
    printf '"HISTORY_FILES":['
    first=true
    for file in "${HISTORY_FILES[@]}"; do
        if $first; then first=false; else printf ','; fi
        printf '"%s"' "$file"
    done
    printf ']'
    printf '}\n'
else
    # 普通输出
    echo "=== Kit 工作流检查 ==="
    echo ""
    echo "PROJECT_ROOT: $PROJECT_ROOT"
    echo "KIT_DIR: $KIT_DIR"
    echo ""
    
    echo "--- Target 目录 ---"
    echo "TARGET_DIR: $TARGET_DIR"
    echo "TARGET_EXISTS: $TARGET_EXISTS"
    echo "TARGET_COUNT: $TARGET_COUNT"
    echo "TARGET_HAS_SPEC: $TARGET_HAS_SPEC"
    if [ $TARGET_COUNT -gt 0 ]; then
        echo "TARGET_FILES:"
        for file in "${TARGET_FILES[@]}"; do
            echo "  - $file"
        done
    fi
    echo ""
    
    echo "--- 需求来源 ---"
    if [ "$SPEC_SOURCE" = "target" ]; then
        echo "SPEC_SOURCE: 📄 target 目录文档"
    else
        echo "SPEC_SOURCE: 📝 prompt 输入"
    fi
    echo ""
    
    echo "--- History 目录 ---"
    echo "HISTORY_DIR: $HISTORY_DIR"
    echo "HISTORY_EXISTS: $HISTORY_EXISTS"
    echo "HISTORY_COUNT: $HISTORY_COUNT"
    
    echo ""
    echo "--- History 更新策略 ---"
    if [ "$HISTORY_UPDATE_MODE" = "incremental" ]; then
        echo "HISTORY_UPDATE_MODE: 📝 增量更新"
        echo "HISTORY_MATCHED_FILE: $HISTORY_MATCHED_FILE"
    else
        echo "HISTORY_UPDATE_MODE: 📄 新建文档"
    fi
    
    if [ -n "${HISTORY_LATEST_FILE:-}" ]; then
        echo "HISTORY_LATEST_FILE: $HISTORY_LATEST_FILE"
    fi
    
    if [ $HISTORY_COUNT -gt 0 ]; then
        echo ""
        echo "HISTORY_FILES:"
        for file in "${HISTORY_FILES[@]}"; do
            echo "  - $file"
        done
    fi
fi
