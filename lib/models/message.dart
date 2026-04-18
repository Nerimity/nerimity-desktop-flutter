// lib/models/message.dart
import 'package:nerimity_desktop_flutter/models/user.dart';

class Message {
  final String id;
  final String content;
  final String channelId;
  final User createdBy;

  Message({
    required this.id,
    required this.content,
    required this.channelId,
    required this.createdBy,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    content: json['content'],
    channelId: json['channelId'],
    createdBy: User.fromJson(json['createdBy']),
  );
}
