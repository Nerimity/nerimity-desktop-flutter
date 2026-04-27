class ServerMember {
  final String id;
  final String userId;
  final String serverId;
  final String? nickname;
  final Set<String> roleIds;

  ServerMember({
    required this.id,
    required this.userId,
    required this.serverId,
    required this.roleIds,
    this.nickname,
  });

  factory ServerMember.fromJson(Map<String, dynamic> json) => ServerMember(
    id: json['id'] as String,
    userId: json['userId'] as String,
    serverId: json['serverId'] as String,
    roleIds: Set<String>.from(json['roleIds'] as List),
    nickname: json['nickname'] as String?,
  );
}
