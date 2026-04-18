class Channel {
  final String id;
  final String? name;
  final String? serverId;

  Channel({required this.id, this.name, this.serverId});

  factory Channel.fromJson(Map<String, dynamic> json) =>
      Channel(id: json['id'], name: json['name'], serverId: json['serverId']);
}
