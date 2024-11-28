import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/video_api.dart';
class VideoProvider extends ChangeNotifier {
  List<dynamic> _videos = [];
  bool _isLoading = false;

  List<dynamic> get videos => _videos;
  bool get isLoading => _isLoading;

  // 获取视频列表
  Future<void> fetchVideos() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('https://api.zukizuki.org/api/v1/video/getHotVideo?page=1&pageSize=10'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _videos = data['data']['videos'];
    } else {
      throw Exception('Failed to load videos');
    }

    _isLoading = false;
    notifyListeners();
  }

class VideoProvider {
  /// Fetch the M3U8 content for a video resource
  Future<String> fetchVideoFile(int resourceId, String quality) async {
    final url = Uri.parse(
        'https://api.zukizuki.org/api/v1/video/getVideoFile?resourceId=$resourceId&quality=$quality');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final m3u8Content = response.body;
        print('Fetched M3U8 Content: $m3u8Content');
        return m3u8Content;
      } else {
        throw Exception('Failed to fetch video file');
      }
    } catch (error) {
      print('Error fetching video file: $error');
      return '';
    }
  }
}
