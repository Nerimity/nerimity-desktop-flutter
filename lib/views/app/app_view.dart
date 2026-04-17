import 'package:flutter/material.dart';
import './content_area/content_area.dart';
import './server_channel_list/server_channel_list.dart';
import './server_list/server_list.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const ServerList(),
          const ChannelList(),
          Expanded(child: ContentArea()),
        ],
      ),
    );
  }
}
