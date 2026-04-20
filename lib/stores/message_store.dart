import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nerimity_desktop_flutter/services/api_client.dart';
import 'package:signals/signals_flutter.dart';
import '../models/message.dart';

final messageStore = MessageStore();

class MessageStore {
  final messages = mapSignal<String, List<Message>>({});

  Future<void> loadMessages(String channelId) async {
    if (messages[channelId] != null) return;
    try {
      final response = await dio.get('/channels/$channelId/messages');
      final list = (response.data as List)
          .map((m) => Message.fromJson(m))
          .toList();
      messages[channelId] = list;
    } on DioException catch (e) {
      debugPrint(
        'loadMessages error: ${e.response?.statusCode} ${e.response?.data}',
      );
    }
  }

  void setMessages(String channelId, List<Message> list) {
    messages[channelId] = list;
  }

  void addMessage(String channelId, Message message) {
    final current = messages[channelId];
    if (current == null) return;
    final updated = [...current, message];
    messages[channelId] = updated.length > 100
        ? updated.sublist(updated.length - 100)
        : updated;
  }
}
