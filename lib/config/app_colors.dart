import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color darkGreen = Color(0xFF1B5E20);

  static const Color backgroundGradientStart = Color(0xFF2E7D32);
  static const Color backgroundGradientMiddle = Color(0xFF4CAF50);
  static const Color backgroundGradientEnd = Color(0xFF81C784);

  static const Color textPrimary = Color(0xFF1B5E20);
  static const Color textSecondary = Color(0xFF2E7D32);
  static const Color textLight = Color(0xFF4CAF50);

  static const Color cardBackground = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundGradientStart,
      backgroundGradientMiddle,
      backgroundGradientEnd,
    ],
  );
}


