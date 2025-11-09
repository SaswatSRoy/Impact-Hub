import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_response.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service;
  final FlutterSecureStorage _storage;
  final bool mockMode;

  AuthRepository({
    AuthService? service,
    FlutterSecureStorage? storage,
    this.mockMode = false,
  })  : _service = service ?? AuthService(),
        _storage = storage ?? const FlutterSecureStorage();

  /// LOGIN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _service.login({
        'email': email,
        'password': password,
      });

      final data = response.data as Map<String, dynamic>;
      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['token'];
        final userData = data['user'] as Map<String, dynamic>;

        final user = AppUser.fromJson(userData);
        final auth = AuthResponse(token: token, user: user);

        await _storage.write(key: 'access_token', value: token);
        await _storage.write(key: 'user_id', value: user.id);
        return auth;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: data['message'] ?? 'Invalid credentials',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// REGISTER
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    String? location,
  }) async {
    final response = await _service.register({
      "name": name,
      "email": email,
      "password": password,
      if (location != null) "location": location,
    });

    final data = response.data as Map<String, dynamic>;

    if (response.statusCode == 201 && data['success'] == true) {
      final token = data['token'];
      final user = AppUser.fromJson(data['user']);
      final auth = AuthResponse(token: token, user: user);

      await _storage.write(key: 'access_token', value: token);
      await _storage.write(key: 'user_id', value: user.id);
      return auth;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: data['message'] ?? 'Registration failed',
        type: DioExceptionType.badResponse,
      );
    }
  }

  /// FETCH CURRENT USER (using /auth/me or /users/:id)
  Future<AuthResponse?> getCurrentUser() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) return null;

    try {
      final response = await _service.getCurrentUser(token);
      final data = response.data as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        final user = AppUser.fromJson(data['user']);
        return AuthResponse(token: token, user: user);
      }
      return null;
    } catch (e) {
      print('⚠️ Error fetching current user: $e');
      return null;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
