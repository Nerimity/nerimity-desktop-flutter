import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nerimity_desktop_flutter/stores/channel_store.dart';
import 'package:nerimity_desktop_flutter/stores/server_store.dart';
import 'package:nerimity_desktop_flutter/views/app/server_channel_list/server_channel_list.dart';
import 'package:nerimity_desktop_flutter/views/app/server_member_list/server_member_list.dart';
import '../app/server_list/server_list.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,

      child: Row(
        children: [
          ServerList(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class ChatLayout extends StatefulWidget {
  final Widget child;
  const ChatLayout({required this.child, super.key});

  @override
  State<ChatLayout> createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final serverId = GoRouterState.of(context).pathParameters['serverId'];
    final channelId = GoRouterState.of(context).pathParameters['channelId'];
    if (serverStore.currentServerId.value != serverId) {
      serverStore.setCurrentServerId(serverId);
    }

    if (channelStore.currentChannelId.value != channelId) {
      channelStore.setCurrentChannelId(channelId);
    }
  }

  @override
  void dispose() {
    channelStore.setCurrentChannelId(null);
    serverStore.setCurrentServerId(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Row(
        children: [
          ServerChannelList(),
          Expanded(child: widget.child),
          ServerMemberList(),
        ],
      ),
    );
  }
}
