
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import '../providers.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final AuthResponse? auth;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.auth,
  });

  bool get isAuthenticated => auth != null && auth!.token.isNotEmpty;

  AuthState copyWith({
    bool? isLoading,
    String? error,
    AuthResponse? auth,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      auth: auth ?? this.auth,
    );
  }

  factory AuthState.initial() => const AuthState();
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState.initial());

  // ================================
  // LOGIN
  // ================================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final repo = _ref.read(authRepositoryProvider);

    try {
      final res = await repo.login(email: email, password: password);
      state = state.copyWith(isLoading: false, auth: res);
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data['message'] ?? e.message ?? 'Login failed',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ================================
  // REGISTER
  // ================================
  Future<void> register({
  required String name,
  required String email,
  required String password,
  String? location,
}) async {
  state = state.copyWith(isLoading: true, error: null);
  final repo = _ref.read(authRepositoryProvider);

  try {
    final res = await repo.register(
      name: name,
      email: email,
      password: password,
      location: location,
    );
    state = state.copyWith(isLoading: false, auth: res, error: null);
  } on DioException catch (e) {
    String message = 'Registration failed. Please try again.';
    if (e.response?.data is Map && e.response!.data['message'] != null) {
      message = e.response!.data['message'].toString();
    }
    state = state.copyWith(isLoading: false, error: message);
  } catch (e) {
    state = state.copyWith(isLoading: false, error: e.toString());
  }
}


  Future<void> logout() async {
    final repo = _ref.read(authRepositoryProvider);
    await repo.logout();
    state = AuthState.initial();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
