import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Core/theme/app_radius.dart';
import 'package:sekka/Core/theme/app_text_styles.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class SearchCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final bool isFocused;
  final WhereToGoState state;

  const SearchCard({
    super.key, 
    required this.controller,
    required this.focus,
    required this.isFocused,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WhereToGoCubit>();

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: AppRadius.allLG,
        border: Border.all(
            color: Colors.grey.withOpacity(0.12), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where to go?',
            style: AppTextStyles.headlineMedium(context).copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            'Find your route in Cairo',
            style: AppTextStyles.caption(context),
          ),
          SizedBox(height: 14.h),


          _LocationField(
            icon:       Icons.radio_button_checked_rounded,
            iconColor:  AppColors.darkGreen,
            isLoading:  state.status == WhereToGoStatus.locating,
            label:      state.currentLocationLabel ?? 'Getting your location…',
            isHint:     state.currentLocationLabel == null,
            onTap:      cubit.fetchCurrentLocation,
          ),

           Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                SizedBox(width: 16.w),
                Container(
                    width: 1, height: 18.h, color: Colors.grey.shade200),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // swap — مش محتاجه هنا لأن الـ start دايماً current location
                  },
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      shape:  BoxShape.circle,
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.25), width: 0.5),
                    ),
                    child: Icon(Icons.swap_vert_rounded,
                        size: 16.sp, color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),
          ),

          // ── to field (search) ──────────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: AppRadius.allMD,
              border: Border.all(
                color: isFocused
                    ? AppColors.darkBlue
                    : Colors.grey.withOpacity(0.18),
                width: isFocused ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: state.selectedPlace != null
                          ? AppColors.darkBlue
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller:  controller,
                    focusNode:   focus,
                    style:       TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87),
                    decoration: InputDecoration(
                      hintText:        state.selectedPlace?.mainText ??
                          'Where do you want to go?',
                      hintStyle:       TextStyle(
                          fontSize: 14.sp, color: Colors.grey.shade400),
                      border:          InputBorder.none,
                      contentPadding:  EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 11.h),
                    ),
                    onChanged: (v) =>
                        context.read<WhereToGoCubit>().onSearchChanged(v),
                  ),
                ),
                if (controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      controller.clear();
                      context.read<WhereToGoCubit>().reset();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 11.sp, color: Colors.white),
                      ),
                    ),
                  ),
                if (state.status == WhereToGoStatus.searching)
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.darkBlue),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // ── find route button ──────────────────────────────────────────────
          SizedBox(
            width:  double.infinity,
            height: 44.h,
            child: ElevatedButton.icon(
              onPressed: state.canSearch &&
                      state.status != WhereToGoStatus.loadingRoute
                  ? cubit.findRoute
                  : null,
              icon:  Icon(Icons.route_rounded, size: 18.sp),
              label: Text(
                'Find Route',
                style: TextStyle(
                    fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:         AppColors.darkBlue,
                disabledBackgroundColor: Colors.grey.shade200,
                foregroundColor:         Colors.white,
                elevation:               0,
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.allMD),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _LocationField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool isLoading;
  final String label;
  final bool isHint;
  final VoidCallback onTap;

  const _LocationField({
    required this.icon,
    required this.iconColor,
    required this.isLoading,
    required this.label,
    required this.isHint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:    EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
        decoration: BoxDecoration(
          color:        Colors.grey.shade50,
          borderRadius: AppRadius.allMD,
          border: Border.all(
              color: Colors.grey.withOpacity(0.18), width: 0.5),
        ),
        child: Row(
          children: [
            isLoading
                ? SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: CircularProgressIndicator(
                        strokeWidth: 1.5, color: iconColor),
                  )
                : Icon(icon, size: 14.sp, color: iconColor),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isHint
                      ? Colors.grey.shade400
                      : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.my_location_rounded,
                size: 14.sp, color: iconColor.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }
}
