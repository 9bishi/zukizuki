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
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    final m3u8Content =
        await videoProvider.fetchVideoFile(widget.resourceId, widget.quality);

    if (m3u8Content.isNotEmpty) {
      // Set up the BetterPlayer data source
      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        'https://api.zukizuki.org/api/v1/video/getVideoFile?resourceId=${widget.resourceId}&quality=${widget.quality}',
      );

      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: false,
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );

      setState(() {});
    } else {
      print('Failed to load M3U8 content.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: _betterPlayerController != null
          ? BetterPlayer(controller: _betterPlayerController!)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }
}
