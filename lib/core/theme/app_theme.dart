import 'package:flutter/material.dart';

class AppColors {
  static const primaryPink = Color(0xFFFA6978);
  static const secondaryPink = Color(0xFFFF85C2);
  static const softBackground = Color(0xFFFFFFFF);
  static const accentPurple = Color(0xC084FCFF);
  static const successGreen = Color(0xFF43A047);
  static const warningRed = Color(0xFFE53935);
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF757575);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryPink,
          primary: AppColors.primaryPink,
          secondary: AppColors.secondaryPink,
          surface: Colors.white,
          error: AppColors.warningRed,
        ),
        scaffoldBackgroundColor: AppColors.softBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPink,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFF0F0F0)),
          ),
        ),
      );
}

