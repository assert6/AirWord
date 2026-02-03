#!/bin/bash
# AirWord 图标一键替换脚本包装器

cd "$(dirname "$0")"

if ! command -v python3 &> /dev/null; then
    echo "❌ 错误: 未找到 python3"
    echo "   请先安装 Python 3"
    exit 1
fi

if ! python3 -c "import PIL" 2>/dev/null; then
    echo "📦 安装依赖 Pillow..."
    pip3 install Pillow
fi

python3 assets/update_icons.py "$@"
