import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/ws_message.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final _messageController = StreamController<WsMessage>.broadcast();
  final _connectionStateController =
      StreamController<WebSocketConnectionState>.broadcast();
  Timer? _reconnectTimer;
  String? _url;
  String? _apiKey;

  Stream<WsMessage> get messages => _messageController.stream;
  Stream<WebSocketConnectionState> get connectionState =>
      _connectionStateController.stream;

  Future<void> connect(String url, {String? apiKey}) async {
    _url = url;
    _apiKey = apiKey;
    _reconnectTimer?.cancel();
    await _disconnect();

    _connectionStateController.add(WebSocketConnectionState.connecting);

    try {
      final uri = apiKey != null
          ? Uri.parse(url).replace(queryParameters: {'apiKey': apiKey})
          : Uri.parse(url);
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;
      _connectionStateController.add(WebSocketConnectionState.connected);

      _channel!.stream.listen(
        (data) {
          try {
            final message = WsMessage.fromJson(data as String);
            _messageController.add(message);
          } catch (e) {
            // Skip malformed messages
          }
        },
        onError: (_) => _handleDisconnect(),
        onDone: () => _handleDisconnect(),
      );
    } catch (_) {
      _handleDisconnect();
    }
  }

  void send(WsMessage message) {
    _channel?.sink.add(message.encode());
  }

  void _handleDisconnect() {
    _connectionStateController.add(WebSocketConnectionState.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (_url != null) {
        connect(_url!, apiKey: _apiKey);
      }
    });
  }

  Future<void> _disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  Future<void> dispose() async {
    _reconnectTimer?.cancel();
    await _disconnect();
    await _messageController.close();
    await _connectionStateController.close();
  }
}

enum WebSocketConnectionState { disconnected, connecting, connected }
