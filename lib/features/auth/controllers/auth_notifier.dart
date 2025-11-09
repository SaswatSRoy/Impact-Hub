import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import '../repository/auth_repository.dart';
import '../providers.dart';

/// Holds the current authentication state.
class AuthState {
  final bool isLoading;
  final String? error;
  final AuthResponse? auth;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.auth,
  });

  bool get isAuthenticated => auth!.token.isNotEmpty == true;

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

/// 🔹 Notifier that manages authentication logic.
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState.initial()) {
    // 🟢 Automatically restore session on app start
    restoreSession();
  }

  // ===================================================
  // 🟢 LOGIN
  // ===================================================
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

  // ===================================================
  // 🟢 REGISTER
  // ===================================================
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
      state = state.copyWith(isLoading: false, auth: res);
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ??
          e.message ??
          'Registration failed. Please try again.';
      state = state.copyWith(isLoading: false, error: message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ===================================================
  // 🟢 FETCH CURRENT USER
  // ===================================================
  Future<void> fetchCurrentUser() async {
    final repo = _ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true, error: null);

    try {
      final res = await repo.getCurrentUser();
      if (res != null) {
        state = state.copyWith(isLoading: false, auth: res);
      } else {
        state = AuthState.initial();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to fetch user');
    }
  }

  // ===================================================
  // 🔴 LOGOUT
  // ===================================================
  Future<void> logout() async {
    final repo = _ref.read(authRepositoryProvider);
    await repo.logout();
    state = AuthState.initial();
  }

  // ===================================================
  // 🟢 RESTORE SESSION (auto-login on app start)
  // ===================================================
  Future<void> restoreSession() async {
    final repo = _ref.read(authRepositoryProvider);
    try {
      final res = await repo.getCurrentUser();
      if (res != null) {
        state = state.copyWith(auth: res);
        
      } else {
        print('⚠️ No session found, user is logged out');
      }
    } catch (e) {
      print('❌ Failed to restore session: $e');
    }
  }
}

/// Global provider for authentication
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
