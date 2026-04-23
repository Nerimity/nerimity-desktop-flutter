import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nerimity_desktop_flutter/theme/app_theme.dart';
import 'package:signals/signals_flutter.dart';
import '../../avatar.dart';
import 'package:nerimity_desktop_flutter/stores/server_store.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> with SignalsMixin {
  late final Computed<List<String>> _serverIds;

  @override
  void initState() {
    super.initState();
    _serverIds = createComputed(() => serverStore.servers.keys.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Watch((context) {
        final ids = _serverIds.value;
        return ListView(
          itemExtent: AvatarSize.xl.value + 4,
          padding: const EdgeInsets.symmetric(vertical: 6),
          children: ids.map((id) => ServerItem(id: id)).toList(),
        );
      }),
    );
  }
}

class ServerItem extends StatelessWidget {
  final String id;
  const ServerItem({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final server = serverStore.servers[id];
      if (server == null) return const SizedBox.shrink();

      final routerState = GoRouterState.of(context);
      final isSelected = routerState.pathParameters['serverId'] == id;

      return Padding(
        padding: const EdgeInsets.only(bottom: 2.0, left: 2.0, right: 2.0),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.itemSelectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () =>
                  context.go('/app/servers/$id/${server.defaultChannelId}'),
              child: Center(
                child: Avatar(server: server, size: AvatarSize.lg),
              ),
            ),
          ),
        ),
      );
    });
  }
}
