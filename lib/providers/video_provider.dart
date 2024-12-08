import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/video_api.dart';

class VideoProvider with ChangeNotifier {
  bool isLoading = false;
  List<dynamic> videos = [];
  Map<String, dynamic> videoDetails = {};

  // 获取视频文件
  Future<String> fetchVideoFile(int resourceId, String quality) async {
    final url = Uri.parse(
        'https://api.zukizuki.org/api/v1/video/getVideoFile?resourceId=$resourceId&quality=$quality');

    debugPrint("Fetching video file with resourceId: $resourceId, quality: $quality");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final m3u8FileContent = response.body;
        debugPrint("M3U8 file content fetched successfully");
        return m3u8FileContent;
      } else {
        debugPrint("Failed to fetch video file. Status code: ${response.statusCode}");
        throw Exception('Failed to load video file');
      }
    } catch (error) {
      debugPrint("Error fetching video file: $error");
      return '';
    }
  }

  // 获取视频切片
  Future<String> fetchVideoSlice(String fileKey) async {
    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/slice/$fileKey');

    debugPrint("Fetching video slice with key: $fileKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        debugPrint("Video slice fetched successfully");
        return response.body;
      } else {
        debugPrint("Failed to fetch video slice. Status code: ${response.statusCode}");
        throw Exception('Failed to load video slice');
      }
    } catch (error) {
      debugPrint("Error fetching video slice: $error");
      return '';
    }
  }

  // 获取视频列表
  Future<void> fetchVideos() async {
    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/getHotVideo?page=1&pageSize=30');
    debugPrint("Fetching videos from $url");

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['code'] == 200) {
        videos = data['data']['videos'];
        debugPrint("Videos fetched successfully: ${videos.length} videos found");
      } else {
        debugPrint("Failed to fetch videos. API response: ${data['msg']}");
      }
    } catch (error) {
      debugPrint("Error fetching videos: $error");
    }

    isLoading = false;
    notifyListeners();
  }

  // 获取视频详情
  Future<Map<String, dynamic>> fetchVideoDetails(int videoId) async {
    final url = Uri.parse('https://api.zukizuki.org/api/v1/video/getVideoById?vid=$videoId');
    debugPrint("Fetching video details for videoId: $videoId");

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['code'] == 200) {
        videoDetails = data['data']['video'];
        debugPrint("Video details fetched successfully: ${videoDetails['title']}");
      } else {
        debugPrint("Failed to fetch video details. API response: ${data['msg']}");
      }
    } catch (error) {
      debugPrint("Error fetching video details: $error");
    }

    return videoDetails;
  }
}

