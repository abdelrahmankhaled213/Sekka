import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Constants/app_style.dart';

class TermsAndConditions extends StatelessWidget {

  final String text;

  final String text2;

  const TermsAndConditions({ super.key
    ,required this.text, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        TextSpan(
            children: [
              TextSpan(
                  text: '$text\t',
                  style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 14.sp
                  )
              ),
              TextSpan(
                  text: '$text2\t',
                  style: AppStyle.bold14RobotoBlue

              ),
            ]
        )
    );
  }
}