import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core palette
  static const primary = Color(0xFF5B5FEE);
  static const primaryLight = Color(0xFF8B8FF8);
  static const primaryDark = Color(0xFF3D41CC);
  static const surface = Color(0xFFF5F5FF);
  static const card = Colors.white;
  static const dark = Color(0xFF0F0F1A);
  static const grey = Color(0xFF6B7280);
  static const greyLight = Color(0xFFF0F0F7);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);

  // Habit colors
  static const habitColors = [
    Color(0xFF5B5FEE),
    Color(0xFF06B6D4),
    Color(0xFF22C55E),
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
    Color(0xFFf97316),
    Color(0xFF64748B),
  ];

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          background: surface,
        ),
        scaffoldBackgroundColor: surface,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(color: dark),
        ),
      );
}
