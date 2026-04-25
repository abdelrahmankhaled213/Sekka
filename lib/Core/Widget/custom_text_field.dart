import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';

import '../Constants/app_color.dart';

class MyTextFormField extends StatefulWidget {

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
  final bool? readonly;
  final void Function()? onTap;
  const MyTextFormField({
this.onTap,
    super.key,
    this.readonly,
    this.prefixIcon,
    this.backGroundColor,
     this.controller,
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
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {

   String? errorText;

  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
     children: [

       SizedBox(
        height: 60.h ,
        child: TextFormField(
          onTap: widget.onTap,
          readOnly: widget.readonly??false,
          onChanged: widget.onChange,
          validator:(value) {
            final result=widget.validator?.call(value);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (errorText != result) {
                setState(() {
                  errorText = result;
                });
              }

            });

            return result;
          },
          controller: widget.controller,
            cursorRadius: Radius.circular(8.r),
            cursorErrorColor: AppColor.grey,
            cursorColor: AppColor.grey,
            cursorOpacityAnimates: true,

          decoration: InputDecoration(
errorStyle: TextStyle(
  fontSize: 0,
  height: 0
),

              suffixIconColor: AppColor.grey,
              prefixIconColor: AppColor.grey,
              hintText: widget.hint,
              hintStyle: AppStyle.regular16RobotoGrey,
              filled: widget.backGroundColor == null ? false : true,
              fillColor: widget.backGroundColor,
              contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(
                  horizontal: 16.w,vertical: 20.h),
              enabledBorder: widget.enabledBorder??
                  OutlineInputBorder(
                      borderSide: BorderSide(
                          color: errorText==null?
                          AppColor.borderColor.withOpacity(0.2):
                           AppColor.main,
                          width: 1.3
                                                       ),
                      borderRadius: BorderRadius.circular(16.r)
                  ),
              focusedBorder: widget.focusedBorder ??OutlineInputBorder(
                borderSide:  BorderSide(
                  color: errorText==null?AppColor.borderColor.withOpacity(0.2)
                      :AppColor.main,
                  width: 1.17,

                ),
                borderRadius: BorderRadius.circular(16),
              ),
errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(
        color: AppColor.main,
        width: 1.3
    ),
    borderRadius: BorderRadius.circular(16.r)
),

              focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColor.main,
                      width: 1.3
                  ),
                  borderRadius: BorderRadius.circular(16.r)
              ),

              suffixIcon: widget.icon,
            prefixIcon:widget.prefixIcon
          ),

          obscureText: widget.obscureText ?? false,

          canRequestFocus: widget.focus??true,

          style: AppStyle.regular16RobotoGrey
        ),
      ),
       
       SizedBox(
         height: 4.h,
       ),
       
       AnimatedSwitcher(duration: const Duration(
         milliseconds: 500,
       ),
         child:  errorText == null
             ? const SizedBox()
        : Text(
    errorText!,
    key: ValueKey(errorText),
    style: AppStyle.regular16RobotoGrey.copyWith(
      fontSize: 14.sp,
      color: AppColor.main
    )
    ),
    ),


    ]);
  }
}

