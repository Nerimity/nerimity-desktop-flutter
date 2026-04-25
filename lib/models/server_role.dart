class ServerRole {
  final String id;
  final String serverId;
  final String name;
  final int order;

  ServerRole({
    required this.id,
    required this.serverId,
    required this.name,
    required this.order,
  });

  factory ServerRole.fromJson(Map<String, dynamic> json) => ServerRole(
    id: json['id'] as String,
    serverId: json['serverId'] as String,
    name: json['name'] as String,
    order: json['order'] as int,
  );
}
