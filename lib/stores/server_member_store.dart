import 'package:nerimity_desktop_flutter/models/channel.dart';
import 'package:nerimity_desktop_flutter/models/raw_server_member.dart';
import 'package:nerimity_desktop_flutter/models/server_member.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:nerimity_desktop_flutter/stores/user_store.dart';
import 'package:signals/signals_flutter.dart';

final serverMemberStore = ServerMemberStore();

class ServerMemberStore {
  final serverMembers = mapSignal<String, MapSignal<String, ServerMember>>({});

  MapSignal<String, ServerMember> _getOrCreate(String serverId) {
    if (!serverMembers.containsKey(serverId)) {
      serverMembers[serverId] = mapSignal<String, ServerMember>({});
    }
    return serverMembers[serverId]!;
  }

  void addServerMembers(List<RawServerMember> list) {
    batch(() {
      for (final raw in list) {
        userStore.addUser(raw.user);
        final member = ServerMember(
          id: raw.id,
          userId: raw.userId,
          serverId: raw.serverId,
          roleIds: raw.roleIds,
        );
        _getOrCreate(raw.serverId)[raw.userId] = member;
      }
    });
  }

  void addServerMember(String serverId, ServerMember serverMember) {
    _getOrCreate(serverId)[serverMember.userId] = serverMember;
  }
}
