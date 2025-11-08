import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_response.dart';
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

  Future<AuthResponse> login({
  required String email,
  required String password,
}) async {
  if (mockMode) {
    await Future.delayed(const Duration(seconds: 1));
    final mockAuth = AuthResponse(
      token: 'mock_jwt_token_12345',
      refreshToken: 'mock_refresh_token_67890',
      userId: 'user_001',
      email: email,
    );
    await _storage.write(key: 'access_token', value: mockAuth.token);
    await _storage.write(key: 'refresh_token', value: mockAuth.refreshToken);
    return mockAuth;
  }

  try {
    final response = await _service.login({
      'email': email,
      'password': password,
    });

    final data = response.data as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true && data['token'] != null) {
      final token = data['token'];
      final user = data['user'] ?? {};

      final auth = AuthResponse(
        token: token,
        refreshToken: '',
        userId: user['_id'] ?? '',
        email: user['email'],
      );

      await _storage.write(key: 'access_token', value: auth.token);
      return auth;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: data['message'] ?? 'Invalid credentials.',
        type: DioExceptionType.badResponse,
      );
    }
  } on DioException catch (e) {
    // capture backend 401/404 responses cleanly
    if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
      final message = e.response?.data['message'] ?? 'Invalid email or password.';
      throw DioException(
        requestOptions: e.requestOptions,
        error: message,
        response: e.response,
        type: DioExceptionType.badResponse,
      );
    }
    rethrow;
  } catch (e) {
    throw DioException(
      requestOptions: RequestOptions(path: '/auth/login'),
      error: 'An unexpected error occurred: ${e.toString()}',
    );
  }
}


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
      "location": location ?? "",
    });

    final data = response.data as Map<String, dynamic>;

    if (response.statusCode == 201 && data['success'] == true) {
      final token = data['token'];
      final user = data['user'];

      final auth = AuthResponse(
        token: token ?? '',
        refreshToken: '',
        userId: user?['_id'] ?? '',
        email: user?['email'],
      );

      await _storage.write(key: 'access_token', value: auth.token);
      return auth;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: data['message'] ?? 'Registration failed',
      );
    }
  }

  Future<void> logout() async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      await _service.logout(token);
    }
    await _storage.deleteAll();
  }

  Future<AuthResponse?> getCurrentUser() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) return null;

    final response = await _service.getCurrentUser(token);
    final data = response.data as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true) {
      return AuthResponse(
        token: token,
        refreshToken: '',
        userId: data['user']?['_id'] ?? '',
        email: data['user']?['email'],
      );
    }
    return null;
  }
}
