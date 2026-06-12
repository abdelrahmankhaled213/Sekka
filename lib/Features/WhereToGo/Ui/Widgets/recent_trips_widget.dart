import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Core/theme/app_radius.dart';

class RecentTripsWidget extends StatelessWidget {
  final ValueChanged<String> onDestinationTap;

  const RecentTripsWidget({required this.onDestinationTap, super.key});

  static final List<Map<String, dynamic>> _recentTrips = [
    {
      'destination': 'Cairo International Airport',
      'line': 'Metro Line 3',
      'type': 'metro',
      'duration': '42 min',
      'lastUsed': 'Today, 08:15',
      'icon': Icons.flight_takeoff_rounded,
      'color': AppColors.darkBlue,
    },
    {
      'destination': 'Maadi Station',
      'line': 'Metro Line 1',
      'type': 'metro',
      'duration': '18 min',
      'lastUsed': 'Yesterday',
      'icon': Icons.subway_rounded,
      'color': AppColors.darkGreen,
    },
    {
      'destination': 'Nasr City Hub',
      'line': 'Monorail East',
      'type': 'monorail',
      'duration': '25 min',
      'lastUsed': 'Mon, Jun 6',
      'icon': Icons.train_rounded,
      'color': AppColors.secondary,
    },
    {
      'destination': 'Cairo Festival City',
      'line': 'Microbus R14',
      'type': 'microbus',
      'duration': '35 min',
      'lastUsed': 'Sun, Jun 5',
      'icon': Icons.local_mall_rounded,
      'color': AppColors.orange,
    },
    {
      'destination': 'Tahrir Square',
      'line': 'Metro Line 2',
      'type': 'metro',
      'duration': '12 min',
      'lastUsed': 'Fri, Jun 3',
      'icon': Icons.account_balance_rounded,
      'color': AppColors.primary,
    },
  ];

  static final List<Map<String, dynamic>> _popularDests = [
    {
      'name': 'Ramses Station',
      'icon': Icons.train_rounded,
      'type': 'metro',
    },
    {
      'name': 'October Bridge',
      'icon': Icons.directions_bus_rounded,
      'type': 'microbus',
    },
    {
      'name': 'New Cairo',
      'icon': Icons.train_rounded,
      'type': 'monorail',
    },
    {
      'name': 'Heliopolis',
      'icon': Icons.subway_rounded,
      'type': 'metro',
    },
  ];

  Color _typeColor(String type) {
    switch (type) {
      case 'monorail':
        return AppColors.secondary;
      case 'microbus':
        return AppColors.orange;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 100.h),
      children: [
        // ── Section header ───────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Trips',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // ── Trip items ───────────────────────────────────────────────────
        ...List.generate(_recentTrips.length, (index) {
          return _TripItem(
            trip: _recentTrips[index],
            index: index,
            onTap: () => onDestinationTap(
                _recentTrips[index]['destination'] as String),
          );
        }),

        SizedBox(height: 20.h),

        // ── Popular destinations ─────────────────────────────────────────
        Text(
          'Popular Destinations',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 2.6,
          children: _popularDests.map((dest) {
            final color = _typeColor(dest['type'] as String);
            return Material(
              color: AppColors.surface,
              borderRadius: AppRadius.allMD,
              child: InkWell(
                onTap: () => onDestinationTap(dest['name'] as String),
                borderRadius: AppRadius.allMD,
                splashColor: color.withOpacity(0.08),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.allMD,
                    border:
                    Border.all(color: AppColors.outline, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          dest['icon'] as IconData,
                          size: 14.sp,
                          color: color,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          dest['name'] as String,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Individual trip row ───────────────────────────────────────────────────────

class _TripItem extends StatelessWidget {
  final Map<String, dynamic> trip;
  final int index;
  final VoidCallback onTap;

  const _TripItem({
    required this.trip,
    required this.index,
    required this.onTap,
  });

  Color _typeColor(String type) {
    switch (type) {
      case 'monorail':
        return AppColors.secondary;
      case 'microbus':
        return AppColors.orange;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = trip['color'] as Color? ??
        _typeColor(trip['type'] as String);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 260 + index * 45),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child:
        Transform.translate(offset: Offset(0, 16 * (1 - v)), child: child),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Material(
          color: AppColors.surface,
          borderRadius: AppRadius.allMD,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.allMD,
            splashColor: accentColor.withOpacity(0.07),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: AppRadius.allMD,
                border:
                Border.all(color: AppColors.outline, width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      trip['icon'] as IconData,
                      color: accentColor,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip['destination'] as String,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(99.r),
                              ),
                              child: Text(
                                trip['line'] as String,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: accentColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              trip['lastUsed'] as String,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Duration
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        trip['duration'] as String,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11.sp,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
