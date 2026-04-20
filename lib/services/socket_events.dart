import 'package:flutter/foundation.dart';
import 'package:nerimity_desktop_flutter/models/channel.dart';
import 'package:nerimity_desktop_flutter/models/message.dart';
import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:nerimity_desktop_flutter/stores/message_store.dart';
import 'package:nerimity_desktop_flutter/stores/server_store.dart';

void handleSocketEvent(String event, dynamic payload) {
  switch (event) {
    case 'user:authenticated':
      onUserAuthenticated(payload);
    case 'message:created':
      onMessageCreated(payload);
  }
}

class AuthenticatedPayload {
  final List<Server> servers;
  final List<Channel> channels;

  AuthenticatedPayload({required this.servers, required this.channels});

  factory AuthenticatedPayload.fromJson(Map<String, dynamic> json) =>
      AuthenticatedPayload(
        servers: (json['servers'] as List)
            .map((s) => Server.fromJson(s))
            .toList(),
        channels: (json['channels'] as List)
            .map((s) => Channel.fromJson(s))
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
}

void onMessageCreated(dynamic payload) {
  final message = Message.fromJson(payload["message"]);
  messageStore.addMessage(message.channelId, message);
}
