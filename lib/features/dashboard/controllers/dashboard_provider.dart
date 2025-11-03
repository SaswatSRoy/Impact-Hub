// lib/features/dashboard/controllers/dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact_hub/constants/api.dart';
import '../data/dashboard_repository.dart';
import '../../shared/shared_models.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  // Use your current backend IP when available:
  const backendBase = API_URL;
  return DashboardRepository(baseUrl: backendBase, mockMode: true);
});

final dashboardEventsProvider = FutureProvider.autoDispose.family<List<EventModel>, int>((ref, limit) async {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.fetchEvents(limit: limit);
});

final dashboardCommunitiesProvider = FutureProvider.autoDispose.family<List<CommunityModel>, int>((ref, limit) async {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.fetchCommunities(limit: limit);
});

final dashboardMetricsProvider = FutureProvider.family.autoDispose<MetricsModel, String>((ref, userId) async {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.fetchUserMetrics(userId);
});

/// Small controller to trigger refresh manually
final dashboardRefreshProvider = StateProvider<int>((ref) => 0);
