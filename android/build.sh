#!/bin/bash
set -euo pipefail

# MiMoCode Android Build Script
# 用法: ./build.sh [version]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VERSION="${1:-$(cat "$PROJECT_ROOT/packages/opencode/package.json" | grep '"version"' | head -1 | cut -d'"' -f4)}"

echo "=== MiMoCode Android Build ==="
echo "Version: $VERSION"
echo "Target: bun-linux-arm64-android"
echo ""

# 检查 bun 是否可用
if ! command -v bun &>/dev/null && [ ! -x "$HOME/.bun/bin/bun" ]; then
    echo "错误: 需要安装 bun"
    echo "安装: curl -fsSL https://bun.sh/install | bash"
    exit 1
fi

BUN_CMD="bun"
if ! command -v bun &>/dev/null; then
    BUN_CMD="$HOME/.bun/bin/bun"
fi

echo "Bun: $($BUN_CMD --version)"
echo ""

# 进入 opencode 目录
cd "$PROJECT_ROOT/packages/opencode"

# 安装依赖（如果需要）
if [ ! -d "node_modules" ]; then
    echo "安装依赖..."
    $BUN_CMD install
fi

# 构建生成文件
echo "生成代码..."
$BUN_CMD run script/generate.ts

# 构建 Android binary
echo "构建 Android ARM64 binary..."
mkdir -p "$PROJECT_ROOT/dist/android-arm64/bin"

$BUN_CMD build \
    --compile \
    --target=bun-linux-arm64-android \
    --conditions=browser \
    --outfile="$PROJECT_ROOT/dist/android-arm64/bin/mimo" \
    ./src/index.ts

echo ""
echo "=== 构建完成 ==="
echo "输出: $PROJECT_ROOT/dist/android-arm64/bin/mimo"
echo "大小: $(ls -lh "$PROJECT_ROOT/dist/android-arm64/bin/mimo" | awk '{print $5}')"
echo ""

# 检查输出
echo "=== 验证输出 ==="
readelf -l "$PROJECT_ROOT/dist/android-arm64/bin/mimo" 2>/dev/null | grep interpreter
readelf -h "$PROJECT_ROOT/dist/android-arm64/bin/mimo" 2>/dev/null | grep -E "Machine|Type"
