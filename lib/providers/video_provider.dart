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

  // 获取视频文件内容
  Future<String> fetchVideoFile(String resourceId, String quality) async {
    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/getVideoFile?resourceId=$resourceId&quality=$quality');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch video file');
    }
  }
}
