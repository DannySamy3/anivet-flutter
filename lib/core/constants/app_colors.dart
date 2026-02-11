import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Veterinary Theme)
  static const Color primaryGreen = Color(0xFF4CAF50); // Health & nature
  static const Color primaryBlue = Color(0xFF2196F3); // Trust & professionalism

  // Accent Colors
  static const Color accentOrange = Color(0xFFFF9800); // Warm & friendly
  static const Color accentPurple = Color(0xFF9C27B0);

  // Neutral Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color outline = Color(0xFFCCCCCC);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Boarding Status Colors
  static const Color statusPending = Color(0xFFFFC107);
  static const Color statusApproved = Color(0xFF4CAF50);
  static const Color statusActive = Color(0xFF2196F3);
  static const Color statusCompleted = Color(0xFF9E9E9E);
  static const Color statusCancelled = Color(0xFFF44336);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Pet Category Colors
  static const Color catColor = Color(0xFFE91E63);
  static const Color dogColor = Color(0xFF3F51B5);
  static const Color birdColor = Color(0xFFFFEB3B);
  static const Color otherColor = Color(0xFF9E9E9E);
}
