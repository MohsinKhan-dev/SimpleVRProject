class AuthState {
  final String? apiKey;
  final String serverUrl;
  final bool isAuthenticated;

  const AuthState({
    this.apiKey,
    this.serverUrl = '',
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    String? apiKey,
    String? serverUrl,
    bool? isAuthenticated,
  }) {
    return AuthState(
      apiKey: apiKey ?? this.apiKey,
      serverUrl: serverUrl ?? this.serverUrl,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
