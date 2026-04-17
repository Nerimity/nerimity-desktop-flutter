import 'package:flutter/material.dart';

class ChannelList extends StatelessWidget {
  const ChannelList({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        children: [Expanded(child: ListView(children: [
              ],
            ))],
      ),
    );
  }
}
