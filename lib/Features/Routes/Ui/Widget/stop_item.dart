import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';

class StopItem extends StatelessWidget {

  final StepModel stop;
  final bool isLast;

  const StopItem({
    super.key,
    required this.stop,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            children: [

              Container(
                width: 14.w,
                height: 14.h,
                decoration:  BoxDecoration(
                  color: context.read<RoutesCubit>().state.selectedTransportSwitching?.color1??AppColor.darkBlue,
                  shape: BoxShape.circle,
                ),
              ),

            
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color:context.read<RoutesCubit>().state.selectedTransportSwitching?.color1??AppColor.darkBlue,
                  ),
                ),
            ],
          ),

           SizedBox(width: 12.w),

        
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(bottom: 24.h),
              child: Text(
                stop.stopName,
                style: AppStyle.regular16RobotoBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}