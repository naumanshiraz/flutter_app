import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand gradient (primary CTA buttons, accents)
  static const Color primaryStart = Color(0xFFFF4D1C); // vivid red-orange
  static const Color primaryEnd = Color(0xFFFF9A1E); // warm orange
  static const Color primary = Color(0xFFFF5722);
  static const Color secondary = Color(0xFFF3F4F6);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryStart, primaryEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Neutrals
  static const Color textPrimary = Color(0xFF0D1B2A); // near-black navy
  static const Color textSecondary = Color(0xFF8A94A6); // muted gray
  static const Color textBlack = Color(0xFF1F2A37);
  static const Color textGrey = Color(0xFFF3F4F6);
  static const Color textDarkGrey = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE1E4EA);
  static const Color inputBackground = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF1FAE59);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);

  // Overlays
  static const Color modalScrim = Color(0x99000000);
  static const Color disabled = Color(0xFFBFC5D2);
}
