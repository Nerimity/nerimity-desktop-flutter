import 'package:flutter/material.dart';
import '../../avatar.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Avatar(label: 'GD', color: Colors.teal.shade800),
          Avatar(label: 'RD', color: Colors.orange.shade800),
        ],
      ),
    );
  }
}
