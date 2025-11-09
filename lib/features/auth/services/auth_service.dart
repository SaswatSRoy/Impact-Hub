import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:impact_hub/constants/api.dart';

/// A low-level HTTP service for authentication operations.
///
/// This layer only handles raw API communication.
/// The higher-level [AuthRepository] wraps these calls and parses data.
class AuthService {
  final Dio _dio;
  static const _secureStorage = FlutterSecureStorage();

  AuthService([Dio? dio])
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: API_URL,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            )..interceptors.add(
                InterceptorsWrapper(
                  onRequest: (options, handler) async {
                    final token = await _secureStorage.read(key: 'access_token');
                    if (token != null) {
                      options.headers['Authorization'] = 'Bearer $token';
                    }
                    return handler.next(options);
                  },
                  onError: (error, handler) {
                    // Optional: handle global 401 or 403 here
                    if (error.response?.statusCode == 401) {
                      print('⚠️ Unauthorized: Token expired or invalid');
                    }
                    return handler.next(error);
                  },
                ),
              );

  /// 🔹 Login endpoint
  Future<Response> login(Map<String, dynamic> body) async {
    return _dio.post('/auth/login', data: body);
  }

  /// 🔹 Register endpoint
  Future<Response> register(Map<String, dynamic> body) async {
    return _dio.post('/auth/register', data: body);
  }

  /// 🔹 Logout endpoint
  Future<Response> logout(String token) async {
    return _dio.post(
      '/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// 🔹 Fetch current logged-in user (for `/auth/me` or `/users/:id`)
  ///
  /// If your backend uses `/users/:id`, you can call:
  /// ```dart
  /// _service.get('/users/$id', token: token);
  /// ```
  Future<Response> getCurrentUser(String token) async {
    return _dio.get(
      '/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// 🧩 Generic GET request with optional token header
  Future<Response> get(String path, {String? token}) async {
    return _dio.get(
      path,
      options: token != null
          ? Options(headers: {'Authorization': 'Bearer $token'})
          : null,
    );
  }
}
