import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Localization/app_localizations.dart';

class PasswordRecoveryText extends StatelessWidget {

  const PasswordRecoveryText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(
          horizontal: 8.sp,
          vertical: 3.sp
      ),
      decoration: BoxDecoration(
        color: AppColor.offWhite,
        borderRadius: BorderRadius.circular(20.r),

      ),
      child: Row(
        children: [
          Icon(Icons.key,size: 25.sp,color: AppColor.main,),
          SizedBox(
            width: 8.w,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width-150.w,
            child: Text(context.l10n.passwordRecoveryText
                ,textAlign: TextAlign.start,

                style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 14.sp
                )),
          )
        ],
      ),
    );
  }
}
