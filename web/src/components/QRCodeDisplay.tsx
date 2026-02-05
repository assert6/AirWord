import React, { useState } from 'react';

interface QRCodeDisplayProps {
  qrCode: string;
  sessionId: string;
}

export const QRCodeDisplay: React.FC<QRCodeDisplayProps> = ({ qrCode, sessionId }) => {
  const [showCopyToast, setShowCopyToast] = useState(false);

  const handleCopySessionId = () => {
    navigator.clipboard.writeText(sessionId);
    setShowCopyToast(true);
    setTimeout(() => setShowCopyToast(false), 2000);
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gradient-to-br from-indigo-500 to-purple-600 p-4">
      {/* 复制成功气泡提示 */}
      {showCopyToast && (
        <div className="fixed top-8 left-1/2 transform -translate-x-1/2 z-50 animate-bounce">
          <div className="bg-gray-800 text-white px-6 py-3 rounded-lg shadow-lg flex items-center gap-2">
            <svg className="w-5 h-5 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
            </svg>
            <span className="font-medium">Session ID 已复制！</span>
          </div>
        </div>
      )}

      <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full">
        <h1 className="text-3xl font-bold text-gray-800 mb-2 text-center">
          <span
              style={{
                background: 'linear-gradient(135deg, #9333EA 0%, #4F46E5 50%, #10B981 100%)',
                WebkitBackgroundClip: 'text',
                WebkitTextFillColor: 'transparent',
                backgroundClip: 'text'
              }}
          >AirWord</span>
        </h1>
        <p className="text-gray-600 text-center mb-8">
          使用App扫描二维码建立连接
        </p>

        {/* 二维码显示 */}
        <div className="flex justify-center mb-6">
          <div className="bg-white p-4 rounded-lg shadow-inner border-2 border-gray-200">
            <img src={qrCode} alt="AirWord QR Code" className="w-64 h-64" />
          </div>
        </div>

        {/* Session ID 显示 */}
        <div className="bg-gray-50 rounded-lg p-4 mb-6">
          <div className="flex justify-between items-center mb-1">
            <p className="text-xs text-gray-500">会话ID (调试用)</p>
            <button
              onClick={handleCopySessionId}
              className="text-xs text-indigo-600 hover:text-indigo-800 font-medium"
            >
              复制
            </button>
          </div>
          <p className="text-sm font-mono text-gray-800 break-all">{sessionId}</p>
          <p className="text-xs text-gray-400 mt-2">💡或使用"手动输入Session ID"功能</p>
        </div>

        {/* 使用说明 */}
        <div className="space-y-3 text-sm text-gray-600">
          <div className="flex items-start">
            <div className="flex-shrink-0 w-6 h-6 bg-indigo-100 rounded-full flex items-center justify-center mr-3">
              <span className="text-indigo-600 font-bold">1</span>
            </div>
            <p>打开AirWord App</p>
          </div>
          <div className="flex items-start">
            <div className="flex-shrink-0 w-6 h-6 bg-indigo-100 rounded-full flex items-center justify-center mr-3">
              <span className="text-indigo-600 font-bold">2</span>
            </div>
            <p>点击扫描二维码按钮</p>
          </div>
          <div className="flex items-start">
            <div className="flex-shrink-0 w-6 h-6 bg-indigo-100 rounded-full flex items-center justify-center mr-3">
              <span className="text-indigo-600 font-bold">3</span>
            </div>
            <p>扫描上方二维码建立连接</p>
          </div>
        </div>

        {/* 进入按钮 */}
        <button
          onClick={() => window.location.reload()}
          className="mt-8 w-full bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200"
        >
          生成新二维码
        </button>
      </div>
    </div>
  );
};
