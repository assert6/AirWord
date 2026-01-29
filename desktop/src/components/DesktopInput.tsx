import React, { useState } from 'react';
import { WebSocketMessage } from '../types';

interface DesktopInputProps {
  content: string;
  isConnected: boolean;
}

export const DesktopInput: React.FC<DesktopInputProps> = ({ content, isConnected }) => {
  const [inputMode, setInputMode] = useState<'display' | 'direct'>('display');
  const [lastTypedContent, setLastTypedContent] = useState('');

  const handleDirectInput = async (text: string) => {
    try {
      if (window.electronAPI) {
        await window.electronAPI.typeText(text);
        setLastTypedContent(text);
      }
    } catch (error) {
      console.error('Failed to type text:', error);
    }
  };

  const handleDirectDelete = async (currentLength: number) => {
    try {
      if (window.electronAPI && currentLength < lastTypedContent.length) {
        const deleteCount = lastTypedContent.length - currentLength;
        await window.electronAPI.deleteText(deleteCount);
        setLastTypedContent(lastTypedContent.slice(0, currentLength));
      }
    } catch (error) {
      console.error('Failed to delete text:', error);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gradient-to-br from-purple-50 to-pink-100 p-4">
      <div className="w-full max-w-3xl">
        {/* 状态指示器 */}
        <div className="mb-6 text-center">
          {isConnected ? (
            <div className="inline-flex items-center px-4 py-2 bg-green-100 text-green-800 rounded-full">
              <div className="mr-2 h-3 w-3 bg-green-500 rounded-full animate-pulse"></div>
              已连接到App
            </div>
          ) : (
            <div className="inline-flex items-center px-4 py-2 bg-yellow-100 text-yellow-800 rounded-full">
              <div className="animate-spin mr-2 h-4 w-4 border-2 border-yellow-600 border-t-transparent rounded-full"></div>
              等待连接...
            </div>
          )}
        </div>

        {/* 模式切换 */}
        <div className="mb-6 bg-white rounded-lg shadow-md p-2">
          <div className="flex gap-2">
            <button
              onClick={() => setInputMode('display')}
              className={`flex-1 py-3 px-4 rounded-lg font-medium transition-colors ${
                inputMode === 'display'
                  ? 'bg-purple-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              显示模式
            </button>
            <button
              onClick={() => setInputMode('direct')}
              className={`flex-1 py-3 px-4 rounded-lg font-medium transition-colors ${
                inputMode === 'direct'
                  ? 'bg-purple-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              直接输入模式
            </button>
          </div>
        </div>

        {/* 显示模式 */}
        {inputMode === 'display' && (
          <div className="bg-white rounded-2xl shadow-2xl p-8">
            <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">
              AirWord PC - 显示模式
            </h1>

            {content ? (
              <div>
                <div className="bg-gray-50 rounded-lg p-6 min-h-[200px] border-2 border-gray-200">
                  <p className="text-xl text-gray-800 whitespace-pre-wrap break-words leading-relaxed">
                    {content}
                  </p>
                </div>
                <div className="mt-4 flex gap-3">
                  <button
                    onClick={() => {
                      navigator.clipboard.writeText(content);
                    }}
                    className="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200"
                  >
                    复制内容
                  </button>
                  <button
                    onClick={async () => {
                      if (window.electronAPI) {
                        await window.electronAPI.typeText(content);
                      }
                    }}
                    className="flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200"
                  >
                    模拟键盘输入
                  </button>
                </div>
              </div>
            ) : (
              <div className="bg-gray-50 rounded-lg p-6 min-h-[200px] border-2 border-dashed border-gray-300 flex items-center justify-center">
                <p className="text-gray-400 text-center">
                  {isConnected
                    ? '在App中输入，内容将实时显示在这里...'
                    : '请先连接App'}
                </p>
              </div>
            )}

            <div className="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
              <p className="text-sm text-blue-800">
                <strong>提示:</strong> 显示模式只显示内容，不会自动输入到光标位置。
                点击"模拟键盘输入"可将内容输入到当前光标位置。
              </p>
            </div>
          </div>
        )}

        {/* 直接输入模式 */}
        {inputMode === 'direct' && (
          <div className="bg-white rounded-2xl shadow-2xl p-8">
            <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">
              AirWord PC - 直接输入模式
            </h1>

            <div className="bg-yellow-50 rounded-lg p-4 mb-6 border-2 border-yellow-300">
              <p className="text-sm text-yellow-800">
                <strong>⚠️ 注意:</strong> 直接输入模式会将App的输入直接发送到光标位置。
                使用前请确保光标在正确的位置！
              </p>
            </div>

            {content ? (
              <div>
                <div className="bg-gray-50 rounded-lg p-6 min-h-[200px] border-2 border-gray-200">
                  <p className="text-xl text-gray-800 whitespace-pre-wrap break-words leading-relaxed">
                    {content}
                  </p>
                </div>

                <div className="mt-4 p-4 bg-green-50 rounded-lg border border-green-200">
                  <p className="text-sm text-green-800">
                    ✓ 已自动输入 {content.length} 个字符到光标位置
                  </p>
                </div>
              </div>
            ) : (
              <div className="bg-gray-50 rounded-lg p-6 min-h-[200px] border-2 border-dashed border-gray-300 flex items-center justify-center">
                <p className="text-gray-400 text-center">
                  {isConnected
                    ? '在App中输入，内容将直接输入到光标位置...'
                    : '请先连接App'}
                </p>
              </div>
            )}

            <div className="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
              <p className="text-sm text-blue-800">
                <strong>提示:</strong> 直接输入模式会自动将App的输入通过模拟键盘发送到当前光标位置。
                确保你的光标在想要输入的位置！
              </p>
            </div>
          </div>
        )}

        {/* 使用说明 */}
        <div className="mt-6 text-center text-sm text-gray-600">
          <p>连接后，App端的输入会实时同步到PC端</p>
          <p className="mt-1">
            快捷键: <kbd className="px-2 py-1 bg-gray-200 rounded">Ctrl+Shift+A</kbd> 显示/隐藏窗口
          </p>
        </div>
      </div>
    </div>
  );
};
