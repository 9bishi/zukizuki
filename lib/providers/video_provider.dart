import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/video_api.dart';

class VideoProvider with ChangeNotifier {
  bool isLoading = false;
  List<dynamic> videos = [];
  Map<String, dynamic> videoDetails = {};

  // 获取热门视频列表
  Future<void> fetchVideos() async {
    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/getHotVideo?page=1&pageSize=30');
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data['code'] == 200) {
        videos = data['data']['videos'];
      }
    } catch (error) {
      print('Error fetching videos: $error');
    }
    isLoading = false;
    notifyListeners();
  }

  // 获取视频详情
  Future<Map<String, dynamic>> fetchVideoDetails(int videoId) async {
    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/getVideoById?vid=$videoId');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data['code'] == 200) {
        videoDetails = data['data']['video'];
      }
    } catch (error) {
      print('Error fetching video details: $error');
    }
    return videoDetails;
  }

  // 获取视频文件 URL
  Future<String> fetchVideoFileUrl(int resourceId) async {
    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/getVideoFile?resourceId=$resourceId&quality=854x480_900k');
    try {
      final response = await http.get(url);
      final data = response.body;  // 返回视频文件信息
      return data;  // 返回视频文件的 URL
    } catch (error) {
      print('Error fetching video file: $error');
      return '';
    }
  }
}