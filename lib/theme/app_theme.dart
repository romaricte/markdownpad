import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Couleurs ---
  static const Color _primaryLight = Color(0xFF1A1A2E);
  static const Color _accentLight = Color(0xFF6C63FF);
  static const Color _surfaceLight = Color(0xFFF8F9FA);
  static const Color _cardLight = Colors.white;
  static const Color _textPrimaryLight = Color(0xFF1A1A2E);
  static const Color _textSecondaryLight = Color(0xFF6B7280);

  static const Color _primaryDark = Color(0xFFE4E4E7);
  static const Color _accentDark = Color(0xFF818CF8);
  static const Color _surfaceDark = Color(0xFF0F0F17);
  static const Color _cardDark = Color(0xFF1A1A28);
  static const Color _textPrimaryDark = Color(0xFFE4E4E7);
  static const Color _textSecondaryDark = Color(0xFF9CA3AF);

  // --- Light Theme ---
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _surfaceLight,
      colorScheme: const ColorScheme.light(
        primary: _accentLight,
        secondary: _accentLight,
        surface: _surfaceLight,
        onPrimary: Colors.white,
        onSurface: _textPrimaryLight,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: _textPrimaryLight,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: _textPrimaryLight,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: _textPrimaryLight,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: _textSecondaryLight,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _accentLight,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: _cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _surfaceLight,
        foregroundColor: _textPrimaryLight,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accentLight,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  // --- Dark Theme ---
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _surfaceDark,
      colorScheme: const ColorScheme.dark(
        primary: _accentDark,
        secondary: _accentDark,
        surface: _surfaceDark,
        onPrimary: Colors.white,
        onSurface: _textPrimaryDark,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: _textPrimaryDark,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: _textPrimaryDark,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: _textPrimaryDark,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: _textSecondaryDark,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _accentDark,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _surfaceDark,
        foregroundColor: _textPrimaryDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accentDark,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}