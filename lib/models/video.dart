class Video {
  final int vid;
  final String title;
  final String cover;
  final String desc;
  final String createdAt;
  final bool copyright;
  final List<Map<String, dynamic>> resources;

  Video({
    required this.vid,
    required this.title,
    required this.cover,
    required this.desc,
    required this.createdAt,
    required this.copyright,
    required this.resources,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      vid: json['vid'],
      title: json['title'],
      cover: json['cover'],
      desc: json['desc'],
      createdAt: json['createdAt'],
      copyright: json['copyright'],
      resources: List<Map<String, dynamic>>.from(json['resources']),
    );
  }
}
