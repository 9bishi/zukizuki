import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../models/video.dart';
import '../../services/video_service.dart';

class VideoDetailScreen extends StatefulWidget {
  final Video video;

  const VideoDetailScreen({super.key, required this.video});

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final VideoService _videoService = VideoService();
  String? _videoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    setState(() => _isLoading = true);
    try {
      // 获取第一个视频资源的ID
      final resourceId = widget.video.resources[0].id;
      // 首先获取视频质量列表
      final qualities = await _videoService.getResourceQuality(resourceId);
      // 选择最高质量的视频
      final quality = qualities.last;
      // 获取视频文件的M3U8地址
      final m3u8Url = await _videoService.getVideoFile(resourceId, quality);
      
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(m3u8Url));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading video: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _chewieController != null
                      ? Chewie(controller: _chewieController!)
                      : const Center(child: Text('Failed to load video')),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.video.author.avatar),
                        onBackgroundImageError: (e, s) {
                          // 头像加载失败时显示默认头像
                          setState(() {
                            widget.video.author.avatar = 'assets/default_avatar.png';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.video.author.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.video.desc,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}