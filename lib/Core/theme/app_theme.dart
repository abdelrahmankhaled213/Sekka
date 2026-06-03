import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// App theme configuration with light and dark mode support
class AppTheme {
  AppTheme._();

  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.md,
  );

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.lightOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.lightOnSecondary,
        error: AppColors.lightError,
        onError: AppColors.lightOnError,
        background: AppColors.lightBackground,
        onBackground: AppColors.lightOnBackground,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: AppColors.lightBackground,
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge(context),
        iconTheme: const IconThemeData(
          color: AppColors.lightOnSurface,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allLG,
        ),
        margin: AppSpacing.horizontalLG,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: _buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allLG,
          ),
          textStyle: AppTextStyles.button(context),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: AppSpacing.horizontalMD,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allMD,
          ),
          textStyle: AppTextStyles.labelLarge(context),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: _buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allLG,
          ),
          textStyle: AppTextStyles.button(context),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: TextStyle(
          color: AppColors.grey,
          fontSize: 14.sp,
          fontFamily: 'Roboto',
        ),
      ),
      
      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headlineLarge(context),
        displayMedium: AppTextStyles.headlineMedium(context),
        displaySmall: AppTextStyles.headlineSmall(context),
        headlineLarge: AppTextStyles.headlineLarge(context),
        headlineMedium: AppTextStyles.headlineMedium(context),
        headlineSmall: AppTextStyles.headlineSmall(context),
        titleLarge: AppTextStyles.titleLarge(context),
        titleMedium: AppTextStyles.titleMedium(context),
        titleSmall: AppTextStyles.titleSmall(context),
        bodyLarge: AppTextStyles.bodyLarge(context),
        bodyMedium: AppTextStyles.bodyMedium(context),
        bodySmall: AppTextStyles.bodySmall(context),
        labelLarge: AppTextStyles.labelLarge(context),
        labelMedium: AppTextStyles.labelMedium(context),
        labelSmall: AppTextStyles.labelSmall(context),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.grey,
        size: 24,
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allXL,
        ),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.darkOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.darkOnSecondary,
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkOnBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge(context),
        iconTheme: const IconThemeData(
          color: AppColors.darkOnSurface,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allLG,
        ),
        margin: AppSpacing.horizontalLG,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: _buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allLG,
          ),
          textStyle: AppTextStyles.button(context),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: AppSpacing.horizontalMD,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allMD,
          ),
          textStyle: AppTextStyles.labelLarge(context),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: _buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allLG,
          ),
          textStyle: AppTextStyles.button(context),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLG,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: TextStyle(
          color: AppColors.grey,
          fontSize: 14.sp,
          fontFamily: 'Roboto',
        ),
      ),
      
      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headlineLarge(context),
        displayMedium: AppTextStyles.headlineMedium(context),
        displaySmall: AppTextStyles.headlineSmall(context),
        headlineLarge: AppTextStyles.headlineLarge(context),
        headlineMedium: AppTextStyles.headlineMedium(context),
        headlineSmall: AppTextStyles.headlineSmall(context),
        titleLarge: AppTextStyles.titleLarge(context),
        titleMedium: AppTextStyles.titleMedium(context),
        titleSmall: AppTextStyles.titleSmall(context),
        bodyLarge: AppTextStyles.bodyLarge(context),
        bodyMedium: AppTextStyles.bodyMedium(context),
        bodySmall: AppTextStyles.bodySmall(context),
        labelLarge: AppTextStyles.labelLarge(context),
        labelMedium: AppTextStyles.labelMedium(context),
        labelSmall: AppTextStyles.labelSmall(context),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.grey,
        size: 24,
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allXL,
        ),
      ),
    );
  }
}
