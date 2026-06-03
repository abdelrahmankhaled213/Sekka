import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class StationShimmerCard extends StatefulWidget {
  
  const StationShimmerCard({super.key});

  @override
  State<StationShimmerCard> createState() => _StationShimmerCardState();
}

class _StationShimmerCardState extends State<StationShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<double> _anim = Tween(begin: 0.3, end: 0.8)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(32.w, 32.w, radius: 10.r),
            SizedBox(height: 10.h),
            _box(100.w, 12.h),
            SizedBox(height: 6.h),
            _box(70.w, 10.h),
            SizedBox(height: 10.h),
            _box(50.w, 10.h),
          ],
        ),
      ),
    );
  }

  Widget _box(double w, double h, {double? radius}) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: AppColor.outline.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(radius ?? 6.r),
        ),
      );
}
