import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/app/app_view.dart';
import 'theme/app_theme.dart';
import 'package:nerimity_desktop_flutter/services/socket_service.dart';

import '../config.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    SocketService.instance.ref = ref;
    SocketService.instance.connect(userToken);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const AppView(),
    );
  }
}
