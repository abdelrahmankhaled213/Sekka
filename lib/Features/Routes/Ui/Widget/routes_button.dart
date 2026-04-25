
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';
class RoutesButton extends StatelessWidget {
  
  final VoidCallback onPressed;
  final String label;
  final Gradient gradient;

  const RoutesButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290.w,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.bolt, color: Colors.white),
        label: Text(
          label,
          style: AppStyle.regular16RobotoBlack.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 

          shape: RoundedRectangleBorder(
            
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}