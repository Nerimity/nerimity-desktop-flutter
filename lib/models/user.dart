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
    id: json['id'] as String,
    username: (json['username'] ?? 'Unknown') as String,
    hexColor: (json['hexColor'] ?? '#fff') as String,
    avatar: json['avatar'] as String?,
  );
}
