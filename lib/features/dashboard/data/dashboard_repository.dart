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

  /// ✅ Join Event endpoint with proper error handling
Future<void> joinEvent(String eventId, String token) async {
  try {
    final response = await _dio.post(
      '/events/$eventId/join',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      print('✅ Successfully joined event $eventId');
    } else {
      // Catch backend message if provided
      final msg = response.data['message'] ?? 'Failed to join event.';
      throw Exception(msg);
    }

  } on DioException catch (e, st) {
    final code = e.response?.statusCode ?? 0;
    final msg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';

    // ✅ Handle common backend scenarios gracefully
    if (code == 409) {
      // Already joined
      throw Exception('You have already joined this event.');
    } else if (code == 401) {
      // Unauthorized
      throw Exception('Session expired. Please log in again.');
    } else if (code == 404) {
      // Event not found
      throw Exception('Event not found or has been removed.');
    } else {
      print('❌ Error joining event ($code): $msg\n$st');
      throw Exception(msg);
    }
  } catch (e, st) {
    print('⚠️ Unexpected error while joining event: $e\n$st');
    throw Exception('Something went wrong. Please try again later.');
  }
}

Future<void> joinCommunity(String communityId, String token) async {
  try {
    final response = await _dio.post(
      '/communities/$communityId/join',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      print('✅ Successfully joined community $communityId');
    } else {
      final msg = response.data['message'] ?? 'Failed to join community.';
      throw Exception(msg);
    }

  } on DioException catch (e, st) {
    final code = e.response?.statusCode ?? 0;
    final msg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';

    if (code == 409) {
      throw Exception('You have already joined this community.');
    } else if (code == 401) {
      throw Exception('Please log in again.');
    } else if (code == 404) {
      throw Exception('Community not found.');
    } else {
      
      throw Exception(msg);
    }
  }
}

}