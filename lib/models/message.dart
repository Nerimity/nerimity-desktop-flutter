import 'package:nerimity_desktop_flutter/models/user.dart';

class Message {
  final String id;
  final String content;
  final String channelId;
  final User createdBy;
  final List<User> mentions;

  Message({
    required this.id,
    required this.content,
    required this.channelId,
    required this.createdBy,
    this.mentions = const [],
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    content: json['content'],
    channelId: json['channelId'],
    createdBy: User.fromJson(json['createdBy']),
    mentions: (json['mentions'] as List).map((m) => User.fromJson(m)).toList(),
  );

  Message copyWith({String? content}) {
    return Message(
      id: id,
      content: content ?? this.content,
      channelId: channelId,
      createdBy: createdBy,
      mentions: mentions,
    );
  }
}
