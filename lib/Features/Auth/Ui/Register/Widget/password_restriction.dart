import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';

import '../../../../../Core/Constants/app_style.dart';

class PasswordRestriction extends StatelessWidget {

  final String text;

  final bool hasValidated;

  const PasswordRestriction({super.key,required this.text
    ,required this.hasValidated});

  @override
  Widget build(BuildContext context) {
      return Row(
      children: [
        CircleAvatar(
          radius: 3,
          backgroundColor: hasValidated ? AppColor.main : AppColor.grey,
        ),
        SizedBox(
          width: 6.w,
        ),
        Text(
          text,
          style: AppStyle.regular16RobotoGrey.copyWith(
            fontSize: 14.sp,
            color: hasValidated ? AppColor.main : AppColor.grey,
            decoration: hasValidated ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: AppColor.main,
            decorationThickness: 2.0,
          ),
        )
      ],
    );
  }
}
