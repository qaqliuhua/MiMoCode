#!/system/bin/sh
# MiMoCode Android 设备端设置脚本
# 在 Android 设备上运行

set -e

MIMO_HOME="${MIMO_HOME:-/data/local/mimocode}"
MIMO_DATA="${MIMO_HOME}/data"
MIMO_LOG="${MIMO_HOME}/logs"

echo "=== MiMoCode Android Setup ==="
echo "Home: $MIMO_HOME"
echo "Data: $MIMO_DATA"
echo "Log:  $MIMO_LOG"
echo ""

# 创建目录
mkdir -p "$MIMO_DATA"/{memory,skills,cache,config,state,compose,log,bin}
mkdir -p "$MIMO_LOG"

# 设置环境变量
export MIMOCODE_HOME="$MIMO_DATA"
export HOME="${HOME:-/data/local/tmp}"
export TMPDIR="${TMPDIR:-/data/local/tmp}"
export PATH="$MIMO_HOME/bin:$PATH"

# 检查 mimo binary
if [ ! -x "$MIMO_HOME/bin/mimo" ]; then
    echo "错误: $MIMO_HOME/bin/mimo 不存在或不可执行"
    echo "请先将 mimo binary 复制到 $MIMO_HOME/bin/"
    exit 1
fi

echo "=== 环境检查 ==="
echo "MIMOCODE_HOME: $MIMOCODE_HOME"
echo "HOME: $HOME"
echo "PATH: $PATH"
echo "mimo: $(ls -la $MIMO_HOME/bin/mimo)"
echo ""

# 测试运行
echo "=== 测试 mimo ==="
$MIMO_HOME/bin/mimo --version 2>&1 || {
    echo "mimo 运行失败"
    echo "可能原因:"
    echo "  1. 缺少 Android 兼容的 native addon"
    echo "  2. 环境变量未正确设置"
    echo "  3. SELinux 阻止执行"
    exit 1
}

echo ""
echo "=== 设置完成 ==="
echo ""
echo "启动命令:"
echo "  export MIMOCODE_HOME=$MIMO_DATA"
echo "  export HOME=/data/local/tmp"
echo "  $MIMO_HOME/bin/mimo serve --port 3000 --host 0.0.0.0"
