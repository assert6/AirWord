import { v4 as uuidv4 } from 'uuid';
import { generateSessionId } from '../utils/uuid';

export interface Session {
  sessionId: string;
  webClient: WebSocket | null;
  appClient: WebSocket | null;
  createdAt: Date;
  lastActivity: Date;
}

class SessionManager {
  private sessions: Map<string, Session> = new Map();
  private readonly SESSION_TIMEOUT = 30 * 60 * 1000; // 30分钟超时

  createSession(): Session {
    const sessionId = generateSessionId();
    const session: Session = {
      sessionId,
      webClient: null,
      appClient: null,
      createdAt: new Date(),
      lastActivity: new Date()
    };

    this.sessions.set(sessionId, session);
    return session;
  }

  getSession(sessionId: string): Session | undefined {
    return this.sessions.get(sessionId);
  }

  bindWebClient(sessionId: string, ws: WebSocket): boolean {
    const session = this.sessions.get(sessionId);
    if (!session) return false;

    session.webClient = ws;
    session.lastActivity = new Date();
    return true;
  }

  bindAppClient(sessionId: string, ws: WebSocket): boolean {
    const session = this.sessions.get(sessionId);
    if (!session) return false;

    session.appClient = ws;
    session.lastActivity = new Date();
    return true;
  }

  removeClient(ws: WebSocket): void {
    for (const [sessionId, session] of this.sessions.entries()) {
      if (session.webClient === ws) {
        session.webClient = null;
        this.checkSessionCleanup(sessionId);
      } else if (session.appClient === ws) {
        session.appClient = null;
        this.checkSessionCleanup(sessionId);
      }
    }
  }

  private checkSessionCleanup(sessionId: string): void {
    const session = this.sessions.get(sessionId);
    if (!session) return;

    // 如果两端都断开，删除会话
    if (!session.webClient && !session.appClient) {
      setTimeout(() => {
        const currentSession = this.sessions.get(sessionId);
        if (currentSession && !currentSession.webClient && !currentSession.appClient) {
          this.sessions.delete(sessionId);
        }
      }, 5000); // 5秒后清理
    }
  }

  updateActivity(sessionId: string): void {
    const session = this.sessions.get(sessionId);
    if (session) {
      session.lastActivity = new Date();
    }
  }

  cleanupExpiredSessions(): void {
    const now = Date.now();
    for (const [sessionId, session] of this.sessions.entries()) {
      if (now - session.lastActivity.getTime() > this.SESSION_TIMEOUT) {
        if (session.webClient) session.webClient.close();
        if (session.appClient) session.appClient.close();
        this.sessions.delete(sessionId);
      }
    }
  }
}

export const sessionManager = new SessionManager();
