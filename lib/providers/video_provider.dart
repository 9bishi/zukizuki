import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/video_api.dart';

class VideoProvider with ChangeNotifier {
  bool _isLoading = false;
  List<dynamic> _videos = [];

  bool get isLoading => _isLoading;
  List<dynamic> get videos => _videos;

  /// 获取视频列表
  Future<void> fetchVideos() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/getHotVideo?page=1&pageSize=10');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _videos = data['data']['videos'];
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (error) {
      print('Error fetching videos: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取视频文件
  Future<String> fetchVideoFile(int resourceId, String quality) async {
    final url = Uri.parse(
        'https://api.zukizuki.org/api/v1/video/getVideoFile?resourceId=$resourceId&quality=$quality');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body; // 返回 M3U8 文件内容
      } else {
        throw Exception('Failed to load video file');
      }
    } catch (error) {
      print('Error fetching video file: $error');
      return '';
    }
  }

  /// 解析 M3U8 文件，提取视频切片 URL
  List<String> parseM3U8(String m3u8Content) {
    final lines = m3u8Content.split('\n');
    return lines.where((line) => line.endsWith('.ts')).toList();
  }
}
