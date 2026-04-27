import 'package:flutter/material.dart';

class AppTheme {
  static const Color itemSelectedBg = Color(0x9942464c);
  static const Color itemHoveredBg = Color(0x6642464c);

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xff4c93ff),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xff4c93ff),
        selectionColor: Color(0xff4c93ff),
        selectionHandleColor: Color(0xff4c93ff),
      ),
      colorScheme: const ColorScheme.light(
        surface: Color(0xfff0f0f0),
        surfaceContainerLow: Color(0xFFe0e0e0),
        surfaceContainerHigh: Color(0xFFFFFFFF),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      primaryColor: const Color(0xff4c93ff),

      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF000000),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xff4c93ff),
        selectionColor: Color(0xff4c93ff),
        selectionHandleColor: Color(0xff4c93ff),
      ),
      colorScheme: const ColorScheme.dark(
        surface: Color(0xff0f0f0f), // channel list bg
        surfaceContainerLow: Color(0xFF000000), // server list bg
        surfaceContainerHigh: Color(0xFF000000), // content bg
      ),
    );
  }
}
