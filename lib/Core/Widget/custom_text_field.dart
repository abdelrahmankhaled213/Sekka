import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';

import '../Constants/app_color.dart';

class MyTextFormField extends StatelessWidget {

  final EdgeInsets? contentPadding;
  final TextEditingController? controller;
  final InputBorder? enabledBorder;
  final InputBorder?focusedBorder;
  final  TextStyle? hintStyle;
  final bool? obscureText;
  final Widget? icon;
  final Widget? prefixIcon;
  final Color? backGroundColor;
  final String? Function(String?)? validator;
  final void Function(String?) ? onChange;
  final bool ? focus;
  final String hint;
  const MyTextFormField({

    super.key,
    this.prefixIcon,
    this.backGroundColor,
    required this.controller,
    this.onChange,
    this.icon,
    this.contentPadding,
    this.enabledBorder,
    this.focusedBorder,
    this.obscureText,
    this.hintStyle,
    this.validator,
    this.focus,
    required this.hint
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:60.h ,
      child: TextFormField(
        onChanged: onChange,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
hintText: hint,
            hintStyle: AppStyle.regular16RobotoGrey,
            filled: backGroundColor == null ? false : true,
            fillColor: backGroundColor,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(
                horizontal: 16.w,vertical: 20.h),
            enabledBorder: enabledBorder??
                OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColor.borderColor.withOpacity(0.2),
                      width: 1.17
                    ),
                    borderRadius: BorderRadius.circular(16)
                ),
            focusedBorder: focusedBorder ??OutlineInputBorder(
              borderSide:  BorderSide(
                color: AppColor.borderColor.withOpacity(0.2),
                width: 1.17,

              ),
              borderRadius: BorderRadius.circular(16),
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.3
                ),

                borderRadius: BorderRadius.circular(16)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.3
                ),
                borderRadius: BorderRadius.circular(16)
            ),

            suffixIcon: icon,
          prefixIcon:prefixIcon
        ),

        obscureText: obscureText ?? false,

        canRequestFocus: focus??true,

        style: AppStyle.regular16RobotoGrey
      ),
    );
  }

}

