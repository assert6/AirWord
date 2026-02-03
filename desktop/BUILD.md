# AirWord Desktop 构建指南

## 📋 前置要求

- Node.js 18+ 和 npm
- Python 3（用于编译原生模块）
- macOS: Xcode Command Line Tools

## 🚀 快速构建

### 1. 安装依赖

```bash
cd desktop
npm install
```

### 2. 开发模式运行

```bash
npm run electron:dev
```

### 3. 生产构建

```bash
# 构建当前平台
npm run electron:build

# 指定平台构建
npx electron-builder --mac
npx electron-builder --win
npx electron-builder --linux
```

## 🍎 macOS 构建

### 本地构建（Apple Silicon）

```bash
npm run build
npm run electron:build
```

输出位置：`release/mac-arm64/AirWord.app`

### 构建 DMG 安装包

修改 `package.json` 已配置 `target: ["dmg", "zip"]`，直接构建即可：

```bash
npx electron-builder --mac
```

输出：
- `release/AirWord-1.0.0.dmg` - 安装包
- `release/AirWord-1.0.0-mac.zip` - 便携版

### 构建 Intel Mac 版本（交叉编译）

```bash
npx electron-builder --mac --x64
```

### 签名与公证（发布到 App Store）

需要 Apple Developer 账号：

```bash
# 环境变量方式
export APPLE_ID=your@email.com
export APPLE_ID_PASSWORD=app-specific-password
export TEAM_ID=your-team-id

npm run electron:build
```

在 `package.json` 中添加签名配置：
```json
"build": {
  "mac": {
    "hardenedRuntime": true,
    "gatekeeperAssess": false,
    "entitlements": "build/entitlements.mac.plist",
    "entitlementsInherit": "build/entitlements.mac.plist"
  }
}
```

## 🪟 Windows 构建

### 方式 1：在 macOS/Linux 上交叉编译（需 Wine）

```bash
# macOS 安装 Wine
brew install --cask wine-stable

# 构建 Windows 版本
npx electron-builder --win --x64
```

### 方式 2：在 Windows 上构建（推荐）

在 Windows 10/11 电脑上：

```bash
# 安装依赖
npm install

# 构建 Windows 版本
npm run electron:build
# 或
npx electron-builder --win
```

输出：
- `release/AirWord Setup 1.0.0.exe` - 安装程序
- `release/AirWord 1.0.0.exe` - 便携版

### Windows 目标平台

```bash
# x64 (64位)
npx electron-builder --win --x64

# ia32 (32位)
npx electron-builder --win --ia32

# arm64 (ARM)
npx electron-builder --win --arm64

# 全部
npx electron-builder --win --x64 --ia32
```

## 🐧 Linux 构建

```bash
npx electron-builder --linux
```

输出：`release/AirWord-1.0.0.AppImage`

## 🔧 高级配置

### 同时构建多平台

```bash
# macOS + Windows
npx electron-builder --mac --win

# 全部平台
npx electron-builder --mac --win --linux
```

### 仅打包（跳过构建）

```bash
npx electron-builder --prepackaged dist/mac-arm64/AirWord.app
```

### 发布到 GitHub Releases

```bash
# 设置 GitHub Token
export GH_TOKEN=your_github_token

# 构建并发布
npx electron-builder --publish=always
```

## 📁 输出目录结构

```
release/
├── mac-arm64/
│   └── AirWord.app           # macOS 应用
├── win-unpacked/             # Windows 未打包文件
│   └── AirWord.exe
├── linux-unpacked/           # Linux 未打包文件
│   └── airword-desktop
├── AirWord-1.0.0.dmg         # macOS 安装包
├── AirWord-1.0.0-mac.zip     # macOS 便携版
├── "AirWord Setup 1.0.0.exe" # Windows 安装程序
├── "AirWord 1.0.0.exe"       # Windows 便携版
└── AirWord-1.0.0.AppImage    # Linux 可执行文件
```

## 🐛 常见问题

### 1. 构建失败：找不到 Python

```bash
# macOS
brew install python

# 或设置 Python 路径
export PYTHON=/usr/bin/python3
```

### 2. 构建失败：权限不足

```bash
# macOS 赋予终端完全磁盘访问权限
# 系统设置 -> 隐私与安全性 -> 完全磁盘访问权限

# 或使用 sudo（不推荐）
sudo npm run electron:build
```

### 3. Windows 构建需要 Wine

```bash
# macOS
brew install --cask wine-stable

# Linux
sudo apt-get install wine
```

### 4. 原生模块重新编译

如果更改了 Electron 版本：

```bash
npm rebuild
# 或
npx electron-rebuild
```

### 5. 清理缓存重新构建

```bash
rm -rf node_modules dist dist-electron release
npm install
npm run electron:build
```

## 📚 参考文档

- [electron-builder 文档](https://www.electron.build/)
- [Electron 代码签名](https://www.electron.build/code-signing)
- [macOS 公证指南](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution)
