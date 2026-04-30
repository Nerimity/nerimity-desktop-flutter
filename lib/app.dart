import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/utils/theme_notifier.dart';
import 'package:nerimity_desktop_flutter/views/media_query_observer.dart';
import 'package:nerimity_desktop_flutter/views/mouse_observer.dart';
import 'package:nerimity_desktop_flutter/views/window_focus_observer.dart';
import 'theme/app_theme.dart';
import './router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          routerConfig: router,
          builder: (context, child) => FocusObserver(
            child: MouseObserver(child: MediaQueryObserver(child: child!)),
          ),
        );
      },
    );
  }
}
