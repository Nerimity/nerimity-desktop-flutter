import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'package:nerimity_desktop_flutter/services/socket_service.dart';
import './router.dart';

import '../config.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    SocketService.instance.connect(userToken);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
