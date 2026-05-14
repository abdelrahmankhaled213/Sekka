import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_state.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/location_header_widget.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/search_location_bottom_sheet.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/station_card_widget.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/transport_filter_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';

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
      backgroundColor: AppColor.background,
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
                      left: 16.w,
                      right: 16.w,
                      child: _FloatingSearchCard(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearest Stations',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                        fontFamily: 'Roboto'
                      ),
                    ),
                    Icon(Icons.my_location,
                        size: 18.sp, color: AppColor.grey),
                  ],
                ),
              ),
              Expanded(child: _buildBody(context, state)),
              Padding(
                padding:
                EdgeInsets.fromLTRB(16.w, 8.h, 16.w, bottomNavHeight),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColor.secondary, AppColor.primaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Plan My Route',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: stations.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, i) => InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {},
        child: StationCardWidget(station: stations[i]),
      ),
    );
  }

  Widget _buildSkeleton() {
    final dummy = List.generate(
      4,
          (_) => NearestStationModel(
        name: 'Loading Station Name Here',
        routes: 'Loading Routes Here',
        location: GeoPoint(lat: 0, lng: 0),
        distanceKm: 0.5,
        crowding: CrowdingLevel.low,
      ),
    );

    return Skeletonizer(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: dummy.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (_, i) => StationCardWidget(station: dummy[i]),
      ),
    );
  }

  Widget _buildError(BuildContext context, String? msg) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_outlined,
                size: 48.sp, color: AppColor.muted),
            SizedBox(height: 12.h),
            Text(
              msg ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style:
              TextStyle(color: AppColor.textSecondary, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<NearestStationCubit>().loadNearestStations(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.train_outlined, size: 48.sp, color: AppColor.muted),
          SizedBox(height: 12.h),
          Text(
            'No stations found nearby',
            style:
            TextStyle(color: AppColor.textSecondary, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class _FloatingSearchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12.r),
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
                padding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColor.muted, size: 20.sp),
                    SizedBox(width: 10.w),
                    Text(
                      'Where do you want to go?',
                      style:
                      TextStyle(color: AppColor.muted, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TransportFilterWidget(),
          ],
        ),
      ),
    );
  }
}
