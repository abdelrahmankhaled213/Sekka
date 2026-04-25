import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';

class ItemInfoCardWidget extends StatelessWidget {

  final String station;
  final String description;

  const ItemInfoCardWidget({
    super.key,
    required this.station,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin:  EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      padding:  EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(),
           SizedBox(height: 8.h),
          Text(
            description,
            style: AppStyle.regular16RobotoBlack.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(){
return Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 15.sp,
                color: AppColor.secondary,
              ),
              const SizedBox(width: 5),
              Text(
                station,
                style: AppStyle.regular16RobotoBlack.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.secondary,
                ),
              ),
            ],
          );
          
  }
}
