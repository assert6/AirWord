import 'package:flutter/material.dart';
import '../services/websocket_service.dart';
import '../models/websocket_message.dart';

class InputScreen extends StatefulWidget {
  final String sessionId;

  const InputScreen({super.key, required this.sessionId});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late WebSocketService _wsService;
  final TextEditingController _textController = TextEditingController();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _wsService = WebSocketService();

    // 连接WebSocket
    _wsService.connect(widget.sessionId);

    // 监听连接状态
    _wsService.messageStream?.listen((message) {
      if (message.type == 'connect') {
        setState(() {
          _isConnected = true;
        });
      }
    });
  }

  @override
  void dispose() {
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
      appBar: AppBar(
        title: const Text('AirWord 输入'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isConnected ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _isConnected ? '已连接' : '连接中...',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 连接信息
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '会话信息',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Session ID: ${widget.sessionId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 输入区域
            Expanded(
              child: TextField(
                controller: _textController,
                onChanged: _onTextChanged,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: '在这里输入，内容会实时同步到Web端...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlignVertical: TextAlignVertical.top,
              ),
            ),

            const SizedBox(height: 16),

            // 清空按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _textController.clear();
                  _wsService.sendDelete('');
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('清空内容'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
