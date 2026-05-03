import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';

class SegmentHeader extends StatelessWidget {
  
  final SegmentModel segment;

  const SegmentHeader({super.key, required this.segment});

  @override
  Widget build(BuildContext context) {
    
    final cubit = context.read<RoutesCubit>();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: cubit.state.selectedTransportSwitching?.color1.withOpacity(0.1)??AppColor.darkBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: cubit.state.selectedTransportSwitching?.color1??AppColor.darkBlue,
          width: 2,
        ),
      ),
      child: Row(
        children: [

          Icon(
            TransportUIHelper.icon(segment.type),
            color: cubit.state.selectedTransportSwitching?.color1??AppColor.darkBlue,
            size: 22.sp,
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
            Row( 
               children:  [ 
                
                Text(
                  segment.lineName??'' ,
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    color: cubit.state.selectedTransportSwitching?.color1??AppColor.darkBlue,
                  ),
                ),

SizedBox(width: 10.w),

Text(segment.direction??'', style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 12.sp
                  ),),


               ] ),
               
                SizedBox(height: 4.h),

                Text(
                  "${segment.stops.length} stations",
                  style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 12.sp
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}