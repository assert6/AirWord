#!/bin/bash

# AirWord 构建脚本

ENV=$1

if [ -z "$ENV" ]; then
  echo "用法: ./build.sh [dev|prod]"
  echo "示例: ./build.sh dev   # 构建测试版"
  echo "      ./build.sh prod  # 构建正式版"
  exit 1
fi

if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ]; then
  echo "错误: 环境参数只能是 dev 或 prod"
  exit 1
fi

echo "======================================"
echo "正在构建 AirWord App"
echo "环境: $ENV"
echo "======================================"

if [ "$ENV" = "dev" ]; then
  echo "测试环境配置:"
  echo "  - WebSocket: ws://airword-dev.assert6.com:3001"
  echo "  - API: http://airword-dev.assert6.com:3001/api"
else
  echo "正式环境配置:"
  echo "  - WebSocket: ws://airword.assert6.com:3001"
  echo "  - API: http://airword.assert6.com:3001/api"
fi

echo ""
echo "开始构建 Android APK..."
flutter build apk --release --dart-define=ENV=$ENV

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ 构建成功!"
  echo "APK 文件位置: build/app/outputs/flutter-apk/app-release.apk"
  echo ""
  echo "建议重命名:"
  if [ "$ENV" = "dev" ]; then
    mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/airword-dev.apk
    echo "  -> build/app/outputs/flutter-apk/airword-dev.apk"
  else
    mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/airword-prod.apk
    echo "  -> build/app/outputs/flutter-apk/airword-prod.apk"
  fi
else
  echo ""
  echo "❌ 构建失败!"
  exit 1
fi
