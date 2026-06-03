import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Reusable loading widget with multiple variants
enum AppLoadingVariant {
  circular,
  linear,
  shimmer,
}

class AppLoading extends StatelessWidget {
  final AppLoadingVariant variant;
  final String? message;
  final Color? color;

  const AppLoading({
    super.key,
    this.variant = AppLoadingVariant.circular,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    switch (variant) {
      case AppLoadingVariant.circular:
        return _buildCircularLoading(context, effectiveColor);
      case AppLoadingVariant.linear:
        return _buildLinearLoading(context, effectiveColor);
      case AppLoadingVariant.shimmer:
        return _buildShimmerLoading();
    }
  }

  Widget _buildCircularLoading(BuildContext context, Color color) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40.sp,
            height: 40.sp,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTextStyles.bodyMedium(context),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLinearLoading(BuildContext context, Color color) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200.w,
            child: LinearProgressIndicator(
              minHeight: 4.h,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: AppColors.border,
            ),
          ),
          if (message != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTextStyles.bodyMedium(context),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }
}

/// Shimmer loading widget for skeleton screens
class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
    );
  }
}
