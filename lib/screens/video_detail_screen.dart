import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/video_provider.dart';
import '../utils/utils.dart';

class VideoDetailScreen extends StatefulWidget {
  final int videoId;

  const VideoDetailScreen({super.key, required this.videoId});

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    // 获取视频资源
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    final videoDetails = await videoProvider.fetchVideoDetails(widget.videoId);
    final resourceId = videoDetails['resources'][0]['id'];
    final quality = "854x480_900k";  // 你可以根据需要更改视频质量

    // 获取视频文件 M3U8 内容
    final m3u8Content = await videoProvider.fetchVideoFile(resourceId, quality);

    // 使用 M3U8 内容创建视频播放器控制器
    _controller = VideoPlayerController.network(m3u8Content)
      ..initialize().then((_) {
        setState(() {});
      });
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
                Image.network(video['cover'] ?? ''),
                ListTile(
                  title: Text(video['title']),
                  subtitle: Text(video['desc']),
                ),
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const Center(child: CircularProgressIndicator()),
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
    super.dispose();
    _controller.dispose();
  }
}
