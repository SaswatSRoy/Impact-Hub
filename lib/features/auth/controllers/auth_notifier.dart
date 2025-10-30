import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../repository/auth_repository.dart';
import '../models/auth_response.dart';
import '../providers.dart'; // contains authRepositoryProvider

/// Represents the state of authentication throughout the app.
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

/// A [StateNotifier] responsible for handling authentication logic such as
/// login, logout, and maintaining the current [AuthState].
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState.initial());

  /// Logs the user in with [email] and [password].
  ///
  /// It calls the [AuthRepository.login] method and updates the state
  /// accordingly. Handles [DioException] gracefully with user-friendly messages.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Set loading state
    state = state.copyWith(isLoading: true, error: null);

    final repo = _ref.read(authRepositoryProvider);

    try {
      final res = await repo.login(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        auth: res,
        error: null,
      );
    } on DioException catch (e) {
      String message = 'Unable to sign in. Please try again.';

      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) message = data['message'].toString();
      } else if (e.message != null) {
        message = e.message!;
      }

      state = state.copyWith(isLoading: false, error: message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Logs out the current user and clears all stored authentication data.
  Future<void> logout() async {
    final repo = _ref.read(authRepositoryProvider);
    await repo.logout();
    state = AuthState.initial();
  }

  /// A helper function that can be expanded later to check token validity,
  /// auto-login, or silent refresh.
  Future<void> restoreSession() async {
    // TODO: Implement restore session logic (optional)
  }
}

/// Global provider exposing [AuthNotifier] and its [AuthState].
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
