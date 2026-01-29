export interface WebSocketMessage {
  type: 'input' | 'delete' | 'connect' | 'disconnect' | 'heartbeat' | 'error';
  sessionId?: string;
  clientType?: 'web' | 'app' | 'desktop';
  content?: string;
  message?: string;
  timestamp: number;
}

export interface Session {
  sessionId: string;
  qrCode: string;
  createdAt: string;
}
