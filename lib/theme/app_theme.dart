import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0x0),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xff4c93ff),
        selectionColor: Color(0xff4c93ff),
        selectionHandleColor: Color(0xff4c93ff),
      ),
      colorScheme: const ColorScheme.dark(
        surface: Color(0xff0f0f0f), // channel list bg
        surfaceContainerLow: Color(0x0), // server list bg
        surfaceContainerHigh: Color(0x0), // content bg
      ),
    );
  }
}
