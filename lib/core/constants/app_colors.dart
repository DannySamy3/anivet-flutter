import 'package:flutter/material.dart';

class AppColors {
  // ANIVET Brand Colors (matched from anivet.co.tz)
  static const Color primaryGreen =
      Color(0xFFC2185B); // Magenta — "ANIVET" brand pink
  static const Color primaryBlue =
      Color(0xFF1A3558); // Navy blue — "VETERINARY CLINIC" text
  static const Color brandOrange =
      Color(0xFFF4511E); // Orange — tagline & logo accent line

  // Accent Colors
  static const Color accentOrange = Color(0xFFF4511E);
  static const Color accentPurple = Color(0xFF9C27B0);

  // Neutral Colors
  static const Color textPrimary = Color(0xFF1A3558); // Navy for headers
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
  static const Color info = Color(0xFF1A3558);

  // Boarding Status Colors
  static const Color statusPending = Color(0xFFFFC107);
  static const Color statusApproved = Color(0xFF4CAF50);
  static const Color statusActive = Color(0xFF1A3558);
  static const Color statusCompleted = Color(0xFF9E9E9E);
  static const Color statusCancelled = Color(0xFFF44336);

  // Gradient Colors — brand magenta → navy (logo palette)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFC2185B), Color(0xFF1A3558)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Orange accent gradient (login screen / CTAs)
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFF4511E), Color(0xFFFF8F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Pet Category Colors (from logo)
  static const Color catColor = Color(0xFFC2185B); // Magenta — matches logo cat
  static const Color dogColor = Color(0xFFF4511E); // Orange — matches logo dog
  static const Color birdColor = Color(0xFF1A3558); // Navy — matches logo horse
  static const Color otherColor = Color(0xFF9E9E9E);
}
