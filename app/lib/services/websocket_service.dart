import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/websocket_message.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String _wsUrl = 'ws://localhost:3001';
  String? _sessionId;
  StreamController<WebSocketMessage>? _messageController;
  Timer? _heartbeatTimer;
  bool _isConnected = false;

  Stream<WebSocketMessage>? get messageStream =>
      _messageController?.stream;

  bool get isConnected => _isConnected;

  Future<void> connect(String sessionId) async {
    try {
      _sessionId = sessionId;
      _messageController = StreamController<WebSocketMessage>.broadcast();

      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));

      // 监听消息
      _channel!.stream.listen(
        (data) {
          final message = WebSocketMessage.fromJson(
            json.decode(data) as Map<String, dynamic>,
          );
          _messageController?.add(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isConnected = false;
        },
        onDone: () {
          print('WebSocket connection closed');
          _isConnected = false;
          _heartbeatTimer?.cancel();
        },
      );

      // 发送连接消息
      sendConnect();

      // 启动心跳
      _startHeartbeat();

      _isConnected = true;
    } catch (e) {
      print('Failed to connect: $e');
      _isConnected = false;
    }
  }

  void sendConnect() {
    final message = WebSocketMessage(
      type: 'connect',
      sessionId: _sessionId,
      clientType: 'app',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _channel?.sink.add(json.encode(message.toJson()));
  }

  void sendInput(String content) {
    if (!isConnected) return;

    final message = WebSocketMessage(
      type: 'input',
      sessionId: _sessionId,
      clientType: 'app',
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _channel?.sink.add(json.encode(message.toJson()));
  }

  void sendDelete(String content) {
    if (!isConnected) return;

    final message = WebSocketMessage(
      type: 'delete',
      sessionId: _sessionId,
      clientType: 'app',
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _channel?.sink.add(json.encode(message.toJson()));
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        final message = WebSocketMessage(
          type: 'heartbeat',
          sessionId: _sessionId,
          clientType: 'app',
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        _channel?.sink.add(json.encode(message.toJson()));
      },
    );
  }

  void disconnect() {
    _heartbeatTimer?.cancel();
    _messageController?.close();
    _channel?.sink.close();
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _messageController?.close();
  }
}
