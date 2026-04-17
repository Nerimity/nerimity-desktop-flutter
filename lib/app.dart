import 'package:flutter/material.dart';
import 'views/app/app_view.dart';
import 'theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const AppView(),
    );
  }
}
