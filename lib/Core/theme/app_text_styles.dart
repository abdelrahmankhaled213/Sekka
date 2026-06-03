import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Typography scale for consistent text styling
class AppTextStyles {
  AppTextStyles._();

  // ==================== Headlines ====================
  
  static TextStyle headlineLarge(BuildContext context) {
    return TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  // ==================== Titles ====================
  
  static TextStyle titleLarge(BuildContext context) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  // ==================== Body ====================
  
  static TextStyle bodyLarge(BuildContext context) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  // ==================== Labels ====================
  
  static TextStyle labelLarge(BuildContext context) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: 'Roboto',
    );
  }

  // ==================== Special Styles ====================
  
  static TextStyle button(BuildContext context) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle caption(BuildContext context) {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      fontFamily: 'Roboto',
    );
  }

  static TextStyle overline(BuildContext context) {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      fontFamily: 'Roboto',
      letterSpacing: 1.5,
    );
  }
}
