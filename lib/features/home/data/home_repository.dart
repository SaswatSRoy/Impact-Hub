
import '../../shared/shared_models.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  final String? baseUrl;
  final bool mockMode;
  final Dio _dio;

  HomeRepository({this.baseUrl, this.mockMode = true}) : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? ''));

  Future<List<EventModel>> fetchFeaturedEvents({int limit = 6}) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return List.generate(limit, (i) => EventModel(
        id: 'f_e_$i',
        title: 'Featured Cleanup ${i+1}',
        startDate: DateTime.now().add(Duration(days: i+1)),
        description: 'Be part of our featured event',
        participants: 20 + i * 5,
      ));
    }

    // TODO: real API call
    return [];
  }

  Future<List<CommunityModel>> fetchFeaturedCommunities({int limit = 6}) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 350));
      return List.generate(limit, (i) => CommunityModel(
        id: 'f_c_$i',
        name: 'Featured Group ${i+1}',
        description: 'Featured community',
        members: 100 + i * 30,
        verified: i % 2 == 0,
      ));
    }
    
    return [];
  }
}
