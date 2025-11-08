import 'package:dio/dio.dart';
import '../../shared/shared_models.dart';

class HomeRepository {
  final String? baseUrl;
  final bool mockMode;
  final Dio _dio;

  HomeRepository({this.baseUrl, this.mockMode = false})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? '',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: false,
    ));
  }

  /// Fetch featured events (for home screen)
  Future<List<EventModel>> fetchFeaturedEvents({int limit = 6}) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 350));
      return List.generate(limit, (i) {
        final start = DateTime.now().add(Duration(days: i + 2));
        return EventModel(
          id: 'mock_featured_$i',
          title: 'Featured Cleanup ${i + 1}',
          startDate: start,
          endDate: start.add(const Duration(hours: 4)),
          description: 'Be part of our featured event for the community!',
          category: i.isEven ? 'Cleanup' : 'Education',
          participants: 30 + i * 5,
        );
      });
    }

    try {
      final response = await _dio.get('/events', queryParameters: {'limit': limit});
      final data = response.data;

      if (data is List) {
        return data.map((e) => EventModel.fromJson(e)).toList();
      } else if (data['events'] is List) {
        return (data['events'] as List)
            .map((e) => EventModel.fromJson(e))
            .toList();
      } else {
        print('⚠️ Unexpected featured events format: $data');
        return [];
      }
    } catch (e, st) {
      print('❌ Error fetching featured events: $e\n$st');
      return [];
    }
  }

  /// Fetch featured communities (for home screen)
  Future<List<CommunityModel>> fetchFeaturedCommunities({int limit = 6}) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 350));
      return List.generate(limit, (i) {
        return CommunityModel(
          id: 'mock_comm_$i',
          name: 'Featured Group ${i + 1}',
          description: 'A community of passionate volunteers!',
          members: 100 + i * 20,
          verified: i % 2 == 0,
        );
      });
    }

    try {
      final response =
          await _dio.get('/communities', queryParameters: {'limit': limit});
      final data = response.data;

      if (data is List) {
        return data.map((e) => CommunityModel.fromJson(e)).toList();
      } else if (data['communities'] is List) {
        return (data['communities'] as List)
            .map((e) => CommunityModel.fromJson(e))
            .toList();
      } else {
        print('⚠️ Unexpected featured community format: $data');
        return [];
      }
    } catch (e, st) {
      print('❌ Error fetching featured communities: $e\n$st');
      return [];
    }
  }
}
