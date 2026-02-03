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

---

# 📱 iOS App Store 上架指南

## ✅ 已完成配置

- [x] Bundle ID: `com.assert6.airword`
- [x] App名称: AirWord
- [x] 支持横竖屏

## 📋 前置要求

### 1. Apple Developer 账号
- 访问 https://developer.apple.com/programs
- 注册个人账号（$99/年）
- 等待审核通过（通常24-48小时）

### 2. 开发环境检查
```bash
# 确保Xcode已安装
xcode-select -p

# 确保Flutter环境正常
flutter doctor

# 安装iOS依赖
cd ios && pod install
```

### 3. 应用图标准备
需要准备以下尺寸的图标文件：

| 尺寸 | 用途 |
|------|------|
| 1024x1024 | App Store |
| 180x180 | iPhone 通知 |
| 120x120 | iPhone 主屏幕 |
| 167x167 | iPad Pro |
| 152x152 | iPad |

在线生成工具：https://appicon.co/

## 🔐 证书和配置文件

### 1. 创建证书 (Certificates)

登录 https://developer.apple.com/account/resources/certificates/list

1. 点击 (+) 创建证书
2. 选择 **iOS Distribution (App Store and Ad Hoc)**
3. 上传CSR文件（从Keychain生成）
4. 下载证书并双击安装

### 2. 创建App ID

1. 进入 Identifiers
2. 点击 (+) 注册App ID
3. 选择 **App IDs**
4. 填写信息：
   - Description: AirWord
   - Bundle ID: com.assert6.airword（精确匹配）
5. 启用需要的功能（默认即可）

### 3. 创建配置文件 (Provisioning Profile)

1. 进入 Profiles
2. 点击 (+) 创建
3. 选择 **App Store**
4. 选择刚才创建的App ID
5. 选择刚才创建的证书
6. 命名配置文件：`AirWord_AppStore`
7. 下载并双击安装

## 🏗️ 构建步骤

### 1. 更新版本号

编辑 `pubspec.yaml`：
```yaml
version: 1.0.0+1  # 格式: 版本号+构建号
```

### 2. 构建Release版本

```bash
# 清理构建缓存
flutter clean

# 获取依赖
flutter pub get

# 构建iOS Release版本
flutter build ios --release

# 或者构建ipa文件
flutter build ipa --release
```

### 3. 使用Xcode上传

```bash
# 打开Xcode项目
open ios/Runner.xcworkspace
```

在Xcode中：
1. 选择 Runner → Signing & Capabilities
2. 确保Team已选择（你的个人账号）
3. 确认Bundle Identifier: com.assert6.airword
4. 选择 Product → Archive
5. 等待构建完成后，点击 Distribute App
6. 选择 App Store Connect → Upload

## 📤 App Store Connect 配置

### 1. 创建App记录

访问 https://appstoreconnect.apple.com

1. 点击 "我的App" → (+)
2. 选择平台：iOS
3. 填写信息：
   - 名称：AirWord
   - 主要语言：简体中文
   - Bundle ID：com.assert6.airword
   - SKU：airword-001

### 2. 填写App信息

**App预览和截图**（必需，至少3-5张）：
- iPhone 6.7" 显示屏截图
- iPhone 6.5" 显示屏截图
- iPad Pro 截图

**描述**：
```
AirWord - 实时输入同步工具

将手机变成无线键盘，实时同步输入到电脑。

主要功能：
• 扫描二维码即可连接
• 支持显示模式和直接输入模式
• 实时同步，超低延迟
• 支持多平台（Web、桌面端）

使用方法：
1. 在电脑端打开AirWord网页或桌面应用
2. 使用手机App扫描二维码
3. 在手机上输入，内容实时同步到电脑
```

### 3. 设置价格和销售范围

- 价格：免费
- 销售范围：中国大陆和其他地区

## ✅ 审核前检查清单

- [ ] 应用图标已添加
- [ ] 启动图已配置
- [ ] 无崩溃或明显错误
- [ ] 在真机上测试通过
- [ ] 隐私政策链接有效
- [ ] 截图符合规范

## 🚀 提交审核

1. 在App Store Connect中选择构建版本
2. 点击"提交以供审核"
3. 等待审核（通常1-3个工作日）

**祝上架顺利！** 🎉

