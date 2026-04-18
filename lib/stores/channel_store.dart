import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/channel.dart';

final channelStoreProvider =
    NotifierProvider<ChannelStore, Map<String, Channel>>(ChannelStore.new);

class ChannelStore extends Notifier<Map<String, Channel>> {
  @override
  Map<String, Channel> build() => {};

  void addChannels(List<Channel> channels) {
    state = {...state, for (final s in channels) s.id: s};
  }

  void addChannel(Channel channel) {
    state = {...state, channel.id: channel};
  }

  void removeChannel(String id) {
    state = Map.from(state)..remove(id);
  }
}

final channelsByServerProvider = Provider.family<List<Channel>, String>((
  ref,
  serverId,
) {
  return ref.watch(
    channelStoreProvider.select(
      (s) => s.values.where((c) => c.serverId == serverId).toList(),
    ),
  );
});
