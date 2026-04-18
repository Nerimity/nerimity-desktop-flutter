import 'package:flutter/material.dart';
import '../../avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nerimity_desktop_flutter/stores/server_store.dart';

class ServerList extends ConsumerWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(serverStoreProvider.select((s) => s.keys.toSet()));

    return Container(
      width: 72,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView(children: ids.map((id) => ServerItem(id: id)).toList()),
    );
  }
}

class ServerItem extends ConsumerWidget {
  final String id;
  const ServerItem({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(serverStoreProvider.select((s) => s[id]));
    if (server == null) return const SizedBox.shrink();
    return Center(child: Avatar(server: server));
  }
}
