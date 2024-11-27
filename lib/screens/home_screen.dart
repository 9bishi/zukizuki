import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../utils/utils.dart';
import 'video_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Videos'),
      ),
      body: videoProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : videoProvider.videos.isEmpty
              ? const Center(child: Text('No videos available'))
              : ListView.builder(
                  itemCount: videoProvider.videos.length,
                  itemBuilder: (context, index) {
                    final video = videoProvider.videos[index];
                    return ListTile(
                      title: Text(video['title'] ?? 'No Title'),
                      subtitle: Text(video['desc'] ?? 'No Description'),
                      leading: Image.network(
                        getImageUrl(video['cover'] ?? ''),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        // 点击进入视频详情页
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          videoProvider.fetchVideos();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
