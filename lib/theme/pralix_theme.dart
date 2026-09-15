import 'package:flutter/material.dart';

class PralixTheme {
  static const background = Color(0xFF0A0F1D);
  static const surface = Color(0xFF131C31);
  static const card = Color(0xFF1D2A4A);
  static const cyan = Color(0xFF0EA5E9);
  static const sky = Color(0xFF38BDF8);
  static const amber = Color(0xFFF59E0B);
  static const textPrimary = Color(0xFFF0F9FF);
  static const textSecondary = Color(0xFF94A3B8);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: cyan,
      cardColor: card,
      fontFamily: 'AppFont',
      colorScheme: const ColorScheme.dark(
        primary: cyan,
        secondary: sky,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
