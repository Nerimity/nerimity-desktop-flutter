import 'package:flutter/material.dart';
import 'package:nerimity_desktop_flutter/utils/secure_storage.dart';
import 'package:nerimity_desktop_flutter/utils/theme_notifier.dart';
import 'theme/app_theme.dart';
import 'package:nerimity_desktop_flutter/services/socket_service.dart';
import './router.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() async {
    final token = await getToken();
    if (token != null) {
      SocketService.instance.connect(token);
    }
  }

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
        );
      },
    );
  }
}
