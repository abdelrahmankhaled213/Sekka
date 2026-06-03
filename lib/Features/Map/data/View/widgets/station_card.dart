import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

class StationCard extends StatelessWidget {

  final NearestStationModel station;
  final bool                isSelected;
  final VoidCallback        onTap;

  const StationCard({
    super.key,
    required this.station,
    required this.isSelected,
    required this.onTap,
  });

  

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width:   160.w,
        margin:  EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected ? TransportUIHelper.color(station.type?? TransportType.metro) : AppColor.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? TransportUIHelper.color(station.type?? TransportType.metro) : AppColor.outline,
            width: isSelected ? 0 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? TransportUIHelper.color(station.type?? TransportType.metro).withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius:  isSelected ? 14 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // icon
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : TransportUIHelper.color(station.type?? TransportType.metro).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(TransportUIHelper.icon(station.type?? TransportType.metro,), size: 18.sp, color: isSelected ? Colors.white : TransportUIHelper.color(station.type?? TransportType.metro)),
              ),
            ),
            SizedBox(height: 8.h),
            // name
            Text(
              station.name,
              style: TextStyle(
                fontSize:   13.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: isSelected ? Colors.white : AppColor.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            // distance
            Row(
              children: [
                Icon(
                  Icons.near_me_rounded,
                  size:  11.sp,
                  color: isSelected ? Colors.white70 : AppColor.muted,
                ),
                SizedBox(width: 3.w),
                Text(
                  '${station.distanceKm.toStringAsFixed(2)} km',
                  style: TextStyle(
                    fontSize:   11.sp,
                    fontFamily: 'Roboto',
                    color: isSelected ? Colors.white70 : AppColor.muted,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            
            _CrowdingBadge(
              level: station.crowding,
              isSelected: isSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _CrowdingBadge extends StatelessWidget {

  final CrowdingLevel level;
  final bool          isSelected;

  const _CrowdingBadge({required this.level, required this.isSelected});

  Color get _color {
    switch (level) {
      case CrowdingLevel.low:    return AppColor.success;
      case CrowdingLevel.medium: return AppColor.warning;
      case CrowdingLevel.high:   return AppColor.error;
      default:                   return AppColor.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withOpacity(0.2)
            : _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          fontSize:   10.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
          color: isSelected ? Colors.white : _color,
        ),
      ),
    );
  }
}
