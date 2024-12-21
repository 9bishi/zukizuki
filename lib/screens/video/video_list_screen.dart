import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../../widgets/video_card.dart';
import '../../widgets/custom_banner.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<VideoProvider>();

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: CustomBanner(),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final video = videoProvider.videos[index];
                return VideoCard(video: video);
              },
              childCount: videoProvider.videos.length,
            ),
          ),
        ),
      ],
    );
  }
}