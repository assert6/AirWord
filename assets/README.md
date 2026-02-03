# AirWord 图标素材

此文件夹存放 AirWord 项目的图标素材和替换脚本。

## 📁 文件夹结构

```
assets/
├── README.md          # 本说明文件
├── update_icons.py    # 一键替换图标脚本
└── icons/
    └── icon.png       # 主图标文件 (1024x1024)
```

## 🚀 使用方法

### 1. 准备图标

将设计好的图标放入 `icons/` 目录，命名为 `icon.png`：

- **尺寸**: 1024x1024 像素
- **格式**: PNG
- **背景**: 透明或纯色背景
- **设计要求**:
  - 简洁易识别
  - 在小型尺寸下依然清晰
  - 避免过多细节

### 2. 安装依赖

脚本需要 Python 3 和 Pillow 库：

```bash
# 安装 Pillow
pip3 install Pillow

# 或在 macOS 上
brew install pillow
```

### 3. 运行脚本

```bash
# 从项目根目录运行
python3 assets/update_icons.py
```

脚本会自动生成并替换以下平台的图标：

| 平台 | 路径 | 文件 |
|------|------|------|
| **Android** | `app/android/app/src/main/res/` | mipmap-*/ic_launcher.png |
| **iOS** | `app/ios/Runner/Assets.xcassets/AppIcon.appiconset/` | Icon-App-*.png |
| **Desktop** | `desktop/build/` | icon.png, icon.icns, icon.ico |
| **Web** | `web/public/` | favicon*.png, apple-touch-icon.png, android-chrome-*.png |

## 📱 各平台图标规格

### Android
- mdpi: 48x48
- hdpi: 72x72
- xhdpi: 96x96
- xxhdpi: 144x144
- xxxhdpi: 192x192

### iOS
- iPhone: 20x20@2x/3x, 29x29@2x/3x, 40x40@2x/3x, 60x60@2x/3x
- iPad: 20x20@1x/2x, 29x29@1x/2x, 40x40@1x/2x, 76x76@1x/2x, 83.5x83.5@2x
- App Store: 1024x1024

### Desktop
- macOS: icon.icns (多尺寸)
- Windows: icon.ico (16x16 到 256x256)
- Linux: icon.png (1024x1024)

### Web
- favicon: 16x16, 32x32
- Apple Touch: 180x180
- Android Chrome: 192x192, 512x512

## 🔄 更新后操作

替换图标后，需要重新构建各端应用：

```bash
# App (iOS)
cd app
flutter build ios

# App (Android)
cd app
flutter build apk

# Desktop
cd desktop
npm run build

# Web
cd web
npm run build
```

## 📝 注意事项

1. **缓存问题**: iOS 设备可能会缓存旧图标，卸载重装应用可解决
2. **icon.icns**: 仅在 macOS 系统上可生成，其他系统会跳过
3. **透明背景**: 建议使用透明背景，适配不同主题
