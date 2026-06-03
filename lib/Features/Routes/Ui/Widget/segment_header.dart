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
    final cubit       = context.read<RoutesCubit>();
    final accentColor = cubit.state.selectedTransportSwitching?.color1 
                        ?? AppColor.darkBlue;

    // ✅ price و time من الـ getters اللي أضفناهم في SegmentModel
    final price    = segment.ticketPrice;
    final duration = segment.durationMinutes;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Line info row ──────────────────────────────────────
          Row(
            children: [
              Icon(TransportUIHelper.icon(segment.type),
                  color: accentColor, size: 22.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          segment.lineName ?? '',
                          style: AppStyle.regular16RobotoBlack.copyWith(
                              color: accentColor),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          segment.direction ?? '',
                          style: AppStyle.regular16RobotoGrey
                              .copyWith(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${segment.stopsCount} stations',
                      style: AppStyle.regular16RobotoGrey
                          .copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),
          Divider(color: accentColor.withOpacity(0.2), height: 1),
          SizedBox(height: 10.h),

          // ── Price & Time row ───────────────────────────────────
          Row(
            children: [
              // Price chip
              _InfoChip(
                icon:  Icons.confirmation_num_outlined,
                label: price == 0 ? 'Free' : 'EGP ${price.toStringAsFixed(0)}',
                color: accentColor,
              ),
              SizedBox(width: 10.w),
              // Duration chip
              _InfoChip(
                icon:  Icons.schedule_rounded,
                label: duration < 60
                    ? '$duration min'
                    : '${duration ~/ 60}h ${duration % 60}min',
                color: accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border:       Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: color),
          SizedBox(width: 5.w),
          Text(
            label,
            style: AppStyle.regular16RobotoBlack.copyWith(
              fontSize:   12.sp,
              fontWeight: FontWeight.w600,
              color:      color,
            ),
          ),
        ],
      ),
    );
  }
}