import { useState, useEffect, useCallback, useRef } from 'react';
import { QRCodeDisplay } from './components/QRCodeDisplay';
import { DesktopInput } from './components/DesktopInput';
import { useWebSocket } from './services/websocket';
import { api } from './services/api';
import { WebSocketMessage } from './types';

// 创建electronAPI（开发环境）
const createElectronAPI = () => {
  if (window.require) {
    const { ipcRenderer, clipboard } = window.require('electron');
    return {
      typeText: (text: string) => ipcRenderer.invoke('type-text', text),
      deleteText: (count: number) => ipcRenderer.invoke('delete-text', count),
      copyText: (text: string) => {
        clipboard.writeText(text);
      },
    };
  }
  return (window as any).electronAPI;
};

function App() {
  const [sessionId, setSessionId] = useState<string>('');
  const [qrCode, setQrCode] = useState<string>('');
  const [inputContent, setInputContent] = useState<string>('');
  const [isConnected, setIsConnected] = useState<boolean>(false);
  const [showQRCode, setShowQRCode] = useState<boolean>(true);
  const [inputMode, setInputMode] = useState<'display' | 'direct'>('display');
  const lastContentRef = useRef<string>('');

  // 初始化electronAPI
  useEffect(() => {
    (window as any).electronAPI = createElectronAPI();
    console.log('ElectronAPI initialized:', !!(window as any).electronAPI);
  }, []);

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
    // console.log('Desktop received message:', message, 'Current mode:', inputMode);

    switch (message.type) {
      case 'input':
        if (message.content !== undefined) {
          const newContent = message.content;
          const lastContent = lastContentRef.current;

          console.log('Content update:', { lastContent, newContent, mode: inputMode });

          // 直接输入模式：自动发送到光标位置
          if (inputMode === 'direct') {
            if (newContent.length > lastContent.length) {
              // 新增字符
              const newChars = newContent.slice(lastContent.length);
              console.log('Typing new chars:', newChars);

              if (window.electronAPI) {
                window.electronAPI.typeText(newChars).then(result => {
                  // console.log('Type result:', result);
                }).catch(err => {
                  console.error('Type error:', err);
                });
              } else {
                console.error('electronAPI not available!');
              }
            } else if (newContent.length < lastContent.length) {
              // 删除字符
              const deleteCount = lastContent.length - newContent.length;
              // console.log('Deleting chars:', deleteCount);

              if (window.electronAPI) {
                window.electronAPI.deleteText(deleteCount).then(result => {
                  // console.log('Delete result:', result);
                }).catch(err => {
                  console.error('Delete error:', err);
                });
              }
            }
          }

          setInputContent(newContent);
          lastContentRef.current = newContent;
        }
        break;
      case 'delete':
        if (message.content !== undefined) {
          const newContent = message.content;
          const lastContent = lastContentRef.current;

          console.log('Delete content:', { lastContent, newContent, mode: inputMode });

          // 直接输入模式：自动删除
          if (inputMode === 'direct' && newContent.length < lastContent.length) {
            const deleteCount = lastContent.length - newContent.length;
            console.log('Deleting chars:', deleteCount);

            if (window.electronAPI) {
              window.electronAPI.deleteText(deleteCount).then(result => {
                console.log('Delete result:', result);
              }).catch(err => {
                console.error('Delete error:', err);
              });
            }
          }

          setInputContent(newContent);
          lastContentRef.current = newContent;
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
  }, [inputMode]);

  const handleConnect = useCallback(() => {
    console.log('Desktop WebSocket connected');
  }, []);

  const handleDisconnect = useCallback(() => {
    console.log('Desktop WebSocket disconnected');
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

  // 监听模式切换，重置lastContentRef
  useEffect(() => {
    console.log('Mode changed to:', inputMode, 'current content:', inputContent);
    if (inputMode === 'direct') {
      // 切换到直接输入模式时，重置lastContentRef为当前内容
      lastContentRef.current = inputContent;
      console.log('Reset lastContentRef to:', inputContent);
    }
  }, [inputMode]);

  // 断开连接并重新生成二维码
  const handleDisconnectAndReset = useCallback(async () => {
    console.log('Disconnecting and resetting...');
    setIsConnected(false);
    setShowQRCode(true);
    setInputContent('');
    lastContentRef.current = '';

    // 创建新的session
    try {
      const session = await api.createSession();
      setSessionId(session.sessionId);
      setQrCode(session.qrCode);
      console.log('New session created:', session.sessionId);
    } catch (error) {
      console.error('Failed to create new session:', error);
    }
  }, []);

  if (showQRCode && qrCode) {
    return <QRCodeDisplay qrCode={qrCode} sessionId={sessionId} />;
  }

  return (
    <DesktopInput
      content={inputContent}
      isConnected={isConnected}
      inputMode={inputMode}
      setInputMode={setInputMode}
      onDisconnect={handleDisconnectAndReset}
    />
  );
}

export default App;
