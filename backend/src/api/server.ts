import express from 'express';
import cors from 'cors';
import QRCode from 'qrcode';
import { sessionManager } from '../session/sessionManager';

const app = express();

app.use(cors());
app.use(express.json());

// 生成新会话
app.post('/api/session/create', async (req, res) => {
  try {
    const session = sessionManager.createSession();

    // 生成二维码URL (包含session ID)
    const qrCodeData = JSON.stringify({
      sessionId: session.sessionId,
      type: 'airword-session'
    });

    const qrCodeUrl = await QRCode.toDataURL(qrCodeData, {
      width: 300,
      margin: 2
    });

    res.json({
      sessionId: session.sessionId,
      qrCode: qrCodeUrl,
      createdAt: session.createdAt
    });
  } catch (error) {
    console.error('Failed to create session:', error);
    res.status(500).json({ error: 'Failed to create session' });
  }
});

// 检查会话状态
app.get('/api/session/:sessionId/status', (req, res) => {
  const { sessionId } = req.params;
  const session = sessionManager.getSession(sessionId);

  if (!session) {
    return res.status(404).json({ error: 'Session not found' });
  }

  res.json({
    sessionId: session.sessionId,
    webConnected: session.webClient !== null,
    appConnected: session.appClient !== null,
    lastActivity: session.lastActivity
  });
});

// 健康检查
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

export { app };
