// lib/features/dashboard/data/dashboard_repository.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../shared/shared_models.dart';

class DashboardRepository {
  final String? baseUrl;
  final bool mockMode;
  final Dio _dio;

  DashboardRepository({this.baseUrl, this.mockMode = true})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? ''));

  /// Example: GET /events?limit=4
  Future<List<EventModel>> fetchEvents({int limit = 4}) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 450));
      return List.generate(limit, (i) {
        return EventModel(
          id: 'event_$i',
          title: 'Community Cleanup #${i + 1}',
          startDate: DateTime.now().add(Duration(days: i + 1)),
          description: 'Help clean and green local spaces.',
          category: i % 2 == 0 ? 'Environment' : 'Health',
          participants: 15 + i * 4,
        );
      });
    }

    // Real implementation (uncomment & adapt):
    // final resp = await _dio.get('/events', queryParameters: {'limit': limit});
    // final data = resp.data as List;
    // return data.map((e) => EventModel.fromJson(e)).toList();

    // Fallback
    return [];
  }

  Future<List<CommunityModel>> fetchCommunities({int limit = 4}) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 350));
      return List.generate(limit, (i) {
        return CommunityModel(
            id: 'com_$i',
            name: 'Local Volunteers ${i + 1}',
            description: 'People working together in your area',
            members: 30 + i * 8,
            verified: i % 3 == 0);
      });
    }

    // Real implementation example:
    // final resp = await _dio.get('/communities', queryParameters: {'limit': limit});
    // return (resp.data as List).map((c) => CommunityModel.fromJson(c)).toList();

    return [];
  }

  Future<MetricsModel> fetchUserMetrics(String userId) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MetricsModel(eventsAttended: 5, communitiesJoined: 3, totalPoints: 1240, hoursVolunteered: 34.5);
    }

    // Real: GET /impact/:userId or /users/:id/metrics
    // final resp = await _dio.get('/impact/$userId');
    // return MetricsModel.fromJson(resp.data);

    return MetricsModel();
  }
}
