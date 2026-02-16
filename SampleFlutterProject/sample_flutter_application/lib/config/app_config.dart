class AppConfig {
  static const String defaultServerUrl = 'ws://localhost:8080';

  static const Map<String, String> stunServer = {
    'url': 'stun:stun.l.google.com:19302',
  };

  // Add TURN server credentials when available
  static const Map<String, String> turnServer = {
    'url': 'turn:your-turn-server.com:3478',
    'username': '',
    'credential': '',
  };

  static Map<String, dynamic> get rtcConfiguration => {
        'iceServers': [
          stunServer,
          if (turnServer['username']!.isNotEmpty) turnServer,
        ],
      };

  static const String apiKeyStorageKey = 'api_key';
  static const String serverUrlStorageKey = 'server_url';
}
