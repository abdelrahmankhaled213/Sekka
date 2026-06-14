import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

class StationCardWidget extends StatelessWidget {
  final NearestStationModel station;

  const StationCardWidget({super.key, required this.station});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: icon  |  name + distance  |  crowding badge ──
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.subway_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),

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
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              _CrowdingBadge(level: station.crowding),
            ],
          ),

          SizedBox(height: 12.h),

          // ── Capacity prediction row ──
          _CapacityRow(
            seatsAvailable: station.fakeSeatsAvailable,
            capacityPercent: station.fakeCapacityPercent,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Capacity row: progress bar + seats + percentage
// ─────────────────────────────────────────────────────────────────────────────

class _CapacityRow extends StatelessWidget {
  final int seatsAvailable;
  final double capacityPercent; // percentage of seats that are *occupied*

  const _CapacityRow({
    required this.seatsAvailable,
    required this.capacityPercent,
  });

  Color get _barColor {
    if (capacityPercent < 40) return AppColor.success;
    if (capacityPercent < 70) return AppColor.warning;
    return AppColor.error;
  }

  @override
  Widget build(BuildContext context) {
    final fillRatio = (capacityPercent / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: fillRatio,
            minHeight: 6.h,
            backgroundColor: AppColor.textSecondary.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(_barColor),
          ),
        ),
        SizedBox(height: 6.h),

        // Seats available  ·  percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.event_seat_rounded,
                    size: 13.sp, color: AppColor.textSecondary),
                SizedBox(width: 4.w),
                Text(
                  '$seatsAvailable seats available',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textSecondary,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            Text(
              '${capacityPercent.toStringAsFixed(0)}% full',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: _barColor,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Crowding badge (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _CrowdingBadge extends StatelessWidget {
  final CrowdingLevel level;
  const _CrowdingBadge({required this.level});

  Color get _bg {
    switch (level) {
      case CrowdingLevel.low:
        return AppColor.successContainer;
      case CrowdingLevel.medium:
        return AppColor.warningContainer;
      case CrowdingLevel.high:
        return AppColor.errorContainer;
      case CrowdingLevel.unknown:
        return AppColor.errorContainer.withOpacity(0.5);
    }
  }

  Color get _fg {
    switch (level) {
      case CrowdingLevel.low:
        return AppColor.success;
      case CrowdingLevel.medium:
        return AppColor.warning;
      case CrowdingLevel.high:
        return AppColor.error;
      case CrowdingLevel.unknown:
        return AppColor.error.withOpacity(0.5);
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
