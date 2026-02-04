import http from 'http';
import { app } from './api/server';
import { WebSocketServer } from './websocket/websocketServer';

const PORT = process.env.PORT || 3001;

const server = http.createServer(app);

// 初始化WebSocket服务器
const wsServer = new WebSocketServer(server);

server.listen(Number(PORT), '0.0.0.0', () => {
  console.log(`AirWord backend server running on port ${PORT}`);
  console.log(`WebSocket server ready`);
  console.log(`Local API: http://localhost:${PORT}`);
  console.log(`Network API: http://192.168.2.29:${PORT}`);
});

// 优雅关闭
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully...');
  wsServer.close();
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});
