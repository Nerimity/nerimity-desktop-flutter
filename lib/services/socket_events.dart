import 'package:flutter/foundation.dart';
import 'package:nerimity_desktop_flutter/models/channel.dart';
import 'package:nerimity_desktop_flutter/models/message.dart';
import 'package:nerimity_desktop_flutter/models/raw_server_member.dart';
import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:nerimity_desktop_flutter/models/server_role.dart';
import 'package:nerimity_desktop_flutter/models/user.dart';
import 'package:nerimity_desktop_flutter/models/user_presence.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:nerimity_desktop_flutter/stores/message_store.dart';
import 'package:nerimity_desktop_flutter/stores/server_member_store.dart';
import 'package:nerimity_desktop_flutter/stores/server_roles_store.dart';
import 'package:nerimity_desktop_flutter/stores/server_store.dart';
import 'package:nerimity_desktop_flutter/stores/user_presence_store.dart';
import 'package:nerimity_desktop_flutter/stores/user_store.dart';

void handleSocketEvent(String event, dynamic payload) {
  switch (event) {
    case 'user:authenticated':
      onUserAuthenticated(payload);
    case 'message:created':
      onMessageCreated(payload);
  }
}

class AuthenticatedPayload {
  final User user;
  final List<Server> servers;
  final List<Channel> channels;
  final List<RawServerMember> serverMembers;
  final List<ServerRole> serverRoles;
  final List<UserPresence> presences;

  AuthenticatedPayload({
    required this.user,
    required this.servers,
    required this.channels,
    required this.serverMembers,
    required this.serverRoles,
    required this.presences,
  });

  factory AuthenticatedPayload.fromJson(Map<String, dynamic> json) =>
      AuthenticatedPayload(
        user: User.fromJson(json['user']),
        servers: (json['servers'] as List)
            .map((s) => Server.fromJson(s))
            .toList(),
        channels: (json['channels'] as List)
            .map((s) => Channel.fromJson(s))
            .toList(),
        serverMembers: (json['serverMembers'] as List)
            .map((s) => RawServerMember.fromJson(s))
            .toList(),
        serverRoles: (json['serverRoles'] as List)
            .map((s) => ServerRole.fromJson(s))
            .toList(),
        presences: (json['presences'] as List)
            .map((s) => UserPresence.fromJson(s))
            .toList(),
      );
}

AuthenticatedPayload _parseAuthenticatedPayload(Map<String, dynamic> json) {
  return AuthenticatedPayload.fromJson(json);
}

Future<void> onUserAuthenticated(dynamic payload) async {
  final data = await compute(
    _parseAuthenticatedPayload,
    payload as Map<String, dynamic>,
  );
  serverStore.addServers(data.servers);
  channelStore.addChannels(data.channels);
  serverMemberStore.addServerMembers(data.serverMembers);
  serverRolesStore.addServerRoles(data.serverRoles);
  userPresenceStore.addPresences(data.presences);
  userStore.setCurrentUser(data.user);
}

void onMessageCreated(dynamic payload) {
  final message = Message.fromJson(payload["message"]);
  messageStore.addMessage(message.channelId, message);
}
