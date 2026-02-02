import 'package:flutter/material.dart';
import '../services/websocket_service.dart';

// 品牌颜色 - 与桌面端/Web端一致
class AppColors {
  static const Color primaryPurple = Color(0xFF9333EA); // purple-600
  static const Color primaryIndigo = Color(0xFF4F46E5); // indigo-600
  static const Color greenAccent = Color(0xFF10B981); // green-500
  static const Color yellowAccent = Color(0xFFF59E0B); // amber-500
  static const Color textDark = Color(0xFF1F2937); // gray-800
  static const Color textGray = Color(0xFF6B7280); // gray-600
}

class InputScreen extends StatefulWidget {
  final String sessionId;

  const InputScreen({super.key, required this.sessionId});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> with WidgetsBindingObserver {
  late WebSocketService _wsService;
  final TextEditingController _textController = TextEditingController();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _wsService = WebSocketService();
    _wsService.connect(widget.sessionId);

    _wsService.messageStream?.listen((message) {
      if (message.type == 'connect') {
        setState(() {
          _isConnected = true;
        });
      } else if (message.type == 'disconnect') {
        setState(() {
          _isConnected = false;
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print('App resumed, reconnecting WebSocket...');
        setState(() {
          _isConnected = false;
        });
        _wsService.reconnect();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _wsService.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    _wsService.sendInput(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF), // purple-50
      body: SafeArea(
        child: Column(
          children: [
            // 顶部栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: AppColors.textDark),
                    onPressed: () {
                      _wsService.disconnect();
                      Navigator.pop(context);
                    },
                    tooltip: '返回',
                  ),
                  const Expanded(
                    child: Text(
                      'AirWord 输入',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  // 连接状态指示器
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isConnected
                          ? AppColors.greenAccent.withOpacity(0.1)
                          : AppColors.yellowAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isConnected
                            ? AppColors.greenAccent
                            : AppColors.yellowAccent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isConnected)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.yellowAccent,
                                ),
                              ),
                            ),
                          ),
                        Text(
                          _isConnected ? '已连接' : '连接中',
                          style: TextStyle(
                            color: _isConnected
                                ? AppColors.greenAccent
                                : AppColors.yellowAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_isConnected)
                    IconButton(
                      icon:
                          const Icon(Icons.link_off, color: AppColors.textGray),
                      onPressed: () {
                        _wsService.disconnect();
                        Navigator.pop(context);
                      },
                      tooltip: '断开连接',
                    ),
                ],
              ),
            ),

            // 内容区
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 会话信息卡片
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.info_outline,
                                  color: AppColors.primaryPurple,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '会话信息',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Session ID: ${widget.sessionId}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textGray,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 输入区域
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.primaryPurple,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '输入区域',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: TextField(
                              controller: _textController,
                              onChanged: _onTextChanged,
                              maxLines: null,
                              expands: true,
                              decoration: InputDecoration(
                                hintText: '在这里输入，内容会实时同步到桌面端...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9FAFB), // gray-50
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: AppColors.textDark,
                              ),
                              textAlignVertical: TextAlignVertical.top,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 清空按钮
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _textController.clear();
                          _wsService.sendDelete('');
                        },
                        icon: const Icon(Icons.delete_outline, size: 22),
                        label: const Text(
                          '清空内容',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textGray,
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 提示信息
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryIndigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryIndigo.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primaryIndigo,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '在此处输入的内容会实时同步到桌面端或Web端',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryIndigo,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
