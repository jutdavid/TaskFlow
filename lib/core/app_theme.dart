import 'package:flutter/material.dart';

// Paleta de color propia
class AppColors {
  static const Color primary = Color(0xFF3D5AFE);
  static const Color secondary = Color(0xFF00BFA5);
  static const Color background = Color(0xFF0F1226);
  static const Color card = Color(0xFF1B1F3B);
  static const Color textLight = Color(0xFFEDEFFF);
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
);
