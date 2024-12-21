import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class VideoService {
  Future<List<Video>> getHotVideos(int page, int pageSize) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/v1/video/getHotVideo?page=$page&pageSize=$pageSize',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data']['videos'] as List)
          .map((video) => Video.fromJson(video))
          .toList();
    } else {
      throw Exception('Failed to load hot videos');
    }
  }

  Future<List<Video>> searchVideos(
    String keywords,
    int page,
    int pageSize,
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/v1/video/searchVideo'),
      headers: ApiConfig.headers,
      body: jsonEncode({
        'keyWords': keywords,
        'page': page,
        'pageSize': pageSize,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data']['videos'] as List)
          .map((video) => Video.fromJson(video))
          .toList();
    } else {
      throw Exception('Failed to search videos');
    }
  }
}