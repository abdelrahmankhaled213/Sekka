import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/app_regex_helper.dart';
import 'package:sekka/Features/Auth/Ui/Register/Widget/password_restriction.dart';

class AllPasswordRestrictions extends StatelessWidget {

  final AppRegexUpdates appRegexUpdates;

  const AllPasswordRestrictions({super.key,required this.appRegexUpdates});

  @override
  Widget build(BuildContext context) {
    return  Column(

      children: [

        PasswordRestriction(text: AppText.validationTextLength
          , hasValidated: appRegexUpdates.minLength,),

        SizedBox(
          height: 3.h,
        ),

        PasswordRestriction(text: AppText.validationLowerCase
          , hasValidated: appRegexUpdates.isLowerCase,),

        SizedBox(
          height: 3.h,
        ),

        PasswordRestriction(text: AppText.validationUpperCase
          , hasValidated: appRegexUpdates.isUpperCase,),

        SizedBox(
          height: 3.h,
        ),

        PasswordRestriction(text: AppText.validationNumber
          , hasValidated: appRegexUpdates.hasNumber,),


        SizedBox(
          height: 3.h,
        ),

        PasswordRestriction(text: AppText.validationSpecialCharacter
          , hasValidated: appRegexUpdates.isSpecialCharacter,),

      ],
    );
  }
}
