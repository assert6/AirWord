# AirWord App 构建快速指南

## 快速构建

### Mac/Linux
```bash
cd app

# 测试版
./build.sh dev

# 正式版
./build.sh prod
```

### Windows
```cmd
cd app

# 测试版
build.bat dev

# 正式版
build.bat prod
```

## 手动构建

```bash
flutter build apk --release --dart-define=ENV=dev    # 测试版
flutter build apk --release --dart-define=ENV=prod   # 正式版
```

## 开发调试

```bash
# 模拟器运行（测试环境）
flutter run --dart-define=ENV=dev

# 真机运行（正式环境）
flutter run --dart-define=ENV=prod
```

## 环境说明

- **dev**: 测试环境，连接 `airword-dev.assert6.com`
- **prod**: 正式环境，连接 `airword.assert6.com`

构建完成后APK会自动重命名为 `airword-dev.apk` 或 `airword-prod.apk`
