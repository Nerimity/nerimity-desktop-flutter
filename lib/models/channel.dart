enum ChannelType {
  dmText(0),
  serverText(1),
  category(2);

  final int value;
  const ChannelType(this.value);

  static ChannelType fromInt(int v) =>
      ChannelType.values.firstWhere((e) => e.value == v);
}

class Channel {
  final String id;
  final int type;
  final String? name;
  final int? order;
  final String? serverId;
  final String? icon;
  final String? categoryId;

  Channel({
    required this.id,
    required this.type,
    this.name,
    this.serverId,
    this.icon,
    this.order,
    this.categoryId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    id: json['id'],
    type: json['type'],

    name: json['name'],
    serverId: json['serverId'],
    order: json['order'],
    icon: json['icon'],
    categoryId: json['categoryId'],
  );
}
