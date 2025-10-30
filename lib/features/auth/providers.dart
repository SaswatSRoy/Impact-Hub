import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact_hub/features/auth/repository/auth_repository.dart';

/// Provides a singleton [AuthRepository] for dependency injection.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
