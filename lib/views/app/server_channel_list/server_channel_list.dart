import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';

class ChannelList extends ConsumerWidget {
  const ChannelList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverId = GoRouterState.of(context).pathParameters['serverId'];

    final channelIds = ref.watch(
      channelStoreProvider.select(
        (s) => s.values
            .where((c) => c.serverId == serverId)
            .map((c) => c.id)
            .toSet(),
      ),
    );

    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: channelIds.length,
              itemBuilder: (ctx, i) => ChannelItem(id: channelIds.elementAt(i)),
            ),
          ),
        ],
      ),
    );
  }
}

class ChannelItem extends ConsumerWidget {
  final String id;
  const ChannelItem({super.key, required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(channelStoreProvider.select((s) => s[id]));
    if (channel == null) return const SizedBox.shrink();

    return Container(child: Text(channel.name ?? ''));
  }
}
