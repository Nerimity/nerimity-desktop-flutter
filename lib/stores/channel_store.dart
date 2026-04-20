import 'package:signals/signals_flutter.dart';
import '../models/channel.dart';

final channelStore = ChannelStore();

class ChannelStore {
  final channels = mapSignal<String, Channel>({});

  void addChannels(List<Channel> list) {
    channels.addAll({for (final c in list) c.id: c});
  }

  void addChannel(Channel channel) {
    channels[channel.id] = channel;
  }

  void removeChannel(String id) {
    channels.remove(id);
  }
}
