import React, { useState } from 'react';

interface InputDisplayProps {
  content: string;
  isWaitingForConnection: boolean;
  isConnected: boolean;
}

export const InputDisplay: React.FC<InputDisplayProps> = ({
  content,
  isWaitingForConnection,
  isConnected
}) => {
  const [showCopyToast, setShowCopyToast] = useState(false);

  const handleCopy = () => {
    if (content) {
      navigator.clipboard.writeText(content);
      setShowCopyToast(true);
      setTimeout(() => setShowCopyToast(false), 2000);
    }
  };
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-4">
      <div className="w-full max-w-2xl">
        {/* 状态指示器 */}
        <div className="mb-6 text-center">
          {isWaitingForConnection && (
            <div className="inline-flex items-center px-4 py-2 bg-yellow-100 text-yellow-800 rounded-full">
              <div className="animate-spin mr-2 h-4 w-4 border-2 border-yellow-600 border-t-transparent rounded-full"></div>
              等待App扫描连接...
            </div>
          )}
          {isConnected && (
            <div className="inline-flex items-center px-4 py-2 bg-green-100 text-green-800 rounded-full">
              <div className="mr-2 h-3 w-3 bg-green-500 rounded-full animate-pulse"></div>
              已连接
            </div>
          )}
        </div>

        {/* 输入显示区 */}
        <div className="bg-white rounded-2xl shadow-2xl p-8 min-h-[300px]">
          <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">
            AirWord 输入显示
          </h1>

          <div className="relative">
            <div className={`rounded-lg p-6 min-h-[200px] ${content ? 'bg-gray-50 border-2 border-gray-200' : 'bg-gray-50 border-2 border-dashed border-gray-300 flex items-center justify-center'}`}>
              {content ? (
                <p className="text-xl text-gray-800 whitespace-pre-wrap break-words leading-relaxed">
                  {content}
                </p>
              ) : (
                <p className="text-gray-400 text-center">
                  {isConnected
                    ? '在App中输入，内容将实时显示在这里...'
                    : '请先使用App扫描二维码建立连接'}
                </p>
              )}
            </div>
            <button
              onClick={handleCopy}
              disabled={!content}
              className={`mt-4 w-full font-medium py-3 px-6 rounded-lg transition-colors duration-200 ${
                content
                  ? 'bg-indigo-600 hover:bg-indigo-700 text-white cursor-pointer'
                  : 'bg-gray-300 text-gray-500 cursor-not-allowed'
              }`}
            >
              复制内容
            </button>
          </div>
        </div>

        {/* 复制成功提示 */}
        {showCopyToast && (
          <div className="fixed top-8 left-1/2 transform -translate-x-1/2 z-50 animate-bounce">
            <div className="bg-gray-800 text-white px-6 py-3 rounded-lg shadow-lg flex items-center gap-2">
              <svg className="w-5 h-5 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
              <span className="font-medium">复制成功！</span>
            </div>
          </div>
        )}

        {/* 使用说明 */}
        <div className="mt-6 text-center text-sm text-gray-600">
          <p>连接后，App端的输入会实时同步到此处</p>
        </div>
      </div>
    </div>
  );
};
