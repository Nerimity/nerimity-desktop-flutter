class MessageMention {
  final String channelId;
  final String? serverId;
  int count;

  MessageMention({required this.channelId, this.serverId, required this.count});

  factory MessageMention.fromJson(Map<String, dynamic> json) {
    return MessageMention(
      channelId: json['channelId'] as String,
      serverId: json['serverId'] as String?,
      count: json['count'] as int,
    );
  }
}
