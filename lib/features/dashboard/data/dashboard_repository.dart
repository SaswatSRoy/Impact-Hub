import 'package:dio/dio.dart';
import '../../shared/shared_models.dart';

class DashboardRepository {
  final String? baseUrl;
  final bool mockMode;
  final Dio _dio;

  DashboardRepository({this.baseUrl, this.mockMode = false})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? ''));

  /// ✅ Fetch events from /events
  Future<List<EventModel>> fetchEvents({int limit = 4}) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 450));
      return List.generate(
        limit,
        (i) => EventModel(
          id: 'mock_$i',
          title: 'Mock Event $i',
          startDate: DateTime.now().add(Duration(days: i)),
          description: 'Mock Description',
          participants: 10 + i,
        ),
      );
    }

    try {
      final response = await _dio.get('/events', queryParameters: {'limit': limit});
      final data = response.data;

      if (data is Map && data['data'] is List) {
        final events = data['data'] as List;
        return events.map((e) => EventModel.fromJson(e)).toList();
      } else if (data is List) {
        return data.map((e) => EventModel.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }
    } on DioException catch (e, st) {
      print('❌ Error fetching events: ${e.message}\n$st');
      rethrow;
    }
  }

  /// ✅ Fetch communities from /communities
  Future<List<CommunityModel>> fetchCommunities({int limit = 4}) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 350));
      return List.generate(
        limit,
        (i) => CommunityModel(
          id: 'mock_c_$i',
          name: 'Mock Community $i',
          description: 'Mock Description',
          members: 20 + i,
          verified: true,
        ),
      );
    }

    try {
      final response = await _dio.get('/communities', queryParameters: {'limit': limit});
      final data = response.data;

      if (data is Map && data['data'] is List) {
        final communities = data['data'] as List;
        return communities.map((c) => CommunityModel.fromJson(c)).toList();
      } else if (data is List) {
        return data.map((c) => CommunityModel.fromJson(c)).toList();
      } else {
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }
    } on DioException catch (e, st) {
      print('❌ Error fetching communities: ${e.message}\n$st');
      rethrow;
    }
  }

  /// ✅ Fetch user metrics (optional route)
  Future<MetricsModel> fetchUserMetrics(String userId) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return const MetricsModel(
        eventsAttended: 4,
        communitiesJoined: 2,
        totalPoints: 250,
        hoursVolunteered: 10.5,
      );
    }

    try {
      final response = await _dio.get('/users/$userId/impact');
      return MetricsModel.fromJson(response.data);
    } catch (e, st) {
      print('⚠️ Error fetching metrics, fallback used: $e\n$st');
      return const MetricsModel();
    }
  }

  /// ✅ Join Event endpoint
  Future<void> joinEvent(String eventId, String token) async {
    try {
      final response = await _dio.post(
        '/events/$eventId/join',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        print('✅ Successfully joined event $eventId');
      } else {
        throw Exception(response.data['message'] ?? 'Join failed');
      }
    } on DioException catch (e, st) {
      print('❌ Error joining event: ${e.message}\n$st');
      throw Exception(e.response?.data?['message'] ?? 'Join event failed');
    }
  }
}
