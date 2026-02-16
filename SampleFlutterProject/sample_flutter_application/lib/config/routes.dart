import 'package:flutter/material.dart';

import '../features/connection/screens/connection_screen.dart';
import '../features/livestream/screens/livestream_screen.dart';

class Routes {
  static const String connection = '/';
  static const String livestream = '/livestream';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case connection:
        return MaterialPageRoute(
          builder: (_) => const ConnectionScreen(),
        );
      case livestream:
        return MaterialPageRoute(
          builder: (_) => const LivestreamScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const ConnectionScreen(),
        );
    }
  }
}
