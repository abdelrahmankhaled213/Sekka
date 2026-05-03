import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Constants/app_text.dart';
import 'signup_form.dart';

class PhoneOrEmail extends StatelessWidget {
  final SignUpMethod method;
  final ValueChanged<SignUpMethod> onChanged;

  const PhoneOrEmail({
    super.key,
    required this.method,
    required this.onChanged,
  });

  List<BoxShadow> get _shadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      offset: Offset(0, 4),
      blurRadius: 6.r,
      spreadRadius: -1.r,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      offset: Offset(0, 2),
      blurRadius: 4.r,
      spreadRadius: -2.r,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.offWhite,
      ),
      height: 80.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOption(SignUpMethod.email, AppText.email, Icons.mail),
          _buildOption(SignUpMethod.phone, AppText.phone, Icons.phone),
        ],
      ),
    );
  }

  Widget _buildOption(SignUpMethod value, String text, IconData icon) {

    final isSelected = value == method;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          height: 72.h,
          decoration: BoxDecoration(
            boxShadow: isSelected ? _shadow : null,
            color: isSelected ? Colors.white : AppColor.offWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: isSelected ? AppColor.main : Colors.transparent),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 20.sp, color: isSelected ? AppColor.main : AppColor.grey),
              SizedBox(height: 8.h),
              Text(
                text,
                style: isSelected
                    ? AppStyle.regular16RobotoGrey.copyWith(color: AppColor.main)
                    : AppStyle.regular16RobotoGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}