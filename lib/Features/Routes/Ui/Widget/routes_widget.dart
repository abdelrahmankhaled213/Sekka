import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/segment_header.dart';
import 'package:sekka/Features/Routes/Ui/Widget/stop_item.dart';

class RouteWidget extends StatelessWidget {

  final SegmentModel segment;

  const RouteWidget({super.key, required this.segment});

  @override
  Widget build(BuildContext context) {

    final previewStops = segment.previewStops;

    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
border: Border.all(
  color: AppColor.grey.withOpacity(0.2),
  width: 2
),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
      
          SegmentHeader(segment: segment),
      
          ListView.builder(
            itemCount: previewStops.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) {
              final stop = previewStops[i];
              return StopItem(stop: stop);
            },
          ),
      
          if (segment.hasMoreStops)
            _ViewFullTripButton(segment: segment),
        ],
      ),
    );
  }
}

class _ViewFullTripButton extends StatelessWidget {

  final SegmentModel segment;

  const _ViewFullTripButton({required this.segment});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      
      onPressed: () => _openFullTrip(context),
      child: Text("View trip (${segment.stops.length} stations)",style: AppStyle.regular16RobotoBlack.copyWith(

        color: context.read<RoutesCubit>().state.selectedTransportSwitching?.color1??AppColor.darkBlue
      ),),
    );
  }

  void _openFullTrip(BuildContext context) {
    
    final cubit = context.read<RoutesCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(value:cubit , child: FullTripSheet(segment: segment)),
    );
  }
}
class FullTripSheet extends StatelessWidget {
  final SegmentModel segment;

  const FullTripSheet({super.key, required this.segment});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              /// handle
              Container(
                width: 40.w,
                height: 5.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              Text(
                "Full Trip (${segment.stops.length} stations)",
                style: AppStyle.regular16RobotoBlack,
              ),

              SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: segment.stops.length,
                  itemBuilder: (_, i) {
                    return StopItem(stop: segment.stops[i]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}