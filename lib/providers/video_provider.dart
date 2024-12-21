import 'package:flutter/material.dart';
import '../services/video_service.dart';
import '../models/video.dart';

class VideoProvider extends ChangeNotifier {
  final _videoService = VideoService();
  List<Video> _videos = [];
  bool _isLoading = false;
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _pageSize = 20;

  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadHotVideos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _videos = await _videoService.getHotVideos(_currentPage, _pageSize);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchVideos(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    try {
      _videos = await _videoService.searchVideos(query, _currentPage, _pageSize);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetSearch() {
    _searchQuery = '';
    _currentPage = 1;
    loadHotVideos();
  }
}