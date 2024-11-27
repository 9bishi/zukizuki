import 'package:flutter/material.dart';
import '../models/video_model.dart';

class VideoCard extends StatelessWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(video.thumbnail),
        title: Text(video.title),
        onTap: () {
          Navigator.pushNamed(context, '/video', arguments: video.id);
        },
      ),
    );
  }
}
