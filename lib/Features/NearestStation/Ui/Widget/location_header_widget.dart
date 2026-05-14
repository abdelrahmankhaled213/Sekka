import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class LocationHeaderWidget extends StatelessWidget {
  final String locationName;

  const LocationHeaderWidget({super.key, required this.locationName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondary, AppColor.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),
          Positioned(
            top: 45.h,
            left: 45.w,
            child: _Dot(color: AppColor.secondary),
          ),
          Positioned(
            top: 75.h,
            right: 65.w,
            child: _Dot(color: AppColor.primaryColor),
          ),
          Positioned(
            top: 130.h,
            right: 35.w,
            child: _Dot(color: AppColor.lightGreen, size: 13),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 62.w,
                    height: 62.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.navigation_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Your Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    locationName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({required this.color, this.size = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.5), blurRadius: 6),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.8;
    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
