import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
class OtpSecurityRule extends StatelessWidget {

  const OtpSecurityRule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.sp,
          vertical: 10.sp
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),

        ),
        child: _buildColumn(),
      ),
    );
  }

  Column _buildColumn() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(
          children: [
            Icon(Icons.security,size: 20.sp,color: Colors.green,),
      SizedBox(
      width: 5.w,
      ),
      Text(AppText.secureVerification,style: AppStyle.bold14RobotoBlue.copyWith(
    fontWeight: FontWeight.w400,
      color: AppColor.black
      ),)

          ],
        ),
          SizedBox(
            height: 8.h,
          ),
Text(AppText.secureVerificationDesc,style:
AppStyle.regular16RobotoBlack.copyWith(
fontSize: 14.sp
),)
         ] );
  }
}
