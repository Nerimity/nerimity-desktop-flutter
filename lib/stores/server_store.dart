import 'package:nerimity_desktop_flutter/models/server.dart';
import 'package:signals/signals_flutter.dart';

final serverStore = ServerStore();

class ServerStore {
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
}
