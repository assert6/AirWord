import React from 'react';

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

          {content ? (
            <div className="relative">
              <div className="bg-gray-50 rounded-lg p-6 min-h-[200px] border-2 border-gray-200">
                <p className="text-xl text-gray-800 whitespace-pre-wrap break-words leading-relaxed">
                  {content}
                </p>
              </div>
              <button
                onClick={() => {
                  navigator.clipboard.writeText(content);
                }}
                className="mt-4 w-full bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200"
              >
                复制内容
              </button>
            </div>
          ) : (
            <div className="bg-gray-50 rounded-lg p-6 min-h-[200px] border-2 border-dashed border-gray-300 flex items-center justify-center">
              <p className="text-gray-400 text-center">
                {isConnected
                  ? '在App中输入，内容将实时显示在这里...'
                  : '请先使用App扫描二维码建立连接'}
              </p>
            </div>
          )}
        </div>

        {/* 使用说明 */}
        <div className="mt-6 text-center text-sm text-gray-600">
          <p>连接后，App端的输入会实时同步到此处</p>
        </div>
      </div>
    </div>
  );
};
