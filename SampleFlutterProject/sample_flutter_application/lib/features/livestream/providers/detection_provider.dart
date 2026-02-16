import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/detection_result.dart';
import '../models/ws_message.dart';

class DetectionState {
  final List<DetectionResult> detections;
  final List<ResponseMessage> responseLog;

  const DetectionState({
    this.detections = const [],
    this.responseLog = const [],
  });

  DetectionState copyWith({
    List<DetectionResult>? detections,
    List<ResponseMessage>? responseLog,
  }) {
    return DetectionState(
      detections: detections ?? this.detections,
      responseLog: responseLog ?? this.responseLog,
    );
  }
}

class DetectionNotifier extends StateNotifier<DetectionState> {
  DetectionNotifier() : super(const DetectionState());

  void updateDetections(List<DetectionResult> detections) {
    state = state.copyWith(detections: detections);
  }

  void addResponse(ResponseMessage response) {
    state = state.copyWith(
      responseLog: [...state.responseLog, response],
    );
  }

  void clearDetections() {
    state = state.copyWith(detections: []);
  }
}

final detectionProvider =
    StateNotifierProvider<DetectionNotifier, DetectionState>((ref) {
  return DetectionNotifier();
});
