import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_response.dart';
import '../services/auth_service.dart';

/// Repository that handles authentication-related data operations.
/// Currently runs in mock mode (simulated login) until backend integration.
class AuthRepository {
  final AuthService _service;
  final FlutterSecureStorage _storage;

  /// Set [mockMode] to true to bypass API calls during development.
  final bool mockMode;

  AuthRepository({
    AuthService? service,
    FlutterSecureStorage? storage,
    this.mockMode = true, // set to false when backend is ready
  })  : _service = service ?? AuthService(),
        _storage = storage ?? const FlutterSecureStorage();

  /// Logs the user in with provided [email] and [password].
  ///
  /// When [mockMode] is true, this simulates a success response instantly.
  /// When false, it will make a real HTTP request via [AuthService.login].
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    if (mockMode) {
      // Simulated delay and dummy data to mimic network behavior
      await Future.delayed(const Duration(seconds: 1));
      final mockAuth = AuthResponse(
        token: 'mock_jwt_token_12345',
        refreshToken: 'mock_refresh_token_67890',
        userId: 'user_001',
        email: email,
      );

      // Simulate storing token in secure storage
      await _storage.write(key: 'access_token', value: mockAuth.token);
      await _storage.write(key: 'refresh_token', value: mockAuth.refreshToken);

      return mockAuth;
    }

    // --- Real backend login code (activate later) ---
    try {
      final response = await _service.login({
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final auth = AuthResponse.fromJson(data);

        await _storage.write(key: 'access_token', value: auth.token);
        await _storage.write(key: 'refresh_token', value: auth.refreshToken);

        return auth;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Invalid response from server',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Clears all stored authentication data.
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  /// Retrieves the currently stored token (if any).
  Future<String?> getAccessToken() async {
    return _storage.read(key: 'access_token');
  }

  /// Retrieves the currently stored refresh token (if any).
  Future<String?> getRefreshToken() async {
    return _storage.read(key: 'refresh_token');
  }
}
