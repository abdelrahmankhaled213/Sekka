import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';

class HomeStatsWidget extends StatelessWidget {
  final int lostCount;
  final int foundCount;

  const HomeStatsWidget({
    super.key,
    required this.lostCount,
    required this.foundCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16.h, 0.w, 16.h, 12.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '$lostCount',
              'Lost Items',
              AppColor.error,
              AppColor.errorContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '$foundCount',
              'Found Items',
              AppColor.success,
              AppColor.successContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String count,
    String label,
    Color textColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: textColor.withAlpha(51), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: AppStyle.regular16RobotoBlack.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: textColor,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppStyle.regular16RobotoBlack.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: textColor.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }
}
