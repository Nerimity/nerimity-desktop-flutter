import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nerimity_desktop_flutter/config.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:nerimity_desktop_flutter/theme/app_theme.dart';
import 'package:nerimity_desktop_flutter/utils/emojis.dart';
import 'package:nerimity_desktop_flutter/utils/image.dart';
import 'package:signals/signals_flutter.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});
  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> with SignalsMixin {
  late final _serverId = createSignal<String?>(null);
  late final _channelIds = createComputed(
    () => channelStore.channels.values
        .where((c) => c.serverId == _serverId.value)
        .map((c) => c.id)
        .toList(),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _serverId.value = GoRouterState.of(context).pathParameters['serverId'];
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

class ChannelItem extends StatefulWidget {
  final String id;
  const ChannelItem({super.key, required this.id});

  @override
  State<ChannelItem> createState() => _ChannelItemState();
}

class _ChannelItemState extends State<ChannelItem> with SignalsMixin {
  late final _isHovered = createSignal(false);

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final channel = channelStore.channels[widget.id];
      if (channel == null) return const SizedBox.shrink();

      final routerState = GoRouterState.of(context);
      final isSelected = routerState.pathParameters['channelId'] == widget.id;
      final isActive = isSelected || _isHovered.value;

      final isSvgIcon = channel.icon != null && !channel.icon!.contains(".");

      final iconUrl = channel.icon != null
          ? isSvgIcon
                ? unicodeToTwemojiUrl(channel.icon!)
                : buildImageUrl('${cdnUrl}emojis/${channel.icon}', size: 60)
          : null;

      return Padding(
        padding: const EdgeInsets.only(bottom: 2.0, left: 8.0, right: 8.0),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.itemSelectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              hoverColor: AppTheme.itemHoveredBg,
              borderRadius: BorderRadius.circular(8),
              onHover: (hovering) => _isHovered.value = hovering,
              onTap: () {
                context.go('/app/servers/${channel.serverId}/${channel.id}');
              },
              highlightColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    iconUrl != null
                        ? isSvgIcon
                              ? SvgPicture.network(
                                  iconUrl,
                                  width: 20,
                                  height: 20,
                                )
                              : Image.network(
                                  iconUrl,
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox.shrink(),
                                )
                        : const Icon(
                            Icons.tag,
                            size: 20,
                            color: Colors.white70,
                          ),
                    Text(
                      channel.name ?? '',
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: isActive ? 1.0 : 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
