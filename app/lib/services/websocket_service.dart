import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/websocket_message.dart';
import '../config/app_config.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  String? _sessionId;
  StreamController<WebSocketMessage>? _messageController;
  StreamController<bool>? _connectionController;
  Timer? _heartbeatTimer;
  bool _isConnected = false;
  StreamSubscription? _streamSubscription;

  Stream<WebSocketMessage>? get messageStream => _messageController?.stream;
  Stream<bool>? get connectionStream => _connectionController?.stream;

  bool get isConnected => _isConnected;

  Future<void> connect(String sessionId) async {
    await _connect(sessionId);
  }

  Future<void> _connect(String sessionId) async {
    try {
      print('Connecting to WebSocket: ${AppConfig.wsUrl}');

      _sessionId = sessionId;

      // 如果已存在消息控制器，不重新创建以保持订阅
      _messageController ??= StreamController<WebSocketMessage>.broadcast();
      _connectionController ??= StreamController<bool>.broadcast();

      _channel = WebSocketChannel.connect(Uri.parse(AppConfig.wsUrl));

      // 取消之前的订阅
      await _streamSubscription?.cancel();

      // 监听消息
      _streamSubscription = _channel!.stream.listen(
        (data) {
          final message = WebSocketMessage.fromJson(
            json.decode(data) as Map<String, dynamic>,
          );
          _messageController?.add(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isConnected = false;
          _connectionController?.add(false);
        },
        onDone: () {
          print('WebSocket connection closed');
          _isConnected = false;
          _connectionController?.add(false);
          _heartbeatTimer?.cancel();
        },
      );

      // 发送连接消息
      sendConnect();

      // 启动心跳
      _startHeartbeat();

      _isConnected = true;
      _connectionController?.add(true);
      print('WebSocket connected successfully');
    } catch (e) {
      print('Failed to connect: $e');
      _isConnected = false;
      _connectionController?.add(false);
    }
  }

  Future<void> reconnect() async {
    print('Reconnecting to WebSocket... ${_sessionId ?? 'null'}');
    disconnect();
    // await _streamSubscription?.cancel();
    // _heartbeatTimer?.cancel();

    if (_sessionId != null) {
      await _connect(_sessionId!);
    }
    print('isConnected: ${isConnected}');
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
    _streamSubscription?.cancel();
    _messageController?.close();
    _connectionController?.close();
    _channel?.sink.close();
    _isConnected = false;
    _messageController = null;
    _connectionController = null;
  }

  void dispose() {
    disconnect();
  }
}
