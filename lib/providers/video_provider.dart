import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/video_api.dart';

class VideoProvider with ChangeNotifier {
  /// 获取视频文件（M3U8 格式）
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

  /// 获取视频切片的完整 URL
  String getSliceUrl(String fileName) {
    final baseUrl = 'https://api.zukizuki.org/api/v1/video/slice';
    return '$baseUrl/$fileName';
  }

  /// 示例方法：获取第一个视频切片 URL
  Future<String?> fetchFirstSliceUrl(int resourceId, String quality) async {
    try {
      final m3u8Content = await fetchVideoFile(resourceId, quality);
      final sliceFiles = parseM3U8(m3u8Content);

      if (sliceFiles.isNotEmpty) {
        return getSliceUrl(sliceFiles.first); // 返回第一个切片的完整 URL
      } else {
        throw Exception('No slice files found in M3U8 content.');
      }
    } catch (error) {
      print('Error fetching first slice URL: $error');
      return null;
    }
  }
}
