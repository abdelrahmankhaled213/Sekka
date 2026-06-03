import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Cubit/trip_tracking_cubit.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
import 'package:sekka/Features/Routes/Ui/Widget/track_trip_button.dart';
import 'package:sekka/core/theme/app_radius.dart';
import 'package:sekka/core/theme/app_spacing.dart';
import 'package:sekka/core/theme/app_text_styles.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/segment_header.dart';
import 'package:sekka/Features/Routes/Ui/Widget/stop_item.dart';
import 'package:sekka/Features/Routes/Ui/Widget/transfer.dart';

class RouteWidget extends StatelessWidget {
  final SegmentModel segment;
  final bool isLastSegment;
  final List<SegmentModel> allSegments; 

  const RouteWidget({
    super.key,
    required this.segment,
    required this.allSegments,
    this.isLastSegment = false,
  });

  @override
  Widget build(BuildContext context) {
    final previewStops = segment.previewStops;

    return Container(
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: AppRadius.allXL,
        border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withAlpha(8),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          SegmentHeader(segment: segment),

           Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl.w, AppSpacing.sm.h,
              AppSpacing.xl.w, AppSpacing.xs.h,
            ),
            child: ListView.builder(
              itemCount:    previewStops.length,
              shrinkWrap:   true,
              physics:      const NeverScrollableScrollPhysics(),
              itemBuilder:  (_, i) => StopItem(
                stop:    previewStops[i],
                isFirst: i == 0,
                isLast:  i == previewStops.length - 1 && !segment.hasMoreStops,
              ),
            ),
          ),
  if (segment.hasMoreStops)
            _ViewAllStopsButton(
                segment:     segment,
                accentColor: AppColor.muted),

          if (!segment.isEnd && segment.transferAtStop != null)
            TransferWidget(segment: segment),

       
          if (isLastSegment)
            _DestinationFooter(
              destinationName: segment.alightingStop,
              accentColor:     AppColor.muted, isLastSegment: isLastSegment,
            ),

       
          if (isLastSegment) ...[
            _TripSummaryBar(segments: allSegments),
            BlocProvider(create: (context) => getIt<TripCubit>(), child: const TrackTripButton()),
          ],

          SizedBox(height: AppSpacing.sm.h),
        ],
      ),
    );
  }
}
class _SegmentsList extends StatelessWidget {
  final List<SegmentModel> segments;
  const _SegmentsList({required this.segments});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap:       true,
      physics:          const NeverScrollableScrollPhysics(),
      itemCount:        segments.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, i) => RouteWidget(
        segment:       segments[i],
        allSegments:   segments,           // ✅
        isLastSegment: i == segments.length - 1,
      ),
    );
  }
}
class _TripSummaryBar extends StatelessWidget {
  final List<SegmentModel> segments;
  const _TripSummaryBar({required this.segments});

  @override
  Widget build(BuildContext context) {
    final totalPrice   = segments.fold(0.0, (s, e) => s + e.ticketPrice);
    final totalMinutes = segments.fold(0,   (s, e) => s + e.durationMinutes);
    final hours        = totalMinutes ~/ 60;
    final mins         = totalMinutes % 60;
    final timeLabel    = hours > 0 ? '${hours}h ${mins}min' : '${mins} min';

    return Container(
      margin:  EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color:        const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            icon:  Icons.confirmation_num_outlined,
            label: 'Total Cost',
            value: 'EGP ${totalPrice.toStringAsFixed(0)}',
            color: AppColor.main,
          ),
          Container(width: 1, height: 30.h, color: Colors.grey.withOpacity(0.2)),
          _SummaryItem(
            icon:  Icons.schedule_rounded,
            label: 'Est. Time',
            value: timeLabel,
            color: AppColor.main,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color    color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: color),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade500,
                    fontFamily: 'Roboto')),
            Text(value,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: 'Roboto')),
          ],
        ),
      ],
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// View all stops button
// ─────────────────────────────────────────────────────────────────────────────

class _ViewAllStopsButton extends StatelessWidget {
  final SegmentModel segment;
  final Color accentColor;

  const _ViewAllStopsButton({
    required this.segment,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullSheet(context),
      child: Container(
        margin: EdgeInsets.fromLTRB(
            AppSpacing.xl.w, AppSpacing.xs.h, AppSpacing.xl.w, 0),
        padding: EdgeInsets.symmetric(
            vertical: AppSpacing.sm.h, horizontal: AppSpacing.md.w),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: AppRadius.allMD,
          border:
              Border.all(color: Colors.grey.withOpacity(0.12), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline_rounded,
                size: 14.sp, color: accentColor),
            SizedBox(width: AppSpacing.sm.w),
            Text(
              'View all ${segment.stops.length} stops',
              style: AppTextStyles.labelSmall(context)
                  .copyWith(color: accentColor),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullSheet(BuildContext context) {
    final cubit = context.read<RoutesCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: FullTripSheet(segment: segment),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Destination footer — بيظهر بس على آخر segment
// ─────────────────────────────────────────────────────────────────────────────

class _DestinationFooter extends StatelessWidget {
  final bool isLastSegment;
  final String destinationName;
  final Color accentColor;

  const _DestinationFooter({
    required this.isLastSegment,
    required this.destinationName,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLastSegment) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.fromLTRB(
          AppSpacing.md.w, AppSpacing.xs.h, AppSpacing.md.w, AppSpacing.xs.h),
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl.w, vertical: AppSpacing.md.h),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.07),
        borderRadius: AppRadius.allLG,
        border: Border.all(color: accentColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.flag_rounded, size: 14.sp, color: Colors.white),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Destination',
                  style: AppTextStyles.labelSmall(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  destinationName,
                  style: AppTextStyles.caption(context).copyWith(
                    color: accentColor.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded,
              color: accentColor, size: 18.sp),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Full trip bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSpacing.xxxl.r)),
          ),
          child: Column(
            children: [
              // handle
              Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(
                    top: AppSpacing.md.h, bottom: AppSpacing.xl.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: AppRadius.allLG,
                ),
              ),

              // header
              Padding(
                padding: AppSpacing.horizontalLG,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md.w,
                          vertical: AppSpacing.xs.h),
                      decoration: BoxDecoration(
                        color: AppColor.muted.withOpacity(0.1),
                        borderRadius: AppRadius.allMD,
                      ),
                      child: Row(
                        children: [
                          Icon(TransportUIHelper.icon(segment.type),
                              color: AppColor.muted, size: 14.sp),
                          SizedBox(width: AppSpacing.sm.w),
                          Text(
                            segment.lineName ?? '',
                            style: AppTextStyles.labelSmall(context).copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColor.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    Text(
                      '${segment.stops.length} stops',
                      style: AppTextStyles.labelSmall(context)
                          .copyWith(color: const Color(0xFF888888)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.xl.h),
              Divider(color: Colors.grey.withOpacity(0.1), height: 1),

              // all stops
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg.w,
                      AppSpacing.sm.h,
                      AppSpacing.lg.w,
                      AppSpacing.xxl.h),
                  itemCount: segment.stops.length,
                  itemBuilder: (_, i) => StopItem(
                    stop:        segment.stops[i],
                    isFirst:     i == 0,
                    isLast:      i == segment.stops.length - 1,
                    
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}