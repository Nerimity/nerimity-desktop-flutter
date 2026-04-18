// lib/services/socket_service.dart
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import './socket_events.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocketService {
  static final SocketService instance = SocketService._();
  SocketService._();

  WebSocketChannel? _channel;
  String token = "";

  WidgetRef? ref;

  void connect(String token) {
    this.token = token;
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://nerimity.com/socket.io/?EIO=4&transport=websocket'),
    );
    _channel!.stream.listen(_onEvent, onDone: _onDisconnect);
  }

  void _onEvent(dynamic raw) {
    if (raw[0] == '0') {
      _channel?.sink.add("40");
      return;
    }

    if (raw[0] == '2') {
      _channel?.sink.add("3");
      return;
    }

    if (raw[0] == "4" && raw[1] == "0") {
      send("user:authenticate", {"token": token});
    }

    if (raw[0] == "4" && raw[1] == "2") {
      if (ref == null) return;

      final decodedEvent = jsonDecode(raw.substring(2)) as List<dynamic>;
      handleSocketEvent(ref!, decodedEvent[0], decodedEvent[1]);
    }
  }

  void send(String event, Map<String, dynamic> payload) {
    _channel?.sink.add("42${jsonEncode([event, payload])}");
  }

  void _onDisconnect() {}

  void dispose() => _channel?.sink.close();
}
