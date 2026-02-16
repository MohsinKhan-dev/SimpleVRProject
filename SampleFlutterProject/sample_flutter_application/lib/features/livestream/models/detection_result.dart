import 'dart:ui';

class DetectionResult {
  final String label;
  final double confidence;
  final Rect bbox; // Normalized 0.0-1.0
  final List<Offset>? maskPoints; // Normalized 0.0-1.0

  const DetectionResult({
    required this.label,
    required this.confidence,
    required this.bbox,
    this.maskPoints,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    final box = json['bbox'] as List<dynamic>;
    return DetectionResult(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      bbox: Rect.fromLTRB(
        (box[0] as num).toDouble(),
        (box[1] as num).toDouble(),
        (box[2] as num).toDouble(),
        (box[3] as num).toDouble(),
      ),
      maskPoints: json['maskPoints'] != null
          ? (json['maskPoints'] as List<dynamic>)
              .map((p) => Offset(
                    (p['x'] as num).toDouble(),
                    (p['y'] as num).toDouble(),
                  ))
              .toList()
          : null,
    );
  }
}
