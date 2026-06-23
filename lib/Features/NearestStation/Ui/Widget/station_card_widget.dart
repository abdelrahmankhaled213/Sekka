import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

class StationCardWidget extends StatelessWidget {
  final NearestStationModel station;
  const StationCardWidget({super.key, required this.station});

  // ── derived values ──────────────────────────────────────────────────────────

  double get _occupancy {
    if (station.totalSeats == null || station.totalSeats == 0) return 0;
    return ((station.occupiedSeats ?? 0) / station.totalSeats!).clamp(0.0, 1.0);
  }

  int get _available {
    if (station.totalSeats == null) return 0;
    return (station.totalSeats! - (station.occupiedSeats ?? 0)).clamp(0, station.totalSeats!);
  }

  bool get _hasCapacityData => station.totalSeats != null && station.totalSeats! > 0;

  // ── bar colour mirrors the crowding badge ───────────────────────────────────

  Color _barColor(CrowdingLevel level) {
    switch (level) {
      case CrowdingLevel.low:     return AppColor.success;
      case CrowdingLevel.medium:  return AppColor.warning;
      case CrowdingLevel.high:    return AppColor.error;
      case CrowdingLevel.unknown: return AppColor.error.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [

          // ── icon ─────────────────────────────────────────────────────────────
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.subway_rounded, color: Colors.white, size: 22.sp),
          ),
          SizedBox(width: 12.w),

          // ── name + distance + occupancy bar ───────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textPrimary,
                    fontFamily: 'Roboto',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${station.distanceKm.toStringAsFixed(2)} km away',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),

                // ── occupancy bar (shown only when data is available) ────────────
                if (_hasCapacityData) ...[
                  SizedBox(height: 8.h),
                  _OccupancyBar(
                    value:    _occupancy,
                    barColor: _barColor(station.crowding),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${(_occupancy * 100).toStringAsFixed(0)}% full',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColor.textSecondary,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // ── right column: crowding badge + available seats ────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _CrowdingBadge(level: station.crowding),
              if (_hasCapacityData) ...[
                SizedBox(height: 6.h),
                _SeatsBadge(available: _available),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── occupancy progress bar ───────────────────────────────────────────────────

class _OccupancyBar extends StatelessWidget {
  final double value;      // 0.0 – 1.0
  final Color  barColor;

  const _OccupancyBar({required this.value, required this.barColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: LinearProgressIndicator(
        value:            value,
        minHeight:        5.h,
        backgroundColor:  barColor.withOpacity(0.15),
        valueColor:       AlwaysStoppedAnimation<Color>(barColor),
      ),
    );
  }
}

// ── available seats chip ─────────────────────────────────────────────────────

class _SeatsBadge extends StatelessWidget {
  final int available;
  const _SeatsBadge({required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_seat_rounded, size: 10.sp, color: AppColor.primaryColor),
          SizedBox(width: 3.w),
          Text(
            '$available seats',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.primaryColor,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}

// ── crowding badge (unchanged) ───────────────────────────────────────────────

class _CrowdingBadge extends StatelessWidget {
  final CrowdingLevel level;
  const _CrowdingBadge({required this.level});

  Color get _bg {
    switch (level) {
      case CrowdingLevel.low:     return AppColor.successContainer;
      case CrowdingLevel.medium:  return const Color.fromARGB(255, 165, 161, 141);
      case CrowdingLevel.high:    return AppColor.errorContainer;
      case CrowdingLevel.unknown: return AppColor.errorContainer.withOpacity(0.5);
    }
  }

  Color get _fg {
    switch (level) {
      case CrowdingLevel.low:     return AppColor.success;
      case CrowdingLevel.medium:  return AppColor.warning;
      case CrowdingLevel.high:    return AppColor.error;
      case CrowdingLevel.unknown: return AppColor.error.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: _fg,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}