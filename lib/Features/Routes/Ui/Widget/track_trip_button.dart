import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Cubit/trip_tracking_cubit.dart';
import 'package:sekka/Core/Cubit/trip_tracking_state.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Logic/routes_state.dart';

class TrackTripButton extends StatelessWidget {
  const TrackTripButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, tripState) {
        if (tripState.hasArrived) _showArrivedDialog(context);

        if (tripState.status == TripStateEnum.error &&
            tripState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tripState.errorMessage!),
              backgroundColor: AppColor.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, tripState) {
        return BlocBuilder<RoutesCubit, RoutesState>(
          builder: (context, routesState) {
            final routeReady = routesState.routesStateEnum ==
                RoutesStateEnum.gettingRoutePathLoaded;

            if (!routeReady) return const SizedBox.shrink();

            final accent =
                routesState.selectedTransportSwitching?.color1 ??
                    AppColor.darkBlue;

            final endStationName =
                routesState.selectedTransportEnd?.name ?? 'Destination';

            if (tripState.isTracking) {
              return _TrackingCard(
                distanceMeters: tripState.distanceMeters,
                endStationName: endStationName,
                accent: accent,
                onCancel: () => context.read<TripCubit>().cancelTrip(),
              );
            }

            if (tripState.hasArrived) return const SizedBox.shrink();

            return _TrackButton(
              isLoading: tripState.status == TripStateEnum.startingTrip,
              accent: accent,
              onTap: () => context.read<TripCubit>().startTrip(
                    startStation: routesState.selectedTransportStart!,
                    endStation: routesState.selectedTransportEnd!,
                  ),
            );
          },
        );
      },
    );
  }

  void _showArrivedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<TripCubit>(),
        child: const _ArrivedDialog(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Track Button — initial state
// ─────────────────────────────────────────────────────────────────────────────

class _TrackButton extends StatelessWidget {
  final bool isLoading;
  final Color accent;
  final VoidCallback onTap;

  const _TrackButton({
    required this.isLoading,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            disabledBackgroundColor: accent.withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.near_me_rounded,
                        size: 20.sp, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      'Track Trip',
                      style: AppStyle.regular16RobotoBlack.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tracking Card — active tracking state
// ─────────────────────────────────────────────────────────────────────────────

class _TrackingCard extends StatelessWidget {
  final double? distanceMeters;
  final String endStationName;
  final Color accent;
  final VoidCallback onCancel;

  const _TrackingCard({
    required this.distanceMeters,
    required this.endStationName,
    required this.accent,
    required this.onCancel,
  });

  String get _label {
    final d = distanceMeters;
    if (d == null) return 'Calculating…';
    if (d < 1000) return '${d.toStringAsFixed(0)} m away';
    return '${(d / 1000).toStringAsFixed(1)} km away';
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon ────────────────────────────────────────
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.stop_circle_rounded,
                  color: Colors.red.shade600,
                  size: 36.sp,
                ),
              ),

              SizedBox(height: 16.h),

              // ── Title ───────────────────────────────────────
              Text(
                'Cancel Trip?',
                style: AppStyle.regular16RobotoBlack.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 8.h),

              // ── Subtitle ────────────────────────────────────
              Text(
                'Are you sure you want to stop tracking your trip to $endStationName?',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade500,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              // ── Buttons ─────────────────────────────────────
              Row(
                children: [
                  // Keep tracking
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                      ),
                      child: Text(
                        'Keep Going',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Confirm cancel
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // ✅ أقفل الـ dialog الأول
                        onCancel();             // ✅ بعدين عمل cancel
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                      ),
                      child: Text(
                        'Stop Trip',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.06),
        border: Border.all(color: accent.withOpacity(0.25), width: 1.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          _PulseDot(color: accent),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tracking to $endStationName',
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: accent,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),

          // ✅ Stop button — بيفتح confirmation dialog
          GestureDetector(
            onTap: () => _showCancelConfirmation(context),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Stop',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pulse Dot — animated indicator
// ─────────────────────────────────────────────────────────────────────────────

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _scale = Tween(begin: 1.0, end: 2.2)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _opacity = Tween(begin: 0.6, end: 0.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.w,
      height: 28.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Transform.scale(
              scale: _scale.value,
              child: Opacity(
                opacity: _opacity.value,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Arrived Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _ArrivedDialog extends StatelessWidget {
  const _ArrivedDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade600,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'You have arrived! 🎉',
              style: AppStyle.regular16RobotoBlack.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Your trip has been completed successfully.',
              style: TextStyle(
                  fontSize: 13.sp, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<TripCubit>().resetToInitial();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}