import 'package:nerimity_desktop_flutter/models/user.dart';

class RawServerMember {
  final String id;
  final String userId;
  final String serverId;
  final User user;
  final Set<String> roleIds;

  RawServerMember({
    required this.id,
    required this.userId,
    required this.serverId,
    required this.user,
    required this.roleIds,
  });

  factory RawServerMember.fromJson(Map<String, dynamic> json) =>
      RawServerMember(
        id: json['id'] as String,
        userId: json['userId'] as String,
        serverId: json['serverId'] as String,
        user: User.fromJson(json['user']),
        roleIds: Set<String>.from(json['roleIds'] as List),
      );
}
