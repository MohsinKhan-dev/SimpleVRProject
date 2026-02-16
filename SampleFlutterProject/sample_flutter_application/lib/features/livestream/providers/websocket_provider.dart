import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ws_message.dart';
import '../services/websocket_service.dart';
import 'detection_provider.dart';
import 'webrtc_provider.dart';

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(() => service.dispose());
  return service;
});

final websocketConnectionStateProvider =
    StreamProvider<WebSocketConnectionState>((ref) {
  final service = ref.watch(websocketServiceProvider);
  return service.connectionState;
});

final websocketProvider = Provider<WebSocketManager>((ref) {
  return WebSocketManager(ref);
});

class WebSocketManager {
  final Ref _ref;
  StreamSubscription<WsMessage>? _messageSub;

  WebSocketManager(this._ref);

  Future<void> connect(String url, {String? apiKey}) async {
    final service = _ref.read(websocketServiceProvider);
    await service.connect(url, apiKey: apiKey);
    _listenToMessages();
  }

  void _listenToMessages() {
    _messageSub?.cancel();
    final service = _ref.read(websocketServiceProvider);
    _messageSub = service.messages.listen(_routeMessage);
  }

  void _routeMessage(WsMessage message) {
    switch (message) {
      case SdpMessage():
        _ref.read(webrtcProvider).handleSdp(message);
      case IceMessage():
        _ref.read(webrtcProvider).handleIce(message);
      case DetectionsMessage():
        _ref
            .read(detectionProvider.notifier)
            .updateDetections(message.detections);
      case ResponseMessage():
        _ref.read(detectionProvider.notifier).addResponse(message);
      case NotificationMessage():
        // Outbound-only; ignore inbound
        break;
    }
  }

  void send(WsMessage message) {
    _ref.read(websocketServiceProvider).send(message);
  }

  void dispose() {
    _messageSub?.cancel();
  }
}
