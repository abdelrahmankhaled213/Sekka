import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Reusable card widget with multiple variants
enum AppCardVariant {
  elevated,
  outlined,
  filled,
}

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMargin = margin ?? AppSpacing.horizontalLG;
    final effectivePadding = padding ?? AppSpacing.allLG;
    final effectiveBackgroundColor = backgroundColor ?? _getDefaultBackgroundColor();
    final effectiveElevation = elevation ?? _getDefaultElevation();

    Widget cardContent = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: AppRadius.allLG,
        border: _getBorder(),
        boxShadow: _getBoxShadow(effectiveElevation),
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allLG,
        child: cardContent,
      );
    }

    return Padding(
      padding: effectiveMargin,
      child: cardContent,
    );
  }

  Color _getDefaultBackgroundColor() {
    switch (variant) {
      case AppCardVariant.elevated:
        return AppColors.surface;
      case AppCardVariant.outlined:
        return Colors.transparent;
      case AppCardVariant.filled:
        return AppColors.surfaceVariant;
    }
  }

  double _getDefaultElevation() {
    switch (variant) {
      case AppCardVariant.elevated:
        return 2;
      case AppCardVariant.outlined:
        return 0;
      case AppCardVariant.filled:
        return 0;
    }
  }

  BoxBorder? _getBorder() {
    switch (variant) {
      case AppCardVariant.elevated:
        return null;
      case AppCardVariant.outlined:
        return Border.all(color: AppColors.border);
      case AppCardVariant.filled:
        return null;
    }
  }

  List<BoxShadow>? _getBoxShadow(double elevation) {
    if (elevation == 0) return null;

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
