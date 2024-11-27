import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/video_api.dart';

class VideoProvider with ChangeNotifier {
  bool isLoading = false;
  List<dynamic> videos = [];
  Map<String, dynamic> videoDetails = {};

  // 获取视频文件的 URL
  Future<String> fetchVideoFile(int resourceId, String quality) async {
    final url = Uri.parse(
        'https://api.zukizuki.org/api/v1/video/getVideoFile?resourceId=$resourceId&quality=$quality');

    try {
      final response = await http.get(url);

      // 检查请求是否成功
      if (response.statusCode == 200) {
        final m3u8FileContent = response.body;

        // 解析返回的 M3U8 文件（视频切片）
        return m3u8FileContent;  // 返回 M3U8 文件的内容（切片信息）
      } else {
        throw Exception('Failed to load video file');
      }
    } catch (error) {
      print('Error fetching video file: $error');
      return '';
    }
  }

  // 获取视频切片
  Future<String> fetchVideoSlice(String fileKey) async {
    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/slice/文件?key=$fileKey');

    try {
      final response = await http.get(url);

      // 检查请求是否成功
      if (response.statusCode == 200) {
        final videoSliceContent = response.body;

        // 处理视频切片内容，返回适当的结果
        return videoSliceContent;
      } else {
        throw Exception('Failed to load video slice');
      }
    } catch (error) {
      print('Error fetching video slice: $error');
      return '';
    }
  }

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
}
