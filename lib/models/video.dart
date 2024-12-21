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
  final List<Resource> resources;

  Video({
    required this.vid,
    required this.title,
    required this.cover,
    required this.desc,
    required this.clicks,
    required this.duration,
    required this.createdAt,
    required this.author,
    required this.resources,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      vid: json['vid'],
      title: json['title'],
      cover: json['cover'],
      desc: json['desc'] ?? '',
      clicks: json['clicks'],
      duration: (json['duration'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      author: User.fromJson(json['author']),
      resources: (json['resources'] as List?)
          ?.map((r) => Resource.fromJson(r))
          .toList() ?? [],
    );
  }
}

class Resource {
  final int id;
  final String title;
  final double duration;
  final int status;

  Resource({
    required this.id,
    required this.title,
    required this.duration,
    required this.status,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      title: json['title'] ?? '',
      duration: (json['duration'] ?? 0.0).toDouble(),
      status: json['status'] ?? 0,
    );
  }
}