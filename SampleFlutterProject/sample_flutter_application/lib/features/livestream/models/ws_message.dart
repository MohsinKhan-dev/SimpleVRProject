import 'dart:convert';

import 'detection_result.dart';

enum WsMessageType { sdp, ice, detections, notification, response }

sealed class WsMessage {
  const WsMessage();

  factory WsMessage.fromJson(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final type = json['type'] as String;

    return switch (type) {
      'sdp' => SdpMessage(
          sdpType: json['sdpType'] as String,
          sdp: json['sdp'] as String,
        ),
      'ice' => IceMessage(
          candidate: json['candidate'] as String,
          sdpMid: json['sdpMid'] as String?,
          sdpMLineIndex: json['sdpMLineIndex'] as int?,
        ),
      'detections' => DetectionsMessage(
          detections: (json['detections'] as List<dynamic>)
              .map((d) =>
                  DetectionResult.fromJson(d as Map<String, dynamic>))
              .toList(),
        ),
      'notification' => NotificationMessage(
          text: json['text'] as String,
        ),
      'response' => ResponseMessage(
          answer: json['answer'] as String,
          timestamp: json['timestamp'] as String,
        ),
      _ => throw FormatException('Unknown message type: $type'),
    };
  }

  Map<String, dynamic> toJson();

  String encode() => jsonEncode(toJson());
}

class SdpMessage extends WsMessage {
  final String sdpType;
  final String sdp;

  const SdpMessage({required this.sdpType, required this.sdp});

  @override
  Map<String, dynamic> toJson() => {
        'type': 'sdp',
        'sdpType': sdpType,
        'sdp': sdp,
      };
}

class IceMessage extends WsMessage {
  final String candidate;
  final String? sdpMid;
  final int? sdpMLineIndex;

  const IceMessage({
    required this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
  });

  @override
  Map<String, dynamic> toJson() => {
        'type': 'ice',
        'candidate': candidate,
        'sdpMid': sdpMid,
        'sdpMLineIndex': sdpMLineIndex,
      };
}

class DetectionsMessage extends WsMessage {
  final List<DetectionResult> detections;

  const DetectionsMessage({required this.detections});

  @override
  Map<String, dynamic> toJson() => {
        'type': 'detections',
        'detections': detections
            .map((d) => {
                  'label': d.label,
                  'confidence': d.confidence,
                  'bbox': [d.bbox.left, d.bbox.top, d.bbox.right, d.bbox.bottom],
                })
            .toList(),
      };
}

class NotificationMessage extends WsMessage {
  final String text;

  const NotificationMessage({required this.text});

  @override
  Map<String, dynamic> toJson() => {
        'type': 'notification',
        'text': text,
      };
}

class ResponseMessage extends WsMessage {
  final String answer;
  final String timestamp;

  const ResponseMessage({required this.answer, required this.timestamp});

  @override
  Map<String, dynamic> toJson() => {
        'type': 'response',
        'answer': answer,
        'timestamp': timestamp,
      };
}
