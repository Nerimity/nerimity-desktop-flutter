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

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Material(
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8),

          onTap: () {
            context.go('/app/servers/${channel.serverId}/${channel.id}');
          },
          hoverColor: Colors.black,
          child: Container(
            padding: const EdgeInsets.all(8.0),

            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Text(channel.name ?? ''),
          ),
        ),
      ),
    );
  }
}
