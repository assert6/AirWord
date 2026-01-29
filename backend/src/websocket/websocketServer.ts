import WebSocket from 'ws';
import { sessionManager } from '../session/sessionManager';

export interface WebSocketMessage {
  type: 'input' | 'delete' | 'connect' | 'disconnect' | 'heartbeat';
  sessionId?: string;
  clientType?: 'web' | 'app' | 'desktop';
  content?: string;
  timestamp: number;
}

export class WebSocketServer {
  private wss: WebSocket.Server;
  private heartbeatInterval: NodeJS.Timeout;

  constructor(server: any) {
    this.wss = new WebSocket.Server({ server });
    this.setupWebSocket();
    this.heartbeatInterval = setInterval(() => this.heartbeat(), 30000);
    setInterval(() => sessionManager.cleanupExpiredSessions(), 60000);
  }

  private setupWebSocket(): void {
    this.wss.on('connection', (ws: WebSocket) => {
      console.log('New WebSocket connection');

      ws.on('message', (data: string) => {
        try {
          const message: WebSocketMessage = JSON.parse(data);
          this.handleMessage(ws, message);
        } catch (error) {
          console.error('Failed to parse message:', error);
        }
      });

      ws.on('close', () => {
        console.log('WebSocket connection closed');
        sessionManager.removeClient(ws);
      });

      ws.on('error', (error) => {
        console.error('WebSocket error:', error);
      });

      // 发送欢迎消息
      ws.send(JSON.stringify({
        type: 'connect',
        timestamp: Date.now()
      } as WebSocketMessage));
    });
  }

  private handleMessage(ws: WebSocket, message: WebSocketMessage): void {
    const { type, sessionId, clientType } = message;

    if (type === 'heartbeat') {
      if (sessionId) {
        sessionManager.updateActivity(sessionId);
      }
      ws.send(JSON.stringify({ type: 'heartbeat', timestamp: Date.now() }));
      return;
    }

    if (!sessionId || !clientType) {
      console.warn('Message missing sessionId or clientType');
      return;
    }

    const session = sessionManager.getSession(sessionId);
    if (!session) {
      ws.send(JSON.stringify({
        type: 'error',
        message: 'Session not found',
        timestamp: Date.now()
      }));
      return;
    }

    // 绑定客户端到session（如果还没绑定）
    if (clientType === 'app') {
      if (!session.appClient || session.appClient !== ws) {
        const bound = sessionManager.bindAppClient(sessionId, ws);
        if (!bound) {
          ws.send(JSON.stringify({
            type: 'error',
            message: '此会话已有其他App连接，请使用新的会话',
            timestamp: Date.now()
          }));
          return;
        }
      }
    } else if (clientType === 'web' || clientType === 'desktop') {
      if (!session.webClient || session.webClient !== ws) {
        sessionManager.bindWebClient(sessionId, ws);
      }
    }

    // 更新会话活动时间
    sessionManager.updateActivity(sessionId);

    // 转发消息到对应的客户端
    if (clientType === 'app') {
      // App发送消息，转发到Web/PC
      const targetClient = session.webClient;
      console.log(`App message to Web: session=${sessionId}, type=${message.type}, content="${message.content}"`);
      if (targetClient && targetClient.readyState === WebSocket.OPEN) {
        console.log('Forwarding to Web client');
        targetClient.send(JSON.stringify(message));
      } else {
        console.log('Web client not connected or not ready');
      }
    } else if (clientType === 'web' || clientType === 'desktop') {
      // Web/PC发送消息，转发到App（如果需要双向通信）
      const targetClient = session.appClient;
      console.log(`Web message to App: session=${sessionId}, type=${message.type}`);
      if (targetClient && targetClient.readyState === WebSocket.OPEN) {
        console.log('Forwarding to App client');
        targetClient.send(JSON.stringify(message));
      } else {
        console.log('App client not connected or not ready');
      }
    }
  }

  private heartbeat(): void {
    this.wss.clients.forEach((ws: WebSocket) => {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify({
          type: 'heartbeat',
          timestamp: Date.now()
        } as WebSocketMessage));
      }
    });
  }

  close(): void {
    clearInterval(this.heartbeatInterval);
    this.wss.close();
  }
}
