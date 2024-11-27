import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../utils/utils.dart';
import 'video_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 在页面初始化时获取视频列表
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Video List')),
      body: videoProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : videoProvider.videos.isEmpty
              ? Center(child: Text('No videos found'))
              : ListView.builder(
                  itemCount: videoProvider.videos.length,
                  itemBuilder: (context, index) {
                    final video = videoProvider.videos[index];
                    return ListTile(
                      title: Text(video['title']),
                      subtitle: Text(video['desc']),
                      leading: Image.network(video['cover']),
                      onTap: () {
                        // Navigate to video detail screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoDetailScreen(videoId: video['vid']),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class VideoDetailScreen extends StatelessWidget {
  final int videoId;

  VideoDetailScreen({required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Details')),
      body: Center(
        child: Text('Video ID: $videoId'),
      ),
    );
  }
}
