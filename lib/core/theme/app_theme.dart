import 'package:flutter/material.dart';

abstract class AppTheme {
  static const Color backgroundColor = Color(0xFF37393b);
  static const Color foregroundColor = Color(0xFFffffff);

  static const LinearGradient geminiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA777E3),
      Color(0xFF6E8EFB),
      Color(0xFF4A6CF7),
      Color(0xFF3B5BDB),
    ],
    stops: [0.1, 0.4, 0.7, 1.0],
  );

  static ThemeData defaultTheme() {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      brightness: Brightness.dark,
    );
  }
}
