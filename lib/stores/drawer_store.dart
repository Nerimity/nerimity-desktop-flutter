import 'package:signals/signals.dart';

final drawer = DrawerStore();

enum DrawerSide { left, right }

class DrawerStore {
  final opened = signal<DrawerSide?>(DrawerSide.left);

  void toggle(DrawerSide side) {
    if (opened.value == side) {
      opened.value = null;
    } else {
      opened.value = side;
    }
  }
}
