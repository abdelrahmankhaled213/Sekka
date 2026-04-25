import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Helper/transport_color_helper.dart';
import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../Logic/transport_model.dart';

class TransportCard extends StatelessWidget {

  final TransportModel model;
  final VoidCallback onTap;

  const TransportCard({
    super.key,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(18.sp),
        decoration: _decoration,
        child: Row(
          children: [
            _IconBox(model: model),
            SizedBox(width: 16.w),
            Expanded(child: _Texts(model: model)),
            _SelectionIndicator(isSelected: model.isSelected),
          ],
        ),
      ),
    );
  }

  BoxDecoration get _decoration => BoxDecoration(
    color: TransportColorsHelper.background(model.isSelected),
    borderRadius: BorderRadius.circular(20.r),
    border: Border.all(
      color: TransportColorsHelper.border(model.isSelected),
      width: 1.5,
    ),
  );
}
class _IconBox extends StatelessWidget {

  final TransportModel model;

  const _IconBox({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: TransportColorsHelper.iconBackground(model.type),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Icon(model.icon
        ,size: 25.sp,color: Colors.white,),
      ),
    );
  }
}
class _Texts extends StatelessWidget {
  final TransportModel model;

  const _Texts({required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(model.title, style: AppStyle.regular16RobotoBlack),
        SizedBox(height: 4.h),
        Text(
          model.subtitle,
          style: AppStyle.regular16RobotoGrey.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}
class _SelectionIndicator extends StatelessWidget {
  final bool isSelected;

  const _SelectionIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColor.main : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColor.main : Colors.grey,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16.sp, color: Colors.white)
          : null,
    );
  }
}