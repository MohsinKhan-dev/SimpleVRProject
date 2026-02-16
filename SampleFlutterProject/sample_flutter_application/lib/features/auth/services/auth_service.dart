import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../config/app_config.dart';

class AuthService {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  AuthService({
    required FlutterSecureStorage storage,
    required Dio dio,
  })  : _storage = storage,
        _dio = dio;

  Future<String?> getApiKey() async {
    return _storage.read(key: AppConfig.apiKeyStorageKey);
  }

  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: AppConfig.apiKeyStorageKey, value: apiKey);
    _configureDio(apiKey);
  }

  Future<String?> getServerUrl() async {
    return _storage.read(key: AppConfig.serverUrlStorageKey);
  }

  Future<void> saveServerUrl(String url) async {
    await _storage.write(key: AppConfig.serverUrlStorageKey, value: url);
  }

  void _configureDio(String apiKey) {
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
  }

  Future<void> loadSavedCredentials() async {
    final apiKey = await getApiKey();
    if (apiKey != null) {
      _configureDio(apiKey);
    }
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: AppConfig.apiKeyStorageKey);
    await _storage.delete(key: AppConfig.serverUrlStorageKey);
    _dio.options.headers.remove('Authorization');
  }
}
