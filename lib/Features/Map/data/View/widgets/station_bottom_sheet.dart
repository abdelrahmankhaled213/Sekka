import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

class StationBottomSheet extends StatelessWidget {

  final NearestStationModel station;
  final VoidCallback onClose;

  const StationBottomSheet({
    super.key,
    required this.station,
    required this.onClose,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.all(12.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color:        AppColor.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset:     const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag handle
          Center(
            child: Container(
              width:  40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color:        AppColor.outline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // header
          Row(
            children: [
              Container(
                width:  48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [TransportUIHelper.color(station.type?? TransportType.metro), TransportUIHelper.color(station.type?? TransportType.metro).withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end:   Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color:      TransportUIHelper.color(station.type?? TransportType.metro).withOpacity(0.3),
                      blurRadius: 10,
                      offset:     const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(TransportUIHelper.icon(station.type?? TransportType.metro), size: 24.sp, color: Colors.white),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: TextStyle(
                        fontSize:   16.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Roboto',
                        color:      AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      station.type?.label ?? 'Station',
                      style: TextStyle(
                        fontSize:   12.sp,
                        fontFamily: 'Roboto',
                        color:      TransportUIHelper.color(station.type?? TransportType.metro),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width:  32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color:        AppColor.offWhite,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColor.grey,
                    size:  16.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Row(
            children: [
              _InfoChip(
                icon:  Icons.near_me_rounded,
                label: '${station.distanceKm.toStringAsFixed(2)} km',
                color: AppColor.main,
              ),
              SizedBox(width: 10.w),
              _InfoChip(
                icon:  Icons.people_rounded,
                label: station.crowding.label,
                color: TransportUIHelper.color(station.type?? TransportType.metro),
              ),
            ],
          ),

          if (station.routes != null && station.routes!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Text(
              'Available Routes',
              style: TextStyle(
                fontSize:   13.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color:      AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: station.routes!
                  .split(' | ')
                  .map((r) => _RouteChip(label: r, color: TransportUIHelper.color(station.type?? TransportType.metro)))
                  .toList(),
            ),
          ],

          SizedBox(height: 16.h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: TransportUIHelper.color(station.type?? TransportType.metro),
                foregroundColor: Colors.white,
                padding:         EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              icon:  Icon(Icons.directions_rounded, size: 18.sp),
              label: Text(
                'Get Directions',
                style: TextStyle(
                  fontSize:   14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _crowdingColor(CrowdingLevel level) {
    switch (level) {
      case CrowdingLevel.low:    return AppColor.success;
      case CrowdingLevel.medium: return AppColor.warning;
      case CrowdingLevel.high:   return AppColor.error;
      default:                   return AppColor.muted;
    }
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize:   12.sp,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              color:      color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteChip extends StatelessWidget {
  final String label;
  final Color  color;

  const _RouteChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8.r),
        border:       Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize:   11.sp,
          fontFamily: 'Roboto',
          color:      color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
