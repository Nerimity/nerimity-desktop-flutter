class UserPresence {
  final String userId;
  final int status;

  UserPresence({required this.userId, required this.status});

  factory UserPresence.fromJson(Map<String, dynamic> json) =>
      UserPresence(userId: json['userId'], status: json['status']);
}
