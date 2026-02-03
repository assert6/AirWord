# AirWord - 实时输入同步工具

一个帮助不熟悉键盘输入的人群的辅助工具，通过手机App实时输入并同步到Web端或PC端。

## 功能特性

- ✅ **临时绑定**: Web端生成二维码，App扫码即可建立连接
- ✅ **实时同步**: App端输入实时通过WebSocket推送到Web/PC端
- ✅ **双向同步**: App端删除时Web端也会同步删除
- ✅ **直接输入**: PC端支持直接输入到光标位置（使用robotjs模拟键盘）
- ✅ **跨平台**: 支持Web、iOS/Android App、Windows/Mac/Linux PC端

## 技术栈

### 后端
- Node.js + TypeScript
- WebSocket (ws)
- Express (REST API)
- QRCode生成

### Web端
- React + TypeScript
- Vite
- Tailwind CSS
- WebSocket客户端

### App端
- Flutter
- Dart
- mobile_scanner (扫码)
- web_socket_channel (WebSocket)

### PC端
- Electron
- React + TypeScript
- robotjs (模拟键盘输入)
- Vite

## 项目结构

```
AirWord/
├── assets/           # 图标素材和替换脚本
│   ├── icons/        # 主图标文件 (icon.png 1024x1024)
│   ├── update_icons.py  # 一键替换图标脚本
│   └── README.md     # 图标使用说明
├── backend/          # Node.js后端服务
├── web/              # Web前端应用
├── app/              # Flutter移动应用
├── desktop/          # Electron桌面应用
└── README.md
```

## 快速开始

### 1. 启动后端服务

```bash
cd backend
npm install
npm run dev
```

后端服务将在 http://localhost:3001 启动

### 2. 启动Web端

```bash
cd web
npm install --legacy-peer-deps
npm run dev
```

Web端将在 http://localhost:3000 启动

### 3. 启动PC端 (可选)

```bash
cd desktop
npm install
npm run electron:dev
```

### 4. 运行Flutter App

```bash
cd app
flutter pub get
# 连接真机或模拟器后运行
flutter run
```

## 使用说明

### Web端使用流程

1. 打开Web端 (http://localhost:3000)
2. 自动生成二维码
3. 使用App扫描二维码
4. 连接成功后，App端的输入会实时显示在Web端
5. 可以复制内容到剪贴板

### PC端使用流程

1. 启动PC端应用
2. 使用App扫码建立连接
3. 选择显示模式或直接输入模式
4. 在显示模式下，可以查看并复制内容
5. 在直接输入模式下，App的输入会直接发送到光标位置
6. 使用 `Ctrl+Shift+A` (Mac: `Cmd+Shift+A`) 快捷键显示/隐藏窗口

### App端使用流程

1. 打开AirWord App
2. 点击"扫描二维码"
3. 扫描Web端或PC端显示的二维码
4. 进入输入界面，开始输入
5. 内容实时同步到已连接的设备

## 核心功能实现

### WebSocket通信协议

```typescript
interface WebSocketMessage {
  type: 'input' | 'delete' | 'connect' | 'disconnect' | 'heartbeat';
  sessionId: string;
  clientType: 'web' | 'app' | 'desktop';
  content?: string;
  timestamp: number;
}
```

### 会话管理

- 每次Web/PC端打开时创建新的session ID
- 二维码包含session信息
- App扫码后获取session ID并建立WebSocket连接
- 30分钟无活动自动断开

### PC端直接输入原理

使用Electron的`robotjs`库模拟键盘输入:
```typescript
robot.typeString(text);  // 输入文本
robot.keyTap('backspace');  // 删除字符
```

## 部署说明

### 后端部署

推荐使用PM2进行进程管理:

```bash
npm run build
pm2 start dist/index.js --name airword-backend
```

### Web端部署

构建静态文件:

```bash
npm run build
# 将dist目录部署到静态服务器
```

### App端发布

```bash
# Android
flutter build apk

# iOS
flutter build ipa
```

### PC端打包

```bash
npm run electron:build
# 生成的安装包在release目录
```

## 🎨 替换应用图标

### 1. 准备图标
将设计好的 1024x1024 PNG 图标放入 `assets/icons/icon.png`

### 2. 安装依赖
```bash
pip3 install Pillow
```

### 3. 一键替换
```bash
./update-icons.sh
# 或
python3 assets/update_icons.py
```

脚本会自动替换 App、Desktop、Web 三个端的所有图标尺寸。

详细说明请查看 [assets/README.md](assets/README.md)

## 安全考虑

- ⚠️ 当前版本为演示版本，未实现认证机制
- ⚠️ 建议在内网环境使用
- 生产环境建议添加:
  - WebSocket认证
  - HTTPS/WSS加密
  - Session过期机制
  - 输入内容过滤

## 常见问题

### Q: 为什么连接失败?
A: 确保后端服务正在运行，并检查防火墙设置

### Q: PC端无法输入到其他应用?
A: 确保授予应用辅助功能权限（macOS系统偏好设置 -> 安全性与隐私 -> 辅助功能）

### Q: Flutter扫码黑屏?
A: 确保授予App相机权限

## 未来改进方向

- [ ] 添加用户认证
- [ ] 支持多语言
- [ ] 历史记录功能
- [ ] 语音输入支持
- [ ] 自定义快捷键
- [ ] 云端同步配置
- [ ] 输入预测功能

## 开发贡献

欢迎提交Issue和Pull Request！

## 许可证

MIT License
