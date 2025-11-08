import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:impact_hub/constants/api.dart';

final _secureStorage = FlutterSecureStorage();

class AuthService {
  final Dio _dio;

  AuthService([Dio? dio])
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: API_URL,
              connectTimeout: const Duration(seconds: 10),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ))
              ..interceptors.add(
                InterceptorsWrapper(
                  onRequest: (options, handler) async {
                    final token = await _secureStorage.read(key: 'access_token');
                    if (token != null) {
                      options.headers['Authorization'] = 'Bearer $token';
                    }
                    return handler.next(options);
                  },
                ),
              );

  Future<Response> login(Map<String, dynamic> body) async {
    return _dio.post('/auth/login', data: body);
  }

  Future<Response> register(Map<String, dynamic> body) async {
    return _dio.post('/auth/register', data: body);
  }

  Future<Response> logout(String token) async {
    return _dio.post('/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Response> getCurrentUser(String token) async {
    return _dio.get('/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }
}
