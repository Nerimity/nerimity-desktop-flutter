import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/models/server_member.dart';
import 'package:nerimity_desktop_flutter/models/server_role.dart';
import 'package:nerimity_desktop_flutter/stores/server_store.dart';
import 'package:nerimity_desktop_flutter/stores/user_presence_store.dart';
import 'package:nerimity_desktop_flutter/stores/user_store.dart';
import 'package:nerimity_desktop_flutter/theme/app_theme.dart';
import 'package:nerimity_desktop_flutter/views/avatar.dart';
import 'package:nerimity_desktop_flutter/views/cdn_icon.dart';
import 'package:signals/signals_flutter.dart';

final _offlineRole = ServerRole(
  id: 'offline',
  serverId: '',
  name: '',
  order: 0,
  hideRole: false,
);
List<({ServerRole role, List<ServerMember> members})> _buildCategorizedMembers(
  List<ServerRole> roles,
  Iterable<ServerMember> serverMembers,
) {
  final defaultRole = serverStore.currentServerDefaultRole();
  final sortedRoles = [...roles.where((r) => !r.hideRole)];
  sortedRoles.sort((a, b) => b.order.compareTo(a.order));

  final roleOrder = <String, int>{
    for (var i = 0; i < sortedRoles.length; i++) sortedRoles[i].id: i,
  };

  final buckets = <String, List<ServerMember>>{};
  final offlineMembers = <ServerMember>[];

  for (final member in serverMembers) {
    final offline = !userPresenceStore.presences.containsKey(member.userId);
    if (offline) {
      offlineMembers.add(member);
      continue;
    }

    String? topRoleId;
    int? bestIndex;
    for (final roleId in member.roleIds) {
      final idx = roleOrder[roleId];
      if (idx == null) continue;
      if (bestIndex == null || idx < bestIndex) {
        bestIndex = idx;
        topRoleId = roleId;
      }
    }

    if (topRoleId == null) {
      if (defaultRole != null) {
        (buckets[defaultRole.id] ??= []).add(member);
      }
      continue;
    }
    (buckets[topRoleId] ??= []).add(member);
  }

  return [
    for (final role in sortedRoles)
      if (buckets.containsKey(role.id))
        (role: role, members: buckets[role.id]!),
    if (offlineMembers.isNotEmpty)
      (role: _offlineRole, members: offlineMembers),
  ];
}

class ServerMemberList extends StatefulWidget {
  const ServerMemberList({super.key});
  @override
  State<ServerMemberList> createState() => _ServerMemberListState();
}

class _ServerMemberListState extends State<ServerMemberList> with SignalsMixin {
  late final _categorizedServerMembers = createComputed(() {
    final roles = serverStore.currentServerRoles.value?.values.toList();
    final serverMembers = serverStore.currentServerMembers.value?.values;
    if (roles == null || serverMembers == null) return [];

    return _buildCategorizedMembers(roles, serverMembers);
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        children: [
          Expanded(
            child: Watch((context) {
              final items = [
                for (final category in _categorizedServerMembers.value) ...[
                  RoleHeader(
                    key: ValueKey('role_${category.role.id}'),
                    id: category.role.id,
                    count: category.members.length,
                  ),
                  for (final member in category.members)
                    MemberTile(
                      key: ValueKey('member_${member.userId}'),
                      id: member.userId,
                    ),
                ],
              ];
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) => items[i],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class RoleHeader extends StatelessWidget {
  final String id;
  final int count;
  const RoleHeader({super.key, required this.id, required this.count});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final offlineRole = id == "offline";
      final role = serverStore.currentServerRoles.value?[id];
      if (!offlineRole && role == null) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(bottom: 2.0, right: 8.0),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              hoverColor: AppTheme.itemHoveredBg,
              borderRadius: BorderRadius.circular(8),
              onTap: () {},
              highlightColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    if (role?.icon != null) CdnIcon(serverRole: role, size: 12),

                    Transform.translate(
                      offset: Offset(0, -1),
                      child: Text(
                        "${role?.name ?? "Offline"} ($count)",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class MemberTile extends StatelessWidget {
  final String id;
  const MemberTile({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final member = serverStore.currentServerMembers.value?[id];
      final user = userStore.users[id];
      if (member == null) return const SizedBox.shrink();
      if (user == null) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(bottom: 2.0, right: 8.0),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              hoverColor: AppTheme.itemHoveredBg,
              borderRadius: BorderRadius.circular(8),
              onTap: () {},
              highlightColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Avatar(user: user, size: AvatarSize.md),
                    Text(user.username, style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
