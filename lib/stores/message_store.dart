// lib/stores/message_store.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nerimity_desktop_flutter/services/api_client.dart';
import '../models/message.dart';

final messageStoreProvider =
    NotifierProvider<MessageStore, Map<String, List<Message>>>(
      MessageStore.new,
    );

class MessageStore extends Notifier<Map<String, List<Message>>> {
  @override
  Map<String, List<Message>> build() => {};

  Future<void> loadMessages(String channelId) async {
    if (state[channelId] != null) return;
    try {
      final response = await dio.get('/channels/$channelId/messages');
      final messages = (response.data as List)
          .map((m) => Message.fromJson(m))
          .toList();
      state = {...state, channelId: messages};
    } on DioException catch (e) {
      debugPrint(
        'loadMessages error: ${e.response?.statusCode} ${e.response?.data}',
      );
    }
  }

  void setMessages(String channelId, List<Message> messages) {
    state = {...state, channelId: messages};
  }

  void addMessage(String channelId, Message message) {
    if (state[channelId] == null) return;

    final current = state[channelId] ?? [];
    final updated = [...current, message];
    state = {
      ...state,
      channelId: updated.length > 100
          ? updated.sublist(updated.length - 100)
          : updated,
    };
  }
}
