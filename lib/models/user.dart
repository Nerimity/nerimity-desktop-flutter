class User {
  final String id;
  final String username;
  final String? avatar;
  final String hexColor;

  User({
    required this.id,
    required this.username,
    required this.hexColor,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
    hexColor: json['hexColor'],
    avatar: json['avatar'],
  );
}
