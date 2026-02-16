import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../config/app_config.dart';
import '../models/ws_message.dart';

class WebRtcService {
  RTCPeerConnection? _peerConnection;
  final RTCVideoRenderer renderer = RTCVideoRenderer();
  final _iceCandidateController = StreamController<IceMessage>.broadcast();

  Stream<IceMessage> get iceCandidates => _iceCandidateController.stream;

  Future<void> initialize() async {
    await renderer.initialize();
    _peerConnection = await createPeerConnection(AppConfig.rtcConfiguration);

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        renderer.srcObject = event.streams[0];
      }
    };

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _iceCandidateController.add(IceMessage(
        candidate: candidate.candidate!,
        sdpMid: candidate.sdpMid,
        sdpMLineIndex: candidate.sdpMLineIndex,
      ));
    };
  }

  Future<SdpMessage?> handleSdpOffer(SdpMessage offer) async {
    if (_peerConnection == null) return null;

    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(offer.sdp, offer.sdpType),
    );

    if (offer.sdpType == 'offer') {
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      return SdpMessage(sdpType: answer.type!, sdp: answer.sdp!);
    }
    return null;
  }

  Future<void> addIceCandidate(IceMessage ice) async {
    await _peerConnection?.addCandidate(
      RTCIceCandidate(ice.candidate, ice.sdpMid, ice.sdpMLineIndex),
    );
  }

  Future<void> dispose() async {
    await _peerConnection?.close();
    _peerConnection = null;
    await renderer.dispose();
    await _iceCandidateController.close();
  }
}
