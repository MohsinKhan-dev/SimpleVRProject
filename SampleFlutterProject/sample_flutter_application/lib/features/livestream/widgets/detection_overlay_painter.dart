import 'package:flutter/material.dart';

import '../models/detection_result.dart';

class DetectionOverlayPainter extends CustomPainter {
  final List<DetectionResult> detections;

  DetectionOverlayPainter({required this.detections});

  @override
  void paint(Canvas canvas, Size size) {
    final bboxPaint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final maskPaint = Paint()
      ..color = Colors.greenAccent.withAlpha(51)
      ..style = PaintingStyle.fill;

    for (final det in detections) {
      // Scale normalized bbox to canvas size
      final rect = Rect.fromLTRB(
        det.bbox.left * size.width,
        det.bbox.top * size.height,
        det.bbox.right * size.width,
        det.bbox.bottom * size.height,
      );
      canvas.drawRect(rect, bboxPaint);

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${det.label} ${(det.confidence * 100).toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.black54,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - 16));

      // Draw mask polygon if available
      if (det.maskPoints != null && det.maskPoints!.length >= 3) {
        final path = Path();
        final first = det.maskPoints!.first;
        path.moveTo(first.dx * size.width, first.dy * size.height);
        for (final point in det.maskPoints!.skip(1)) {
          path.lineTo(point.dx * size.width, point.dy * size.height);
        }
        path.close();
        canvas.drawPath(path, maskPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DetectionOverlayPainter oldDelegate) {
    return oldDelegate.detections != detections;
  }
}
