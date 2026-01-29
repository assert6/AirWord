@echo off
REM AirWord Windows 构建脚本

set ENV=%1

if "%ENV%"=="" (
  echo 用法: build.bat [dev^|prod]
  echo 示例: build.bat dev   # 构建测试版
  echo       build.bat prod  # 构建正式版
  exit /b 1
)

if not "%ENV%"=="dev" if not "%ENV%"=="prod" (
  echo 错误: 环境参数只能是 dev 或 prod
  exit /b 1
)

echo ======================================
echo 正在构建 AirWord App
echo 环境: %ENV%
echo ======================================

if "%ENV%"=="dev" (
  echo 测试环境配置:
  echo   - WebSocket: ws://airword-dev.assert6.com:3001
  echo   - API: http://airword-dev.assert6.com:3001/api
) else (
  echo 正式环境配置:
  echo   - WebSocket: ws://airword.assert6.com:3001
  echo   - API: http://airword.assert6.com:3001/api
)

echo.
echo 开始构建 Android APK...
flutter build apk --release --dart-define=ENV=%ENV%

if %ERRORLEVEL% EQU 0 (
  echo.
  echo ✅ 构建成功!
  echo APK 文件位置: build\app\outputs\flutter-apk\app-release.apk
  echo.
  echo 建议重命名:
  if "%ENV%"=="dev" (
    move build\app\outputs\flutter-apk\app-release.apk build\app\outputs\flutter-apk\airword-dev.apk
    echo   -^> build\app\outputs\flutter-apk\airword-dev.apk
  ) else (
    move build\app\outputs\flutter-apk\app-release.apk build\app\outputs\flutter-apk\airword-prod.apk
    echo   -^> build\app\outputs\flutter-apk\airword-prod.apk
  )
) else (
  echo.
  echo ❌ 构建失败!
  exit /b 1
)
