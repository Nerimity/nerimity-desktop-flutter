import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:signals/signals_flutter.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});
  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> with SignalsMixin {
  Computed<List<String>>? _channelIds;
  String? _lastServerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final serverId = GoRouterState.of(context).pathParameters['serverId'];
    if (serverId == _lastServerId) return;
    _lastServerId = serverId;

    _channelIds?.dispose();
    _channelIds = createComputed(
      () => channelStore.channels.values
          .where((c) => c.serverId == serverId)
          .map((c) => c.id)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        children: [
          Expanded(
            child: Watch((context) {
              final channelIds = _channelIds?.value ?? [];
              return ListView.builder(
                itemCount: channelIds.length,
                itemBuilder: (ctx, i) => ChannelItem(id: channelIds[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ChannelItem extends StatelessWidget {
  final String id;
  const ChannelItem({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final channel = channelStore.channels[id];
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
    });
  }
}
