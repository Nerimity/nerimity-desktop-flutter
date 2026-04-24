import 'package:flutter/material.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

void toggleTheme() {
  themeNotifier.value = themeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}
