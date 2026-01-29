import React, { useState, useEffect, useCallback } from 'react';
import { QRCodeDisplay } from './components/QRCodeDisplay';
import { InputDisplay } from './components/InputDisplay';
import { useWebSocket } from './services/websocket';
import { api } from './services/api';
import { WebSocketMessage } from './types';

function App() {
  const [sessionId, setSessionId] = useState<string>('');
  const [qrCode, setQrCode] = useState<string>('');
  const [inputContent, setInputContent] = useState<string>('');
  const [isConnected, setIsConnected] = useState<boolean>(false);
  const [showQRCode, setShowQRCode] = useState<boolean>(true);

  // 初始化会话
  useEffect(() => {
    const initSession = async () => {
      try {
        const session = await api.createSession();
        setSessionId(session.sessionId);
        setQrCode(session.qrCode);
      } catch (error) {
        console.error('Failed to create session:', error);
      }
    };

    initSession();
  }, []);

  // WebSocket消息处理
  const handleMessage = useCallback((message: WebSocketMessage) => {
    console.log('Received message:', message);

    switch (message.type) {
      case 'input':
        if (message.content !== undefined) {
          console.log('Setting input content:', message.content);
          setInputContent(message.content);
        }
        break;
      case 'delete':
        if (message.content !== undefined) {
          console.log('Deleting content, new:', message.content);
          setInputContent(message.content);
        }
        break;
      case 'connect':
        if (message.clientType === 'app') {
          console.log('App connected!');
          setIsConnected(true);
          setShowQRCode(false);
        }
        break;
      case 'disconnect':
        if (message.clientType === 'app') {
          console.log('App disconnected');
          setIsConnected(false);
        }
        break;
      default:
        console.log('Unknown message type:', message.type);
        break;
    }
  }, []);

  const handleConnect = useCallback(() => {
    console.log('WebSocket connected');
  }, []);

  const handleDisconnect = useCallback(() => {
    console.log('WebSocket disconnected');
    setIsConnected(false);
  }, []);

  // WebSocket连接
  const { connect } = useWebSocket(sessionId, handleMessage, handleConnect, handleDisconnect);

  // 当有sessionId时自动连接WebSocket
  useEffect(() => {
    if (sessionId) {
      console.log('Connecting to WebSocket with sessionId:', sessionId);
      connect();
    }
  }, [sessionId, connect]);

  if (showQRCode && qrCode) {
    return <QRCodeDisplay qrCode={qrCode} sessionId={sessionId} />;
  }

  return (
    <InputDisplay
      content={inputContent}
      isWaitingForConnection={!isConnected}
      isConnected={isConnected}
    />
  );
}

export default App;
