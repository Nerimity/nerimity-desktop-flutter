class Server {
  final String id;
  final String name;
  final String? avatar;
  final String defaultChannelId;
  final String defaultRoleId;
  final String hexColor;
  final String createdById;

  Server({
    required this.id,
    required this.name,
    required this.hexColor,
    required this.defaultChannelId,
    required this.defaultRoleId,
    required this.createdById,
    this.avatar,
  });

  factory Server.fromJson(Map<String, dynamic> json) => Server(
    id: json['id'],
    name: json['name'],
    hexColor: json['hexColor'],
    avatar: json['avatar'],
    defaultChannelId: json['defaultChannelId'],
    defaultRoleId: json['defaultRoleId'],
    createdById: json['createdById'],
  );
}
