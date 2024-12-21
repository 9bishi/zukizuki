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
      vid: json['vid'],
      title: json['title'],
      cover: json['cover'],
      desc: json['desc'],
      clicks: json['clicks'],
      duration: json['duration'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      author: User.fromJson(json['author']),
    );
  }
}
