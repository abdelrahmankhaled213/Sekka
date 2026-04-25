import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';

class InstructionTellAboutYourself extends StatelessWidget {

  const InstructionTellAboutYourself({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
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
          Container(
            color: AppColor.main,
            height: 120.h,
            width: 5.w,
          ),

          SizedBox(
            width: 16.w,
          ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.yourProfileHelpUsProvide,


                style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 14.sp
                )),

            Text(context.l10n.personalizedRouteSuggestionsAnd,


                style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 14.sp
                )),

            Text(context.l10n.notifications,


                style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 14.sp
                )),


          ],
        )
        ],
      ),
    );
  }
}
