import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/views/app/server_channel_list/server_channel_list.dart';
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

class ChatLayout extends StatelessWidget {
  final Widget child;
  const ChatLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Row(
        children: [
          ChannelList(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
