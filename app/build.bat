@echo off
REM AirWord Windows 构建脚本
REM debug模式 -> 连接测试服务器
REM release模式 -> 连接正式服务器

set MODE=%1

if "%MODE%"=="" (
  echo 用法: build.bat [debug^|release]
  echo 示例: build.bat debug   # 开发版（测试服务器）
  echo       build.bat release # 正式版（正式服务器）
  exit /b 1
)

if not "%MODE%"=="debug" if not "%MODE%"=="release" (
  echo 错误: 参数只能是 debug 或 release
  exit /b 1
)

echo ======================================
echo 正在构建 AirWord App
echo 模式: %MODE%
echo ======================================

if "%MODE%"=="debug" (
  echo 开发版配置:
  echo   - WebSocket: ws://airword-dev.assert6.com:3001
  echo   - API: http://airword-dev.assert6.com:3001/api
  echo.
  echo 开始构建 Android APK ^(debug^)...
  flutter build apk --debug

  if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ 构建成功!
    echo APK 文件位置: build\app\outputs\flutter-apk\app-debug.apk
    echo.
    echo 重命名...
    move build\app\outputs\flutter-apk\app-debug.apk build\app\outputs\flutter-apk\airword-dev.apk
    echo   -^> build\app\outputs\flutter-apk\airword-dev.apk
  ) else (
    echo.
    echo ❌ 构建失败!
    exit /b 1
  )
) else (
  echo 正式版配置:
  echo   - WebSocket: ws://airword.assert6.com:3001
  echo   - API: http://airword.assert6.com:3001/api
  echo.
  echo 开始构建 Android APK ^(release^)...
  flutter build apk --release

  if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ 构建成功!
    echo APK 文件位置: build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 重命名...
    move build\app\outputs\flutter-apk\app-release.apk build\app\outputs\flutter-apk\airword-prod.apk
    echo   -^> build\app\outputs\flutter-apk\airword-prod.apk
  ) else (
    echo.
    echo ❌ 构建失败!
    exit /b 1
  )
)
