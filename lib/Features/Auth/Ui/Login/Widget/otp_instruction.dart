import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';

class OtpInstruction extends StatelessWidget {

  const OtpInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(
        horizontal: 8.sp,
        vertical: 10.sp
      ),
      decoration: BoxDecoration(
        color: AppColor.offWhite,
        borderRadius: BorderRadius.circular(20.r),
        
      ),
      child: Row(
        children: [
          Icon(Icons.phone,size: 25.sp,color: AppColor.main,),
          SizedBox(
            width: 8.w,
          ),
          Text(AppText.otpInstruction
            ,textAlign: TextAlign.center,

            style: AppStyle.regular16RobotoGrey.copyWith(
                fontSize: 14.sp
              ))
        ],
      ),
    );
  }
}
