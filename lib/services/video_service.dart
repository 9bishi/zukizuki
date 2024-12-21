import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/video.dart';

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
    Future<List<String>> getResourceQuality(int resourceId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/v1/video/getResourceQuality?resourceId=$resourceId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['data']['quality']);
    } else {
      throw Exception('Failed to get video quality options');
    }
  }

  Future<String> getVideoFile(int resourceId, String quality) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/v1/video/getVideoFile?resourceId=$resourceId&quality=$quality'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get video file');
    }
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