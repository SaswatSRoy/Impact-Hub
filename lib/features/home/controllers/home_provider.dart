
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impact_hub/constants/api.dart';
import '../data/home_repository.dart';
import '../../shared/shared_models.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  const backendBase = API_URL;
  return HomeRepository(baseUrl: backendBase, mockMode: false);
});

final featuredEventsProvider = FutureProvider.autoDispose.family<List<EventModel>, int>((ref, limit) async {
  final repo = ref.read(homeRepositoryProvider);
  return repo.fetchFeaturedEvents(limit: limit);
});

final featuredCommunitiesProvider = FutureProvider.autoDispose.family<List<CommunityModel>, int>((ref, limit) async {
  final repo = ref.read(homeRepositoryProvider);
  return repo.fetchFeaturedCommunities(limit: limit);
});
