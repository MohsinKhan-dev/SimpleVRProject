import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/detection_provider.dart';
import '../widgets/detection_overlay_painter.dart';
import '../widgets/notification_panel.dart';
import '../widgets/response_log.dart';
import '../widgets/video_renderer_widget.dart';

class LivestreamScreen extends ConsumerWidget {
  const LivestreamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detections = ref.watch(detectionProvider).detections;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video layer
            const VideoRendererWidget(),

            // Detection overlay
            CustomPaint(
              painter: DetectionOverlayPainter(detections: detections),
            ),

            // Bottom panels
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  ResponseLog(),
                  NotificationPanel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
