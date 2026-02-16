import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../livestream/providers/websocket_provider.dart';
import '../../livestream/services/websocket_service.dart';

class ConnectionStatusIndicator extends ConsumerWidget {
  const ConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionAsync = ref.watch(websocketConnectionStateProvider);

    return connectionAsync.when(
      data: (state) => _buildDot(state),
      loading: () => _buildDot(WebSocketConnectionState.disconnected),
      error: (e, _) => _buildDot(WebSocketConnectionState.disconnected),
    );
  }

  Widget _buildDot(WebSocketConnectionState state) {
    final (color, label) = switch (state) {
      WebSocketConnectionState.disconnected => (Colors.red, 'Disconnected'),
      WebSocketConnectionState.connecting => (Colors.orange, 'Connecting'),
      WebSocketConnectionState.connected => (Colors.green, 'Connected'),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
