import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/Constants/app_color.dart';

class CustomLinearProgress extends StatelessWidget {

  final double value;

  const CustomLinearProgress({super.key,required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.sp),
      child: SizedBox(
        height: 10.sp,
        child: Stack(
          children: [

            Container(color: Colors.white),
            FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.main,
                      AppColor.secondary,
                      AppColor.pink,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
