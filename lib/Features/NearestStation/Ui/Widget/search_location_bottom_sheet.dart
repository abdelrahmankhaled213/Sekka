import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/place_autocomplete_service.dart';
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';

class SearchLocationBottomSheet extends StatefulWidget {
  const SearchLocationBottomSheet({super.key});

  @override
  State<SearchLocationBottomSheet> createState() =>
      _SearchLocationBottomSheetState();
}

class _SearchLocationBottomSheetState
    extends State<SearchLocationBottomSheet> {
  final _controller = TextEditingController();
  final _service = PlaceAutocompleteService();
  List<PlacePrediction> _predictions = [];
  bool _loading = false;
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() => _predictions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _loading = true);
      final results = await _service.getSuggestions(value);
      if (mounted) {
        setState(() {
          _predictions = results;
          _loading = false;
        });
      }
    });
  }

  Future<void> _onSelect(PlacePrediction prediction) async {
    final location = await _service.getPlaceLocation(prediction.placeId);
    if (!mounted || location == null) return;

    context.read<NearestStationCubit>().loadNearestStationsForSearchedLocation(
      lat: location.lat,
      lng: location.lng,
      overrideName: prediction.mainText,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.muted.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: 'Search for a place...',
                  prefixIcon: Icon(Icons.search, color: AppColor.muted),
                  filled: true,
                  fillColor: const Color(0xFFF5F6F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.my_location,
                  color: AppColor.primaryColor,
                  size: 20.sp,
                ),
              ),
              title: Text(
                'Use my current location',
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  fontFamily: 'Roboto'
                ),
              ),
              onTap: () {
                context.read<NearestStationCubit>().loadNearestStations();
                Navigator.pop(context);
              },
            ),
            if (_loading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: CircularProgressIndicator(color: AppColor.primaryColor),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _predictions.length,
                itemBuilder: (_, i) {
                  final p = _predictions[i];
                  return ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColor.muted.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: AppColor.muted,
                        size: 20.sp,
                      ),
                    ),
                    title: Text(
                      p.mainText,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColor.textPrimary,
                        fontFamily: 'Roboto'
                      ),
                    ),
                    subtitle: p.secondaryText.isNotEmpty
                        ? Text(
                      p.secondaryText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColor.textSecondary,
                        fontFamily: 'Roboto'
                      ),
                    )
                        : null,
                    onTap: () => _onSelect(p),
                  );
                },
              ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
