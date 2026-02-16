import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../providers/webrtc_provider.dart';

class VideoRendererWidget extends ConsumerWidget {
  const VideoRendererWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rendererAsync = ref.watch(rtcVideoRendererProvider);

    return rendererAsync.when(
      data: (renderer) => RTCVideoView(
        renderer,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Video error: $e')),
    );
  }
}
