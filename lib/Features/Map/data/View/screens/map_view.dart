import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/core/theme/app_colors.dart';
import 'package:sekka/core/theme/app_radius.dart';
import 'package:sekka/core/theme/app_spacing.dart';
import 'package:sekka/core/theme/app_text_styles.dart';
import 'package:sekka/core/widgets/app_button.dart';
import '../../Logic/cubit/map_cubit.dart';
import '../../Logic/cubit/maps_state.dart';
import '../map_styles.dart';
import '../widgets/station_bottom_sheet.dart';
import '../widgets/station_card.dart';
import '../widgets/station_shimmer_card.dart';
import '../widgets/transport_filter_chips.dart';

class MapView extends StatefulWidget {
  
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  static const _defaultCamera = CameraPosition(
    target: LatLng(30.0444, 31.2357), // Cairo
    zoom:   12,
  );

  @override
  void initState() {
    super.initState();
    // Check if route data was passed from navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['segments'] != null) {
        final segments = args['segments'] as List<SegmentModel>;
        context.read<MapCubit>().loadRoute(segments);
      } else {
        // Initialize location if no route data
        context.read<MapCubit>().initLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

  return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          if (state.selectedStation != null) {
            _showStationSheet(context, state);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _defaultCamera,
                markers:               state.markers,
                polylines:             state.polylines,
                myLocationEnabled:     true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled:   false,
                compassEnabled:        false,
                mapToolbarEnabled:     false,
                onMapCreated: (ctrl) {
                  context
                      .read<MapCubit>()
                      .onMapCreated(ctrl);
                  ctrl.setMapStyle(
                    isDark ? MapStyles.dark : MapStyles.light,
                  );
                },
                onTap: (_) =>
                    context.read<MapCubit>().clearSelection(),
              ),

               SafeArea(
                child: Column(
                  children: [

  Padding(
                      padding: EdgeInsets.fromLTRB(AppSpacing.lg.w, AppSpacing.md.h, AppSpacing.lg.w, 0),
                      child: _SearchBar(),
                    ),

  SizedBox(height: AppSpacing.md.h),
                    
                    TransportFilterChips(
                      selected:  state.selectedType,
                      onChanged: (type) => context
                          .read<MapCubit>()
                          .filterByType(type),
                    ),
                  ],
                ),
              ),
 Positioned(
                bottom: 0,
                left:   0,
                right:  0,
                child: _BottomCards(state: state),
              ),

  Positioned(
                right: AppSpacing.lg.w,
                bottom: _bottomCardsHeight(state) + AppSpacing.lg.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ZoomControls(),
                    SizedBox(height: AppSpacing.md.h),
                    _LocationFab(),
                  ],
                ),
              ),


              if (state.status == MapStatus.locationDenied ||
                  state.status == MapStatus .locationDeniedForever)
                _PermissionOverlay(forever: state.status ==
                    MapStatus.locationDeniedForever),

              if (state.status == MapStatus.stationsError)
                _ErrorOverlay(message: state.errorMsg ?? 'Something went wrong'),

              // Route loading skeleton
              if (state.status == MapStatus.routeLoading)
                _RouteLoadingSkeleton(),

              // Route legend
              if (state.status == MapStatus.routeLoaded)
                _RouteLegend(segments: state.routeSegments ?? []),
            ],
          );
        },
      ),
    );
  }

  double _bottomCardsHeight(MapState state) {
    if (state.status == MapStatus.stationsLoaded ||
        state.status == MapStatus.stationsLoading) {
      return 200.h;
    }
    return 40.h;
  }

 void _showStationSheet(BuildContext context, MapState state) {
  final cubit = context.read<MapCubit>(); 

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    builder: (_) => BlocProvider.value( 
      value: cubit,
      child: StationBottomSheet(
        station: state.selectedStation!,
        onClose: () {
          Navigator.pop(context);
          cubit.clearSelection();
        },
      ),
    ),
  );
}
}


class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.allLG,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
  child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w, vertical: AppSpacing.md.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),
            borderRadius: AppRadius.allLG,
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color:      Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset:     const Offset(0, 4),
              ),
            ],
          ),
  child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.muted, size: 20.sp),
              SizedBox(width: AppSpacing.md.w),
              Text(
                'Search stations...',
                style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _BottomCards extends StatelessWidget {
  final MapState state;
  const _BottomCards({required this.state});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xxl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  child: Container(
          padding: EdgeInsets.fromLTRB(0, AppSpacing.lg.h, 0, AppSpacing.xxl.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xxl)),
            boxShadow: [
              BoxShadow(
                color:      Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset:     const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // handle
  Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: AppSpacing.xl.h),
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: AppRadius.allXS,
                  ),
                ),
              ),

  Padding(
                padding: AppSpacing.horizontalLG,
                child: Row(
                  children: [
  Text(
                      'Nearest Stations',
                      style: AppTextStyles.titleMedium(context),
                    ),
                    const Spacer(),
                    if (state.status == MapStatus.stationsLoaded)
  Text(
                        '${state.stations.length} found',
                        style: AppTextStyles.labelSmall(context).copyWith(color: AppColors.muted),
                      ),
                  ],
                ),
              ),

  SizedBox(height: AppSpacing.md.h),

              if (state.status == MapStatus.stationsLoading ||
                  state.status == MapStatus.locationLoading)
                SizedBox(
                  height: 130.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: AppSpacing.horizontalLG,
                    itemCount: 4,
                    itemBuilder:     (_, __) => const StationShimmerCard(),
                  ),
                )

              else if (state.status == MapStatus.stationsLoaded)
                SizedBox(
                  height: 130.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: AppSpacing.horizontalLG,
                    itemCount: state.stations.length,
                    itemBuilder: (_, i) {
                      final station = state.stations[i];
                      return StationCard(
                        station:    station,
                        isSelected: state.selectedStation?.id == station.id,
                        onTap: () => context
                            .read<MapCubit>()
                            .selectStation(station),
                      );
                    },
                  ),
                )

              // empty
              else if (state.status == MapStatus.stationsEmpty)
                SizedBox(
                  height: 100.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
  Icon(Icons.search_off_rounded,
                            color: AppColors.muted, size: 32.sp),
                        SizedBox(height: AppSpacing.sm.h),
                        Text(
                          'No stations nearby',
                          style: AppTextStyles.labelSmall(context).copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class _LocationFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<MapCubit>().goToUserLocation(),
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape:   BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset:     const Offset(0, 4),
            ),
          ],
        ),
  child: Icon(
          Icons.my_location_rounded,
          color: AppColors.primary,
          size: 20.sp,
        ),
      ),
    );
  }
}


class _PermissionOverlay extends StatelessWidget {
  final bool forever;
  const _PermissionOverlay({required this.forever});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
  child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl.w),
            padding: EdgeInsets.all(AppSpacing.xxl.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.allXXL,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
  Icon(Icons.location_off_rounded,
                    color: AppColors.error, size: 48.sp),
                SizedBox(height: AppSpacing.lg.h),
                Text(
                  forever
                      ? 'Location Permission Denied'
                      : 'Location Required',
                  style: AppTextStyles.titleMedium(context),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  forever
                      ? 'Please enable location from Settings to use this feature.'
                      : 'We need your location to find nearest stations.',
                  style: AppTextStyles.labelSmall(context).copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xl.h),
  AppButton(
                  text: forever ? 'Open Settings' : 'Allow Location',
                  variant: AppButtonVariant.primary,
                  fullWidth: true,
                  onPressed: () {
                    if (forever) {
                      // افتح الـ settings
                    } else {
                      context.read<MapCubit>().initLocation();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _ErrorOverlay extends StatelessWidget {

  final String message;
  const _ErrorOverlay({required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 220.h,
      left: AppSpacing.lg.w,
      right: AppSpacing.lg.w,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: AppRadius.allLG,
          border: Border.all(color: AppColors.error.withOpacity(0.2)),
        ),
  child: Row(
          children: [
            Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 20.sp),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
  child: Text(
                message,
                style: AppTextStyles.labelSmall(context).copyWith(color: AppColors.error),
              ),
            ),
  TextButton(
              onPressed: () =>
                  context.read<MapCubit>().initLocation(),
              child: Text(
                'Retry',
                style: AppTextStyles.labelSmall(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteLegend extends StatelessWidget {
  final List<SegmentModel> segments;

  const _RouteLegend({required this.segments});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.xl.h,
      left: AppSpacing.lg.w,
      right: AppSpacing.lg.w,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: AppRadius.allLG,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  'Start',
                  style: AppTextStyles.labelSmall(context),
                ),
                SizedBox(width: AppSpacing.lg.w),
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  'End',
                  style: AppTextStyles.labelSmall(context),
                ),
                SizedBox(width: AppSpacing.lg.w),
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  'Transfer',
                  style: AppTextStyles.labelSmall(context),
                ),
              ],
            ),
            if (segments.length > 1) ...[
              SizedBox(height: AppSpacing.sm.h),
              Wrap(
                spacing: AppSpacing.md.w,
                children: segments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final segment = entry.value;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: _getSegmentColor(segment.type, index),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Segment ${index + 1}',
                        style: AppTextStyles.caption(context),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSegmentColor(TransportType type, int index) {
    final colors = [
      AppColors.lightBlue,
      AppColors.lightPurple,
      AppColors.lightGreen,
      AppColors.orange,
    ];
    return colors[index % colors.length];
  }
}

class _RouteLoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(AppSpacing.xxl.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.allXXL,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                SizedBox(height: AppSpacing.lg.h),
                Text(
                  'Loading route...',
                  style: AppTextStyles.labelSmall(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.allLG,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomButton(
            icon: Icons.add,
            onTap: () => context.read<MapCubit>().zoomIn(),
          ),
          Container(
            height: 1,
            width: 32.w,
            color: Colors.grey.withOpacity(0.2),
          ),
          _ZoomButton(
            icon: Icons.remove,
            onTap: () => context.read<MapCubit>().zoomOut(),
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: 20.sp,
        ),
      ),
    );
  }
}
