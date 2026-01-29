export interface WebSocketMessage {
  type: 'input' | 'delete' | 'connect' | 'disconnect' | 'heartbeat' | 'error';
  sessionId?: string;
  clientType?: 'web' | 'app' | 'desktop';
  content?: string;
  message?: string;
  timestamp: number;
}

export interface ElectronAPI {
  typeText: (text: string) => Promise<{ success: boolean; error?: string }>;
  deleteText: (count: number) => Promise<{ success: boolean; error?: string }>;
}

declare global {
  interface Window {
    electronAPI: ElectronAPI;
  }
}
