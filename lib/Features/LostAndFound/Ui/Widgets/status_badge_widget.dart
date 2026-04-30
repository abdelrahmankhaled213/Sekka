import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/core/constants/app_color.dart';
import 'package:sekka/core/constants/app_style.dart';

enum PostStatus { lost, found, active, resolved, claimed }

class StatusBadgeWidget extends StatelessWidget {
  
  final PostStatus status;
  final double fontSize;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {

    final config = _getConfig(status);
    
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: (config['color'] as Color).withAlpha(77),
          width: 1,
        ),
      ),
      child: Text(
        config['label'] as String,
        style: AppStyle.regular24RobotoBlack.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: config['color'] as Color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Map<String, dynamic> _getConfig(PostStatus status) {
    switch (status) {
      case PostStatus.lost:
        return {
          'label': 'Lost',
          'color': AppColor.error,
          'bg': AppColor.errorContainer,
        };
      case PostStatus.found:
        return {
          'label': 'Found',
          'color': AppColor.success,
          'bg': AppColor.successContainer,
        };
      case PostStatus.active:
        return {
          'label': 'Active',
          'color': AppColor.secondary,
          'bg': AppColor.surface,
        };
      case PostStatus.resolved:
        return {
          'label': 'Resolved',
          'color': AppColor.muted,
          'bg': const Color(0xFFF3F4F6),
        };
      case PostStatus.claimed:
        return {
          'label': 'Claimed',
          'color': AppColor.warning,
          'bg': AppColor.warningContainer,
        };
    }
  }
}
