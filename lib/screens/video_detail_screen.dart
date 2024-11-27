import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/video_provider.dart';
import '../utils/utils.dart';
class VideoDetailScreen extends StatefulWidget {
  final int videoId;

  const VideoDetailScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      final videoDetails = await videoProvider.fetchVideoDetails(widget.videoId);

      if (videoDetails['resources'] != null && videoDetails['resources'].isNotEmpty) {
        final resourceId = videoDetails['resources'][0]['id'];
        final quality = "854x480_900k"; // 默认选择的分辨率

        // 获取视频文件的 M3U8 URL
        final m3u8Content = await videoProvider.fetchVideoFile(resourceId, quality);

        if (m3u8Content.isNotEmpty) {
          // 初始化视频播放器
          _controller = VideoPlayerController.network(m3u8Content)
            ..initialize().then((_) {
              setState(() {
                _isInitialized = true; // 更新初始化状态
                _controller.play(); // 自动播放
              });
            });
        } else {
          throw Exception('Failed to fetch video file.');
        }
      } else {
        throw Exception('No video resources available.');
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
      appBar: AppBar(
        title: const Text('Video Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<VideoProvider>(context, listen: false)
            .fetchVideoDetails(widget.videoId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final video = snapshot.data!;
            return ListView(
              children: [
                Image.network(
                  video['cover'] ?? '',
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
                ListTile(
                  title: Text(video['title']),
                  subtitle: Text(video['desc']),
                ),
                _isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const Center(
                        child: Text('Video not available or failed to load.')),
                if (_isInitialized)
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                  ),
              ],
            );
          } else {
            return const Center(child: Text('No video details available.'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
