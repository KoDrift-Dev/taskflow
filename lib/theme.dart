import 'package:flutter/material.dart';

/// Brand palette sampled from the TaskFlow reference design.
class AppColors {
  static const Color primary = Color(0xFF2F6BFF);
  static const Color primaryDark = Color(0xFF1E4FD1);
  static const Color primarySoft = Color(0xFFE8EFFF);
  static const Color background = Color(0xFFF6F8FC);
  static const Color card = Colors.white;
  static const Color ink = Color(0xFF1B2340);
  static const Color grey = Color(0xFF8A94A8);
  static const Color line = Color(0xFFE8EDF5);

  // Category chips
  static const Color work = Color(0xFF2F6BFF);
  static const Color workBg = Color(0xFFE8EFFF);
  static const Color design = Color(0xFF8B5CF6);
  static const Color designBg = Color(0xFFF1E9FF);
  static const Color general = Color(0xFF6B7686);
  static const Color generalBg = Color(0xFFEEF1F6);
  static const Color research = Color(0xFFE8821E);
  static const Color researchBg = Color(0xFFFFF1E3);

  // Priorities
  static const Color low = Color(0xFF22C55E);
  static const Color lowBg = Color(0xFFE7F8EE);
  static const Color medium = Color(0xFFF59E0B);
  static const Color mediumBg = Color(0xFFFEF3E2);
  static const Color high = Color(0xFFEF4444);
  static const Color highBg = Color(0xFFFDECEC);

  static const Color danger = Color(0xFFEF4444);
}

ThemeData buildTheme() {
  const base = TextStyle(color: AppColors.ink, fontFamily: 'Roboto');
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: base.copyWith(color: AppColors.grey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    ),
    textTheme: TextTheme(
      displaySmall: base.copyWith(fontSize: 30, fontWeight: FontWeight.w800),
      headlineSmall: base.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
      titleLarge: base.copyWith(fontSize: 17, fontWeight: FontWeight.w700),
      titleMedium: base.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      bodyLarge: base.copyWith(fontSize: 15),
      bodyMedium: base.copyWith(fontSize: 13.5, color: AppColors.grey),
      labelLarge: base.copyWith(
          fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
    ),
  );
}

/// Shared card decoration used across screens.
BoxDecoration cardDecoration({double radius = 18}) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.line),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D1B2340),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    );
