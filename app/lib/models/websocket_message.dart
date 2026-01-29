class WebSocketMessage {
  final String type;
  final String? sessionId;
  final String? clientType;
  final String? content;
  final int timestamp;

  WebSocketMessage({
    required this.type,
    this.sessionId,
    this.clientType,
    this.content,
    required this.timestamp,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] as String,
      sessionId: json['sessionId'] as String?,
      clientType: json['clientType'] as String?,
      content: json['content'] as String?,
      timestamp: json['timestamp'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sessionId': sessionId,
      'clientType': clientType,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
