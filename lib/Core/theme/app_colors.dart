import 'package:flutter/material.dart';

/// App color palette with light and dark mode support
class AppColors {
  AppColors._();

  // ==================== Brand Colors ====================
  
  /// Primary brand color
  
  static const Color primary = Color(0xFF0EA5E9);
  
  /// Secondary brand color
  static const Color secondary = Color(0xFF8B5CF6);
  
  /// Accent pink color
  static const Color pink = Color(0xFFEC4899);
  
  /// Brand gradient
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, secondary, pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== Semantic Colors ====================
  
  /// Success color
  static const Color success = Color(0xFF16A34A);
  
  /// Success container color
  static const Color successContainer = Color(0xFFDCFCE7);
  
  /// Error color
  static const Color error = Color(0xFFDC2626);
  
  /// Error container color
  static const Color errorContainer = Color(0xFFFEE2E2);
  
  /// Warning color
  static const Color warning = Color(0xFFD97706);
  
  /// Warning container color
  static const Color warningContainer = Color(0xFFFEF3C7);
  
  /// Info color
  static const Color info = Color(0xFF3B82F6);

  // ==================== Neutral Colors ====================
  
  /// Black color
  static const Color black = Color(0xFF0F172A);
  
  /// Grey color
  static const Color grey = Color(0xFF64748B);
  
  /// Off white color
  static const Color offWhite = Color(0xFFF1F5F9);
  
  /// Muted color
  static const Color muted = Color(0xFF9CA3AF);
  
  /// Border color
  static const Color border = Color(0xFF94A3B8);
  
  /// Semi-transparent black
  static const Color semiTransparentBlack = Color(0x14000000);

  // ==================== Surface Colors ====================
  
  /// Surface color
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Surface variant color
  static const Color surfaceVariant = Color(0xFFF8F7FF);
  
  /// Background color
  static const Color background = Color(0xFFF5F4FB);
  
  /// Outline color
  static const Color outline = Color(0xFFE5E7EB);

  // ==================== Text Colors ====================
  
  /// Text primary color
  static const Color textPrimary = Color(0xFF111827);
  
  /// Text secondary color
  static const Color textSecondary = Color(0xFF6B7280);

  // ==================== Transport Colors ====================
  
  /// Light green
  static const Color lightGreen = Color(0xFF00C950);
  
  /// Dark green
  static const Color darkGreen = Color(0xFF008236);
  
  /// Light purple
  static const Color lightPurple = Color(0xFFAD46FF);
  
  /// Dark purple
  static const Color darkPurple = Color(0xFF8200DB);
  
  /// Light blue
  static const Color lightBlue = Color(0xFF2B7FFF);
  
  /// Dark blue
  static const Color darkBlue = Color(0xFF1447E6);
  
  /// Orange
  static const Color orange = Color(0xFFF59E0B);

  // ==================== Light Theme ====================
  
  static const Color lightBackground = Color(0xFFF5F4FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFDC2626);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF111827);
  static const Color lightOnSurface = Color(0xFF111827);

  // ==================== Dark Theme ====================
  
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkError = Color(0xFFF87171);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkOnError = Color(0xFF111827);
  static const Color darkOnBackground = Color(0xFFF1F5F9);
  static const Color darkOnSurface = Color(0xFFF1F5F9);
}
