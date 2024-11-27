import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoApi {
  static const String baseUrl = 'https://api.zukizuki.org'; // 使用你的实际 API 地址

  // 获取视频列表
  Future<List<Map<String, dynamic>>> getVideoList() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/video/getHotVideo?page=1&pageSize=10'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']['videos']);
    } else {
      throw Exception('Failed to load video list');
    }
  }

  // 获取视频详情
  Future<Map<String, dynamic>> getVideoById(int vid) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/video/getVideoById?vid=$vid'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data']['video'];
    } else {
      throw Exception('Failed to load video details');
    }
  }

  // 获取视频资源质量
  Future<List<String>> getResourceQuality(int resourceId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/video/getResourceQuality?resourceId=$resourceId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return List<String>.from(data['data']['quality']);
    } else {
      throw Exception('Failed to load video quality');
    }
  }

  // 获取视频文件
  Future<String> getVideoFile(int resourceId, String quality) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/video/getVideoFile?resourceId=$resourceId&quality=$quality'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load video file');
    }
  }
}
