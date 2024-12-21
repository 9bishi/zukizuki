import 'user.dart';

class Video {
  final int vid;
  final String title;
  final String cover;
  final String desc;
  final int clicks;
  final double duration;
  final DateTime createdAt;
  final User author;

  Video({
    required this.vid,
    required this.title,
    required this.cover,
    required this.desc,
    required this.clicks,
    required this.duration,
    required this.createdAt,
    required this.author,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      vid: json['vid'] ?? 0,
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      desc: json['desc'] ?? '',
      clicks: json['clicks'] ?? 0,
      duration: (json['duration'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      author: User.fromJson(json['author'] ?? {}),
    );
  }
}