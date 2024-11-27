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
    // 获取视频的资源和质量信息
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    // 获取视频资源的 URL（假设这里是从API获取的视频文件路径）
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    final videoDetails = await videoProvider.fetchVideoDetails(widget.videoId);
    final videoFileUrl = await videoProvider.fetchVideoFileUrl(videoDetails['resources'][0]['id']);

    // 创建视频播放器控制器
    _controller = VideoPlayerController.network(videoFileUrl)
      ..initialize().then((_) {
        // 确保视频在初始化后可以播放
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

            // 视频初始化完成后显示视频播放器
            return ListView(
              children: [
                Image.network(getImageUrl(video['cover'] ?? '')),
                ListTile(
                  title: Text(video['title']),
                  subtitle: Text(video['desc']),
                ),
                ListTile(
                  title: Text('Duration: ${video['duration']}'),
                  subtitle: Text('Created At: ${video['createdAt']}'),
                ),
                const ListTile(
                  title: Text('Tags: '),
                  subtitle: Text('Video Tags'),
                ),
                ListTile(
                  title: Text('Resources'),
                  subtitle: Text(video['resources'].toString()),
                ),
                // 视频播放器部分
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const Center(child: CircularProgressIndicator()),
                // 播放控制按钮
                _controller.value.isInitialized
                    ? IconButton(
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
                      )
                    : const SizedBox.shrink(),
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
    _controller.dispose(); // 释放视频播放器资源
  }
}
