import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Reusable button widget with multiple variants
enum AppButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  gradient,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;
  final bool isLoading;
  final IconData? icon;
  final Widget? child;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.fullWidth = false,
    this.isLoading = false,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: _buildButton(context, isDisabled),
    );
  }

  Widget _buildButton(BuildContext context, bool isDisabled) {
    switch (variant) {
      case AppButtonVariant.primary:
        return _buildPrimaryButton(context, isDisabled);
      case AppButtonVariant.secondary:
        return _buildSecondaryButton(context, isDisabled);
      case AppButtonVariant.outlined:
        return _buildOutlinedButton(context, isDisabled);
      case AppButtonVariant.text:
        return _buildTextButton(context, isDisabled);
      case AppButtonVariant.gradient:
        return _buildGradientButton(context, isDisabled);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.grey,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allLG,
        ),
        elevation: 0,
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.grey,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allLG,
        ),
        elevation: 0,
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isDisabled) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.grey,
        side: BorderSide(
          color: isDisabled ? AppColors.grey : AppColors.primary,
        ),
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allLG,
        ),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDisabled) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.grey,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allMD,
        ),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildGradientButton(BuildContext context, bool isDisabled) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDisabled
            ? null
            : const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary, AppColors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDisabled ? AppColors.grey : null,
        borderRadius: AppRadius.allLG,
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allLG,
          ),
          elevation: 0,
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    final textStyle = _getTextStyle(context);

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          SizedBox(width: AppSpacing.sm),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case AppButtonSize.small:
        return AppTextStyles.labelMedium(context);
      case AppButtonSize.medium:
        return AppTextStyles.labelLarge(context);
      case AppButtonSize.large:
        return AppTextStyles.button(context);
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16.sp;
      case AppButtonSize.medium:
        return 18.sp;
      case AppButtonSize.large:
        return 20.sp;
    }
  }
}
