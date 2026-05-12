import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/segment_header.dart';
import 'package:sekka/Features/Routes/Ui/Widget/stop_item.dart';
import 'package:sekka/Features/Routes/Ui/Widget/transfer.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';

class RouteWidget extends StatelessWidget {
  final SegmentModel segment;

  /// Pass [true] for the last segment — shows "Arrive at …" badge instead of transfer pill.
  final bool isLastSegment;

  const RouteWidget({
    super.key,
    required this.segment,
    this.isLastSegment = false,
  });

  Color _accentColor(BuildContext context) {
    return context
            .read<RoutesCubit>()
            .state
            .selectedTransportSwitching
            ?.color1 ??
        _segmentAccent;
  }

  Color get _segmentAccent {
    switch (segment.type) {
      case TransportType.metro:
        return AppColor.darkBlue;
      case TransportType.bus:
        return AppColor.darkGreen;
      case TransportType.monorail:
        return AppColor.darkPurple;
      case TransportType.microbus:
        return AppColor.orange;
      default:
        return AppColor.darkGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewStops = segment.previewStops;
    final accent = _accentColor(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────
          SegmentHeader(segment: segment),

          // ── Preview stops ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 4.h),
            child: ListView.builder(
              itemCount: previewStops.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => StopItem(
                stop: previewStops[i],
                isFirst: i == 0,
                isLast: i == previewStops.length - 1 && !segment.hasMoreStops,
              ),
            ),
          ),

          // ── View all stops ──────────────────────────────────────────
          if (segment.hasMoreStops)
            _ViewAllStopsButton(segment: segment, accentColor: accent),

          // ── Footer: transfer pill OR arrived badge ─────────────────
          if (!isLastSegment && segment.transferAtStop != null)
            TransferWidget(segment: segment)
          else
            _TripStatusFooter(
              isLastSegment: isLastSegment,
              destinationName: segment.stops.last.stopName,
              accentColor: accent,
            ),

          SizedBox(height: 6.h),
        ],
      ),
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
      onTap: () => _openFullTrip(context),
      child: Container(
        margin: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 0),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.withOpacity(0.12), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline_rounded, size: 14, color: accentColor),
            SizedBox(width: 6.w),
            Text(
              'View all ${segment.stops.length} stops',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullTrip(BuildContext context) {
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
// Trip status footer — only shown on last segment
// ─────────────────────────────────────────────────────────────────────────────

class _TripStatusFooter extends StatelessWidget {
  final bool isLastSegment;
  final String destinationName;
  final Color accentColor;

  const _TripStatusFooter({
    required this.isLastSegment,
    required this.destinationName,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLastSegment) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 4.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: accentColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.flag_rounded, size: 14.sp, color: Colors.white),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You have arrived',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  destinationName,
                  style: TextStyle(
                    fontSize: 11,
                    color: accentColor.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: accentColor, size: 18.sp),
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

  Color get _accentColor {
    switch (segment.type) {
      case TransportType.metro:
        return AppColor.darkBlue;
      case TransportType.bus:
        return AppColor.darkGreen;
      case TransportType.microbus:
        return AppColor.orange;
      case TransportType.monorail:
        return AppColor.darkPurple;
      default:
        return AppColor.darkGreen;
    }
  }

  Color get _bgColor {
    switch (segment.type) {
      case TransportType.metro:
      case TransportType.microbus:
      case TransportType.monorail:
        return const Color(0xFFE8F0FB);
      case TransportType.bus:
        return const Color(0xFFE8F5EE);
      default:
        return const Color(0xFFE8F5EE);
    }
  }

  IconData get _icon {
    switch (segment.type) {
      case TransportType.metro:
        return Icons.directions_subway_rounded;
      case TransportType.monorail:
        return Icons.directions_railway_rounded;
      case TransportType.microbus:
        return Icons.airport_shuttle_rounded;
      case TransportType.bus:
      default:
        return Icons.directions_bus_rounded;
    }
  }

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
            borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 12.h, bottom: 14.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: _bgColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(_icon, color: _accentColor, size: 14),
                          SizedBox(width: 5.w),
                          Text(
                            segment.lineName ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${segment.stops.length} stops',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14.h),
              Divider(color: Colors.grey.withOpacity(0.1), height: 1),

              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  itemCount: segment.stops.length,
                  itemBuilder: (_, i) => StopItem(
                    stop: segment.stops[i],
                    isFirst: i == 0,
                    isLast: i == segment.stops.length - 1,
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