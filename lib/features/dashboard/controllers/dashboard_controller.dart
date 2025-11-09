import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact_hub/features/auth/controllers/auth_notifier.dart';
import 'package:impact_hub/features/dashboard/controllers/dashboard_provider.dart';

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController(ref);
});

class DashboardState {
  final Set<String> joinedEvents;
  final Set<String> joinedCommunities;
  final bool isLoading;

  const DashboardState({
    this.joinedEvents = const {},
    this.joinedCommunities = const {},
    this.isLoading = false,
  });

  DashboardState copyWith({
    Set<String>? joinedEvents,
    Set<String>? joinedCommunities,
    bool? isLoading,
  }) {
    return DashboardState(
      joinedEvents: joinedEvents ?? this.joinedEvents,
      joinedCommunities: joinedCommunities ?? this.joinedCommunities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DashboardController extends StateNotifier<DashboardState> {
  final Ref _ref;

  DashboardController(this._ref) : super(const DashboardState());

  /// ✅ Join Event + Refresh Metrics
  Future<void> joinEvent(String eventId) async {
    final repo = _ref.read(dashboardRepositoryProvider);
    final auth = _ref.read(authNotifierProvider).auth;
    if (auth == null) throw Exception('User not logged in');

    if (state.joinedEvents.contains(eventId)) return;

    state = state.copyWith(isLoading: true);

    try {
      await repo.joinEvent(eventId, auth.token);

      // ✅ Locally mark as joined
      final updatedEvents = {...state.joinedEvents, eventId};
      state = state.copyWith(
        isLoading: false,
        joinedEvents: updatedEvents,
      );

      // ✅ Trigger metrics refresh (Impact Summary)
      final userId = auth.user.id;
      _ref.invalidate(dashboardMetricsProvider(userId));
      _ref.invalidate(dashboardEventsProvider(4));

    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// ✅ Join Community + Refresh Metrics
  Future<void> joinCommunity(String communityId) async {
    final repo = _ref.read(dashboardRepositoryProvider);
    final auth = _ref.read(authNotifierProvider).auth;
    if (auth == null) throw Exception('User not logged in');

    if (state.joinedCommunities.contains(communityId)) return;

    state = state.copyWith(isLoading: true);

    try {
      await repo.joinCommunity(communityId, auth.token);

      // ✅ Locally mark as joined
      final updatedCommunities = {...state.joinedCommunities, communityId};
      state = state.copyWith(
        isLoading: false,
        joinedCommunities: updatedCommunities,
      );

      // ✅ Trigger metrics refresh
      final userId = auth.user.id;
      _ref.invalidate(dashboardMetricsProvider(userId));
      _ref.invalidate(dashboardCommunitiesProvider(20));

    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
