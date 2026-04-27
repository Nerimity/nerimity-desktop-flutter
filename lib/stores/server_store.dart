import 'package:nerimity_desktop_flutter/models/channel.dart';
import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:nerimity_desktop_flutter/models/server_member.dart';
import 'package:nerimity_desktop_flutter/models/server_role.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:nerimity_desktop_flutter/stores/server_member_store.dart';
import 'package:nerimity_desktop_flutter/stores/server_roles_store.dart';
import 'package:signals/signals_flutter.dart';

final serverStore = ServerStore();

class ServerStore {
  final Signal<String?> currentServerId = signal(null);
  final servers = mapSignal<String, Server>({});

  void addServers(List<Server> list) {
    servers.addAll({for (final s in list) s.id: s});
  }

  void addServer(Server server) {
    servers[server.id] = server;
  }

  void removeServer(String id) {
    servers.remove(id);
  }

  void setCurrentServerId(String? id) {
    currentServerId.value = id;
  }

  late final Computed<Server?> currentServer = computed(() {
    return servers[currentServerId.value];
  });

  late final Computed<Iterable<Channel>> currentServerChannels = computed(() {
    return channelStore.channels.values.where(
      (c) => c.serverId == currentServerId.value,
    );
  });

  late final Computed<MapSignal<String, ServerMember>?> currentServerMembers =
      computed(() {
        return serverMemberStore.serverMembers[currentServerId.value];
      });

  late final Computed<MapSignal<String, ServerRole>?> currentServerRoles =
      computed(() {
        return serverRolesStore.serverRoles[currentServerId.value];
      });

  late final sortedRoles = computed(() {
    final roles = currentServerRoles.value?.values.toList() ?? [];
    roles.sort((a, b) => b.order.compareTo(a.order));
    return roles;
  });

  String? memberTopColor(ServerMember? member) {
    if (member == null) return null;
    final sorted = sortedRoles.value;
    for (final role in sorted) {
      if (member.roleIds.contains(role.id) && role.hexColor != null) {
        return role.hexColor;
      }
    }
    return null;
  }

  late final Computed<ServerRole?> currentServerDefaultRole = computed(() {
    final defaultRoleId = currentServer()?.defaultRoleId;
    return serverRolesStore.serverRoles[currentServerId.value]?[defaultRoleId];
  });
}
