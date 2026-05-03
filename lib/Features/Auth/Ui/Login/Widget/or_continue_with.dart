import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';

class ContinueWithDivider extends StatelessWidget {

  const ContinueWithDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding:  EdgeInsets.symmetric(horizontal:
      16.w
      ),
      child: Row(
        children: [
           Expanded(
            child: Divider(

              height: 12.h,
              thickness: 1.5,
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              AppText.orContinueWith,
              style: AppStyle.bold14RobotoBlue.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColor.black
              )
            ),
          ),
          Expanded(
            child: Divider(

              height: 12.h,
              thickness: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
