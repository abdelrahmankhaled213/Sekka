import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
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
      child: Row(
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
                    fontFamily: 'Roboto'
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
                    fontFamily: 'Roboto'
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          
          _CrowdingBadge(level: station.crowding),
        
        ],
      ),
    );
  }
}

class _CrowdingBadge extends StatelessWidget {

  final CrowdingLevel level;
  const _CrowdingBadge({required this.level});

  Color get _bg {
    
    switch (level) {
      case CrowdingLevel.low:    return AppColor.successContainer;
      case CrowdingLevel.medium: return AppColor.warningContainer;
      case CrowdingLevel.high:   return AppColor.errorContainer;
    }
  }

  Color get _fg {

    switch (level) {
      case CrowdingLevel.low:    return AppColor.success;
      case CrowdingLevel.medium: return AppColor.warning;
      case CrowdingLevel.high:   return AppColor.error;
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
          fontFamily: 'Roboto'
        ),
      ),
    );
  }
}
