import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact_hub/constants/api.dart';
import '../data/dashboard_repository.dart';
import '../../shared/shared_models.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  const backendBase = API_URL;
  // ✅ switch to real mode
  return DashboardRepository(baseUrl: backendBase, mockMode: false);
});

final dashboardEventsProvider = FutureProvider.autoDispose.family<List<EventModel>, int>((ref, limit) async {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.fetchEvents(limit: limit);
});

final dashboardCommunitiesProvider = FutureProvider.autoDispose.family<List<CommunityModel>, int>((ref, limit) async {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.fetchCommunities(limit: limit);
});

final dashboardMetricsProvider =
    FutureProvider.autoDispose.family<MetricsModel, String>((ref, userId) async {
  final repo = ref.read(dashboardRepositoryProvider);
  return repo.fetchUserMetrics(userId);
});

final dashboardRefreshProvider = StateProvider<int>((ref) => 0);
