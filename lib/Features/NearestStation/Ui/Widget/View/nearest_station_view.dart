import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/core/theme/app_colors.dart';
import 'package:sekka/core/theme/app_radius.dart';
import 'package:sekka/core/theme/app_spacing.dart';
import 'package:sekka/core/theme/app_text_styles.dart';
import 'package:sekka/core/widgets/app_button.dart';
import 'package:sekka/core/widgets/app_empty_state.dart';
import 'package:sekka/core/widgets/app_loading.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_state.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/location_header_widget.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/search_location_bottom_sheet.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/station_card_widget.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/transport_filter_widget.dart';

class NearestStationView extends StatefulWidget {

  const NearestStationView({super.key});

  @override
  State<NearestStationView> createState() => _NearestStationViewState();

}

class _NearestStationViewState extends State<NearestStationView> {
  @override
  void initState() {
    super.initState();
    context.read<NearestStationCubit>().loadNearestStations();
  }

  @override
  Widget build(BuildContext context) {
    
    final bottomNavHeight = 80.h;

  return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<NearestStationCubit, NearestStationState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
  SizedBox(
                height: 285.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    LocationHeaderWidget(locationName: state.locationName),
  Positioned(
                      bottom: 0,
                      left: AppSpacing.lg.w,
                      right: AppSpacing.lg.w,
                      child: _FloatingSearchCard(),
                    ),
                  ],
                ),
              ),
  Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.lg.w, 0, AppSpacing.lg.w, AppSpacing.md.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
  Text(
                      'Nearest Stations',
                      style: AppTextStyles.titleMedium(context),
                    ),
                    Icon(Icons.my_location, size: 18.sp, color: AppColors.grey),
                  ],
                ),
              ),
              Expanded(child: _buildBody(context, state)),
  Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.lg.w, AppSpacing.sm.h, AppSpacing.lg.w, bottomNavHeight),
                child: AppButton(
                      text: 'Plan My Route',
                      variant: AppButtonVariant.gradient,
                      size: AppButtonSize.large,
                      fullWidth: true,
                      onPressed: () {},
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, NearestStationState state) {
    switch (state.status) {
      case NearestStationStatus.initial:
      case NearestStationStatus.loading:
        return _buildSkeleton();
      case NearestStationStatus.error:
        return _buildError(context, state.errorMessage);
      case NearestStationStatus.loaded:
        if (state.stations.isEmpty) return _buildEmpty();
        return _buildList(context, state.stations);
    }
  }

  Widget _buildList(
      BuildContext context, List<NearestStationModel> stations) {
  return ListView.separated(
      padding: AppSpacing.horizontalLG,
      itemCount: stations.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md.h),
      itemBuilder: (_, i) => InkWell(
        borderRadius: AppRadius.allLG,
        onTap: () {},
        child: StationCardWidget(station: stations[i]),
      ),
    );
  }

  Widget _buildSkeleton() {
    return const AppLoading(variant: AppLoadingVariant.circular);
  }

  Widget _buildError(BuildContext context, String? msg) {
    return AppErrorState(
      title: 'Error Loading Stations',
      description: msg ?? 'Something went wrong',
      actionLabel: 'Try Again',
      onActionPressed: () => context.read<NearestStationCubit>().loadNearestStations(),
    );
  }

  Widget _buildEmpty() {
    return const AppEmptyState(
      icon: Icons.train_outlined,
      title: 'No Stations Found',
      description: 'No stations found nearby',
    );
  }
}

class _FloatingSearchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Material(
      elevation: 8,
      borderRadius: AppRadius.allXXL,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w, vertical: AppSpacing.xl.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
  InkWell(
              borderRadius: AppRadius.allLG,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
                    value: context.read<NearestStationCubit>(),
                    child: const SearchLocationBottomSheet(),
                  ),
                );
              },
  child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w, vertical: AppSpacing.md.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: AppRadius.allLG,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.muted, size: 20.sp),
                    SizedBox(width: AppSpacing.md.w),
                    Text(
                      'Where do you want to go?',
                      style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
  ),
            SizedBox(height: AppSpacing.md.h),
            TransportFilterWidget(),
          ],
        ),
      ),
    );
  }
}
