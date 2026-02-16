import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../models/ws_message.dart';
import '../services/webrtc_service.dart';
import 'websocket_provider.dart';

final webrtcProvider = Provider<WebRtcManager>((ref) {
  final manager = WebRtcManager(ref);
  ref.onDispose(() => manager.dispose());
  return manager;
});

final rtcVideoRendererProvider = FutureProvider<RTCVideoRenderer>((ref) async {
  final manager = ref.watch(webrtcProvider);
  await manager.initialize();
  return manager.renderer;
});

class WebRtcManager {
  final Ref _ref;
  final WebRtcService _service = WebRtcService();
  StreamSubscription<IceMessage>? _iceSub;
  bool _initialized = false;

  WebRtcManager(this._ref);

  RTCVideoRenderer get renderer => _service.renderer;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _service.initialize();

    _iceSub = _service.iceCandidates.listen((ice) {
      _ref.read(websocketServiceProvider).send(ice);
    });
  }

  Future<void> handleSdp(SdpMessage sdp) async {
    await initialize();
    final answer = await _service.handleSdpOffer(sdp);
    if (answer != null) {
      _ref.read(websocketServiceProvider).send(answer);
    }
  }

  Future<void> handleIce(IceMessage ice) async {
    await _service.addIceCandidate(ice);
  }

  Future<void> dispose() async {
    _iceSub?.cancel();
    await _service.dispose();
  }
}
