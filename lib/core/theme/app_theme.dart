import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryGreen,
        secondary: AppColors.primaryBlue,
        tertiary: AppColors.accentOrange,
        error: AppColors.error,
        surface: AppColors.surfaceLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      textTheme: _buildTextTheme(AppColors.textPrimary),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF2F3F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: CircleBorder(),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: Colors.transparent,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryGreen,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEEEE),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryGreen,
        secondary: AppColors.primaryBlue,
        tertiary: AppColors.accentOrange,
        error: AppColors.error,
        surface: AppColors.surfaceDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _buildTextTheme(Colors.white),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: AppColors.surfaceDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: CircleBorder(),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryGreen,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
          fontSize: 57, fontWeight: FontWeight.w700, color: baseColor),
      displayMedium: GoogleFonts.poppins(
          fontSize: 45, fontWeight: FontWeight.w700, color: baseColor),
      displaySmall: GoogleFonts.poppins(
          fontSize: 36, fontWeight: FontWeight.w700, color: baseColor),
      headlineLarge: GoogleFonts.poppins(
          fontSize: 32, fontWeight: FontWeight.w700, color: baseColor),
      headlineMedium: GoogleFonts.poppins(
          fontSize: 28, fontWeight: FontWeight.w700, color: baseColor),
      headlineSmall: GoogleFonts.poppins(
          fontSize: 24, fontWeight: FontWeight.w600, color: baseColor),
      titleLarge: GoogleFonts.poppins(
          fontSize: 20, fontWeight: FontWeight.w600, color: baseColor),
      titleMedium: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w600, color: baseColor),
      titleSmall: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
      bodyLarge: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w400, color: baseColor),
      bodyMedium: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w400, color: baseColor),
      bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: baseColor.withOpacity(0.7)),
      labelLarge: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
      labelMedium: GoogleFonts.poppins(
          fontSize: 12, fontWeight: FontWeight.w500, color: baseColor),
      labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: baseColor.withOpacity(0.7)),
    );
  }
}
