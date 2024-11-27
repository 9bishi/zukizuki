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
  late String m3u8Content;

  @override
  void initState() {
    super.initState();
    _loadM3U8();
  }

  // 模拟获取M3U8内容，这部分可以根据实际API返回调整
  Future<void> _loadM3U8() async {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    final resourceId = '123'; // 资源ID需要根据实际情况替换
    final quality = '854x480_900k'; // 分辨率信息

    final m3u8Data = await videoProvider.fetchVideoFile(resourceId, quality);
    setState(() {
      m3u8Content = m3u8Data;
    });
  }

  // 解析M3U8文件并返回视频切片URL
  List<String> parseM3U8(String m3u8Content) {
    final lines = m3u8Content.split('\n');
    return lines.where((line) => line.endsWith('.ts')).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (m3u8Content.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tsUrls = parseM3U8(m3u8Content);

    return Scaffold(
      appBar: AppBar(title: const Text('视频播放')),
      body: ListView.builder(
        itemCount: tsUrls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tsUrls[index]),
          );
        },
      ),
    );
  }
}
