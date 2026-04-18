import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/server.dart';

final serverStoreProvider = NotifierProvider<ServerStore, Map<String, Server>>(
  ServerStore.new,
);

class ServerStore extends Notifier<Map<String, Server>> {
  @override
  Map<String, Server> build() => {};

  void addServers(List<Server> servers) {
    state = {...state, for (final s in servers) s.id: s};
  }

  void addServer(Server server) {
    state = {...state, server.id: server};
  }

  void removeServer(String id) {
    state = Map.from(state)..remove(id);
  }
}
