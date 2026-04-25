import 'package:nerimity_desktop_flutter/models/user.dart';
import 'package:signals/signals_flutter.dart';

final userStore = UserStore();

class UserStore {
  final users = mapSignal<String, User>({});

  void setUsers(List<User> list) {
    users.addAll({for (final u in list) u.id: u});
  }

  void addUser(User user) {
    users[user.id] = user;
  }
}
