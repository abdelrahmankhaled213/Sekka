import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Core/theme/app_radius.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/trip_history_model.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class RecentTripsWidget extends StatelessWidget {
  /// Called when the user taps a recent trip — passes the full model
  /// so the screen can fill the controller AND trigger repeatTrip().
  final ValueChanged<TripHistoryModel> onTripTap;

  /// Called when the user taps a popular destination chip.
  final ValueChanged<String> onDestinationTap;

  const RecentTripsWidget({
    required this.onTripTap,
    required this.onDestinationTap,
    super.key,
  });

  static final List<Map<String, dynamic>> _popularDests = [
    {'name': 'Ramses Station',  'icon': Icons.train_rounded,          'type': 'metro'},
    {'name': 'October Bridge',  'icon': Icons.directions_bus_rounded,  'type': 'microbus'},
    {'name': 'New Cairo',       'icon': Icons.train_rounded,          'type': 'monorail'},
    {'name': 'Heliopolis',      'icon': Icons.subway_rounded,         'type': 'metro'},
  ];

  Color _typeColor(String? mode) {
    switch (mode) {
      case 'monorail': return AppColors.secondary;
      case 'microbus': return AppColors.orange;
      case 'bus':      return AppColors.orange;
      default:         return AppColors.primary;
    }
  }

  IconData _typeIcon(String? mode) {
    switch (mode) {
      case 'monorail': return Icons.train_rounded;
      case 'microbus': return Icons.directions_bus_rounded;
      case 'bus':      return Icons.directions_bus_rounded;
      default:         return Icons.subway_rounded;
    }
  }

  String _formatDateTime(String raw) {
    try {
      final dt    = DateTime.parse(raw);
      final now   = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final day   = DateTime(dt.year, dt.month, dt.day);
      final diff  = today.difference(day).inDays;
      final time  =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      if (diff == 0) return 'Today, $time';
      if (diff == 1) return 'Yesterday';
      return '${_wd(dt.weekday)}, ${_mo(dt.month)} ${dt.day}';
    } catch (_) {
      return raw;
    }
  }

  String _wd(int d) => ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][d - 1];
  String _mo(int m) => ['Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhereToGoCubit, WhereToGoState>(
      buildWhen: (p, c) =>
      p.recentTrips != c.recentTrips || p.tripsLoading != c.tripsLoading,
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 100.h),
          children: [

            // ── Recent trips header ──────────────────────────────────────
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
                if (state.recentTrips.isNotEmpty)
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

            // ── Trip list ────────────────────────────────────────────────
            if (state.tripsLoading)
              const _LoadingPlaceholder()
            else if (state.recentTrips.isEmpty)
              const _EmptyPlaceholder()
            else
              ...List.generate(
                state.recentTrips.take(5).length,
                    (i) {
                  final trip = state.recentTrips[i];
                  return _TripItem(
                    trip:          trip,
                    index:         i,
                    typeColor:     _typeColor(trip.mode),
                    typeIcon:      _typeIcon(trip.mode),
                    formattedDate: _formatDateTime(trip.dateTime),
                    onTap: () => onTripTap(trip),   // ← full model
                  );
                },
              ),

            SizedBox(height: 20.h),

            // ── Popular destinations ─────────────────────────────────────
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
                        border: Border.all(color: AppColors.outline, width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28.w, height: 28.w,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(dest['icon'] as IconData,
                                size: 14.sp, color: color),
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
      },
    );
  }
}

// ── Loading placeholder ───────────────────────────────────────────────────────

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (_) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Container(
          height: 68.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.allMD,
            border: Border.all(color: AppColors.outline, width: 0.8),
          ),
          child: Center(
            child: SizedBox(
              width: 20.w, height: 20.w,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.primary),
            ),
          ),
        ),
      )),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Icon(Icons.history_rounded, size: 40.sp, color: AppColors.muted),
          SizedBox(height: 10.h),
          Text(
            'No recent trips yet',
            style: TextStyle(fontSize: 13.sp, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

// ── Individual trip row ───────────────────────────────────────────────────────

class _TripItem extends StatelessWidget {
  final TripHistoryModel trip;
  final int            index;
  final Color          typeColor;
  final IconData       typeIcon;
  final String         formattedDate;
  final VoidCallback   onTap;

  const _TripItem({
    required this.trip,
    required this.index,
    required this.typeColor,
    required this.typeIcon,
    required this.formattedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 260 + index * 45),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
            offset: Offset(0, 16 * (1 - v)), child: child),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Material(
          color: AppColors.surface,
          borderRadius: AppRadius.allMD,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.allMD,
            splashColor: typeColor.withOpacity(0.07),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: AppRadius.allMD,
                border: Border.all(color: AppColors.outline, width: 0.8),
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
                  // Mode icon
                  Container(
                    width: 40.w, height: 40.w,
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 18.sp),
                  ),
                  SizedBox(width: 12.w),

                  // Station names + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // To station (bold)
                        Text(
                          trip.toStation,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        // From station (muted)
                        Text(
                          'from ${trip.fromStation}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.muted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            if (trip.routeCode != null) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: typeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(99.r),
                                ),
                                child: Text(
                                  trip.routeCode!,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: typeColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],
                            Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: 10.sp, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Repeat icon
                  Column(
                    children: [
                      Container(
                        width: 32.w, height: 32.w,
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.replay_rounded,
                          size: 15.sp,
                          color: typeColor,
                        ),
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
