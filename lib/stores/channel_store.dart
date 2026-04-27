import 'package:signals/signals_flutter.dart';
import '../models/channel.dart';

final channelStore = ChannelStore();

class ChannelStore {
  final Signal<String?> currentChannelId = signal(null);

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

  void setCurrentChannelId(String? id) {
    currentChannelId.value = id;
  }

  late final Computed<Channel?> currentChannel = computed(() {
    return channels[currentChannelId.value];
  });

  late final Computed<Map<String, int>> currentPermissions = computed(() {
    final channel = currentChannel();
    final Map<String, int> channelPermissions = {
      for (final p in channel?.permissions ?? []) p.roleId: p.permissions,
    };
    return channelPermissions;
  });
}
