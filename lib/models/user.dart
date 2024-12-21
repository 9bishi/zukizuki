class User {
  final int uid;
  final String name;
  final String email;
  final String avatar;
  final String? token;
  final String? refreshToken;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
    this.token,
    this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}
