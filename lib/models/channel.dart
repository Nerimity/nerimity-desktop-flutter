class Channel {
  final String id;
  final String? name;
  final String? serverId;
  final String? icon;

  Channel({required this.id, this.name, this.serverId, this.icon});

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    id: json['id'],
    name: json['name'],
    serverId: json['serverId'],
    icon: json['icon'],
  );
}
