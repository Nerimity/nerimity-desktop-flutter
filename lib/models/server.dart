class Server {
  final String id;
  final String name;
  final String? avatar;

  final String hexColor;

  Server({
    required this.id,
    required this.name,
    required this.hexColor,
    this.avatar,
  });

  factory Server.fromJson(Map<String, dynamic> json) => Server(
    id: json['id'],
    name: json['name'],
    hexColor: json['hexColor'],
    avatar: json['avatar'],
  );
}
