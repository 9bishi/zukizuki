import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/video_provider.dart';
import '../utils/utils.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl; // 视频 URL (M3U8)

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // 使用网络 URL 加载视频
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    await _videoPlayerController.initialize();

    // 配置 ChewieController 来控制视频的播放
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true, // 自动播放
      looping: true,  // 循环播放
      allowFullScreen: true, // 允许全屏播放
      allowPlaybackSpeedMenu: true, // 允许选择播放速度
    );

    setState(() {}); // 刷新页面
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoPlayerController.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // 显示加载中的动画
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("视频播放器")),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}

