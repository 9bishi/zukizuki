import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/video_provider.dart';
import '../utils/utils.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int resourceId;
  final String quality;

  const VideoPlayerScreen({
    Key? key,
    required this.resourceId,
    required this.quality,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      final m3u8Content =
          await videoProvider.fetchVideoFile(widget.resourceId, widget.quality);

      if (m3u8Content.isNotEmpty) {
        // 解析 M3U8 文件获取播放 URL
        final tsUrls = parseM3U8(m3u8Content);

        if (tsUrls.isNotEmpty) {
          final playlistUrl =
              'https://api.zukizuki.org/api/v1/video/slice/${tsUrls[0]}';

          // 初始化视频播放器
          _controller = VideoPlayerController.network(playlistUrl)
            ..initialize().then((_) {
              setState(() {
                _isInitialized = true;
                _controller.play();
              });
            });
        } else {
          throw Exception('No playable URLs found in M3U8 file.');
        }
      } else {
        throw Exception('Failed to fetch M3U8 content.');
      }
    } catch (error) {
      print('Error initializing video player: $error');
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
