import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../models/auth_state.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    storage: ref.watch(secureStorageProvider),
    dio: ref.watch(dioProvider),
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    await _authService.loadSavedCredentials();
    final apiKey = await _authService.getApiKey();
    final serverUrl = await _authService.getServerUrl();
    state = state.copyWith(
      apiKey: apiKey,
      serverUrl: serverUrl ?? '',
      isAuthenticated: apiKey != null && apiKey.isNotEmpty,
    );
  }

  Future<void> setCredentials({
    required String serverUrl,
    required String apiKey,
  }) async {
    await _authService.saveServerUrl(serverUrl);
    await _authService.saveApiKey(apiKey);
    state = state.copyWith(
      serverUrl: serverUrl,
      apiKey: apiKey,
      isAuthenticated: true,
    );
  }

  Future<void> clearCredentials() async {
    await _authService.clearCredentials();
    state = const AuthState();
  }
}
