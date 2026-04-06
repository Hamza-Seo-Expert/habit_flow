import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5F3DC4);
  static const Color primaryLight = Color(0xFF9B88D4);

  // Secondary Colors
  static const Color accentColor = Color(0xFF00B894);
  static const Color accentLight = Color(0xFF55EFC4);

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF5F6FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD63031);
  static const Color warningColor = Color(0xFFFDA7DF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Mood Colors
  static const Color moodExcellent = Color(0xFF00B894);
  static const Color moodGood = Color(0xFF74B9FF);
  static const Color moodNeutral = Color(0xFFFFCE56);
  static const Color moodBad = Color(0xFFFF7675);
  static const Color moodTerrible = Color(0xFFD63031);

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Health': Color(0xFF00B894),
    'Work': Color(0xFF6C5CE7),
    'Learning': Color(0xFF0984E3),
    'Fitness': Color(0xFFFF7675),
    'Mindfulness': Color(0xFF74B9FF),
    'Social': Color(0xFFFFCE56),
    'Creative': Color(0xFFE17055),
    'Other': Color(0xFFB2BEC3),
  };

  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // Shadow
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x19000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 12,
    offset: Offset(0, 6),
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        tertiary: primaryLight,
        surface: surfaceColor,
        error: errorColor,
        outline: textLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: md,
          vertical: md,
        ),
        labelStyle: GoogleFonts.poppins(
          color: textSecondary,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.poppins(
          color: textLight,
          fontSize: 14,
        ),
      ),
    );
  }
}