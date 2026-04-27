import 'package:nerimity_desktop_flutter/models/user.dart';

class Message {
  final String id;
  final String content;
  final String channelId;
  final User createdBy;
  final List<User> mentions;
  final List<Attachment> attachments;

  Message({
    required this.id,
    required this.content,
    required this.channelId,
    required this.createdBy,
    required this.attachments,
    this.mentions = const [],
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    content: json['content'],
    channelId: json['channelId'],
    createdBy: User.fromJson(json['createdBy']),
    mentions: (json['mentions'] as List).map((m) => User.fromJson(m)).toList(),
    attachments: (json['attachments'] as List)
        .map((a) => Attachment.fromJson(a))
        .toList(),
  );

  Message copyWith({String? content}) {
    return Message(
      id: id,
      content: content ?? this.content,
      channelId: channelId,
      createdBy: createdBy,
      mentions: mentions,
      attachments: attachments,
    );
  }
}

class Attachment {
  final String id;
  final String? path;

  final String? mime;
  final int? width;
  final int? height;

  Attachment({required this.id, this.path, this.mime, this.width, this.height});

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json['id'],
    path: json['path'] as String?,
    mime: json['mime'] as String?,
    width: json['width'] as int?,
    height: json['height'] as int?,
  );
}
