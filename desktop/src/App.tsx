import React, { useState, useEffect, useCallback, useRef } from 'react';
import { DesktopInput } from './components/DesktopInput';
import { useWebSocket } from './services/websocket';
import { api } from './services/api';
import { WebSocketMessage } from './types';

function App() {
  const [sessionId] = useState<string>('');
  const [inputContent, setInputContent] = useState<string>('');
  const [isConnected, setIsConnected] = useState<boolean>(false);
  const lastContentRef = useRef<string>('');

  // WebSocket消息处理
  const handleMessage = useCallback((message: WebSocketMessage) => {
    console.log('Desktop received message:', message);

    switch (message.type) {
      case 'input':
        if (message.content !== undefined) {
          setInputContent(message.content);

          // 自动发送到光标位置 (直接输入模式)
          const newContent = message.content;
          const lastContent = lastContentRef.current;

          if (newContent.length > lastContent.length) {
            // 新增字符
            const newChars = newContent.slice(lastContent.length);
            if (window.electronAPI) {
              window.electronAPI.typeText(newChars);
            }
          } else if (newContent.length < lastContent.length) {
            // 删除字符
            const deleteCount = lastContent.length - newContent.length;
            if (window.electronAPI) {
              window.electronAPI.deleteText(deleteCount);
            }
          }

          lastContentRef.current = newContent;
        }
        break;
      case 'delete':
        if (message.content !== undefined) {
          setInputContent(message.content);
          lastContentRef.current = message.content;
        }
        break;
      case 'connect':
        if (message.clientType === 'app') {
          setIsConnected(true);
        }
        break;
      case 'disconnect':
        if (message.clientType === 'app') {
          setIsConnected(false);
        }
        break;
      default:
        break;
    }
  }, []);

  const handleConnect = useCallback(() => {
    console.log('Desktop WebSocket connected');
  }, []);

  const handleDisconnect = useCallback(() => {
    console.log('Desktop WebSocket disconnected');
    setIsConnected(false);
  }, []);

  // WebSocket连接 (需要手动连接，因为需要sessionId)
  // 这里假设sessionId已经通过某种方式获取

  return (
    <DesktopInput
      content={inputContent}
      isConnected={isConnected}
    />
  );
}

export default App;
