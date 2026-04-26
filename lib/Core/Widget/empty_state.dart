import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88.w,
              height: 88.h,
              decoration: BoxDecoration(
                color: AppColor.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40.sp, color: AppColor.secondary),
            ),
             SizedBox(height: 20.h),
            Text(
              title,
              style: AppStyle.bold14RobotoBlue.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: 8.h),
            Text(
              description,
              style: AppStyle.regular16RobotoGrey.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCta != null) ...[
               SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onCta,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
