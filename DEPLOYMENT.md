# AirWord 部署文档

## 服务器配置

### 测试环境
- WebSocket: `ws://airword-dev.assert6.com:3001`
- API: `http://airword-dev.assert6.com:3001/api`

### 正式环境
- WebSocket: `ws://airword.assert6.com:3001`
- API: `http://airword.assert6.com:3001/api`

## 环境配置

环境通过构建时指定，使用 `--dart-define` 参数，不需要修改代码。

## 部署步骤

### 1. 部署后端服务

```bash
cd backend
npm install
npm run build
pm2 start dist/index.js --name airword-backend
```

### 2. 部署Web端

```bash
cd web
npm install --legacy-peer-deps
npm run build
# 将dist目录部署到Web服务器
```

访问地址：
- 测试环境: http://airword-dev.assert6.com:3001
- 正式环境: http://airword.assert6.com:3001

### 3. 编译Android App

#### 方式1: 使用构建脚本（推荐）

**Linux/Mac:**
```bash
cd app

# 构建测试版
./build.sh dev

# 构建正式版
./build.sh prod
```

**Windows:**
```cmd
cd app

# 构建测试版
build.bat dev

# 构建正式版
build.bat prod
```

构建完成后：
- 测试版APK: `build/app/outputs/flutter-apk/airword-dev.apk`
- 正式版APK: `build/app/outputs/flutter-apk/airword-prod.apk`

#### 方式2: 手动构建

```bash
cd app

# 构建测试版
flutter build apk --release --dart-define=ENV=dev

# 构建正式版
flutter build apk --release --dart-define=ENV=prod

# APK位置: build/app/outputs/flutter-apk/app-release.apk
```

### 4. 编译iOS App

```bash
cd app

# 测试版
flutter build ios --release --dart-define=ENV=dev

# 正式版
flutter build ios --release --dart-define=ENV=prod
```

然后在Xcode中配置签名和发布设置。

### 5. 编译PC端

```bash
cd desktop
npm install
npm run electron:build
# 安装包位置: release/
```

## frpc 配置

### 测试环境配置

```ini
[airword_dev_backend]
type = tcp
local_ip = 127.0.0.1
local_port = 3001
remote_port = 3001
```

### 正式环境配置

```ini
[airword_backend]
type = tcp
local_ip = 127.0.0.1
local_port = 3001
remote_port = 3001
```

## Android网络权限配置

已配置允许以下域名的HTTP明文传输：
- localhost
- 192.168.2.29
- airword-dev.assert6.com
- airword.assert6.com

配置文件：`app/android/app/src/main/res/xml/network_security_config.xml`

## 开发调试

### 在模拟器上运行（使用测试环境）

```bash
cd app
flutter run --dart-define=ENV=dev
```

### 连接真机调试

```bash
# 查看可用设备
flutter devices

# 指定设备运行（测试环境）
flutter run -d <device_id> --dart-define=ENV=dev
```

### 查看当前构建配置

在App首页右上角会显示当前环境（测试环境/正式环境），以及对应的服务器地址。

## 监控和维护

### 查看后端日志

```bash
pm2 logs airword-backend
```

### 重启后端服务

```bash
pm2 restart airword-backend
```

### 查看服务状态

```bash
pm2 status
```

## 安全建议

⚠️ **当前使用HTTP明文传输，仅适合内网或测试环境**

生产环境建议：
1. 启用HTTPS/WSS加密
2. 添加身份认证机制
3. 实现Session过期和清理
4. 添加访问频率限制
5. 配置CORS白名单

## 故障排查

### 连接失败
1. 检查frpc是否正常运行
2. 检查后端服务是否启动
3. 检查防火墙设置
4. 查看App和浏览器控制台日志

### WebSocket断开
1. 检查网络连接
2. 确认服务器端口3001开放
3. 查看后端日志是否有错误

### 二维码无法扫描
1. 确认App已授予相机权限
2. 确保光线充足
3. 尝试使用"手动输入Session ID"功能

### 构建问题
1. 确认Flutter环境已正确安装
2. 运行 `flutter doctor` 检查环境
3. 清理构建缓存: `flutter clean`
