import 'package:nerimity_desktop_flutter/models/channel.dart';
import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:nerimity_desktop_flutter/stores/server_store.dart';

void handleSocketEvent(WidgetRef ref, String event, dynamic payload) {
  switch (event) {
    case 'user:authenticated':
      onUserAuthenticated(ref, payload);
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

void onUserAuthenticated(WidgetRef ref, dynamic payload) {
  final data = AuthenticatedPayload.fromJson(payload as Map<String, dynamic>);

  ref.read(serverStoreProvider.notifier).addServers(data.servers);
  ref.read(channelStoreProvider.notifier).addChannels(data.channels);
}
