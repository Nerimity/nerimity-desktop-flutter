import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/stores/mouse_store.dart';
import 'package:nerimity_desktop_flutter/stores/window_focus_store.dart';

class MouseObserver extends StatelessWidget {
  final Widget child;
  const MouseObserver({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        lastClickPosition.value = event.position;
        isWindowFocused.value = true;
      },
      child: child,
    );
  }
}
