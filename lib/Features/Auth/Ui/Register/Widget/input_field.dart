import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Widget/custom_text_field.dart';


class InputField extends StatelessWidget {

  final String titleName;
  final String hint;
  final TextEditingController controller;
  final bool? isObscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String? value)?onChanged;
  const InputField({

    super.key,
    this.onChanged,
    required this.titleName,
    required this.hint,
    required this.controller,
    this.isObscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator
  });


  @override
  Widget build(BuildContext context) {


    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(titleName
          ,style: AppStyle.regular16RobotoBlack,),
        SizedBox(
          height: 8.h,
        ),
        MyTextFormField(
          onChange: onChanged,
           controller: controller
          ,hint: hint
          ,backGroundColor: AppColor.offWhite,
           prefixIcon: prefixIcon,icon: suffixIcon
          ,obscureText: isObscureText,
           validator: validator
        ),

        SizedBox(
          height: 16.h,
        ),

      ],
    );
  }
}