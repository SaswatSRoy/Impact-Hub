import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:impact_hub/constants/api.dart';

final _secureStorage = FlutterSecureStorage();

class AuthService {
  final Dio _dio;

  AuthService([Dio? dio])
      : _dio = dio ??
            Dio(BaseOptions(baseUrl: API_URL, connectTimeout: Duration(milliseconds: 10000)))
              ..interceptors.add(InterceptorsWrapper(
                onRequest: (options, handler) async {
                  // Attach token if available
                  final token = await _secureStorage.read(key: 'access_token');
                  if (token != null) {
                    options.headers['Authorization'] = 'Bearer $token';
                  }
                  return handler.next(options);
                },
                onError: (error, handler) async {
                  // Simple refresh token flow skeleton (expand for production)
                  if (error.response?.statusCode == 401) {
                    // Try refresh token once
                    final refreshToken = await _secureStorage.read(key: 'refresh_token');
                    if (refreshToken != null && !error.requestOptions.extra.containsKey('retried')) {
                      try {
                        final resp = await Dio(BaseOptions(baseUrl: API_URL)).post(
                          '/auth/refresh',
                          data: {'refreshToken': refreshToken},
                        );
                        final newToken = resp.data['token'] as String?;
                        final newRefresh = resp.data['refreshToken'] as String?;
                        if (newToken != null) {
                          await _secureStorage.write(key: 'access_token', value: newToken);
                          if (newRefresh != null) {
                            await _secureStorage.write(key: 'refresh_token', value: newRefresh);
                          }
                          // repeat original request with updated token
                          final opts = Options(
                            method: error.requestOptions.method,
                            headers: {
                              ...error.requestOptions.headers,
                              'Authorization': 'Bearer $newToken'
                            },
                          );
                          final cloneReq = await Dio(BaseOptions(baseUrl: API_URL))
                              .request(error.requestOptions.path, options: opts, data: error.requestOptions.data, queryParameters: error.requestOptions.queryParameters);
                          return handler.resolve(cloneReq);
                        }
                      } catch (_) {
                        // refresh failed
                      }
                    }
                  }
                  return handler.next(error);
                },
              ));

  Dio get client => _dio;

  
  Future<Response> login(Map<String, dynamic> body) async {
    return _dio.post('/auth/login', data: body);
  }


}
