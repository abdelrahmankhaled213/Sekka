import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Core/theme/app_radius.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class SearchCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final bool isFocused;
  final WhereToGoState state;
  final VoidCallback onClear;

  const SearchCard({
    super.key,
    required this.controller,
    required this.focus,
    required this.isFocused,
    required this.state,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WhereToGoCubit>();

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.allLG,
        border: Border.all(color: AppColors.outline, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── From row ───────────────────────────────────────────────────
          _LocationRow(
            icon: Icons.radio_button_checked_rounded,
            iconColor: AppColors.darkGreen,
            label: state.currentLocationLabel ?? 'Getting your location…',
            isHint: state.currentLocationLabel == null,
            isLoading: state.status == WhereToGoStatus.locating,
            onTap: cubit.fetchCurrentLocation,
          ),

          // ── Divider with swap ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                SizedBox(width: 17.w),
                Container(
                  width: 1,
                  height: 16.h,
                  color: AppColors.outline,
                ),
                const Spacer(),
                Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.offWhite,
                    border:
                    Border.all(color: AppColors.outline, width: 0.8),
                  ),
                  child: Icon(
                    Icons.swap_vert_rounded,
                    size: 14.sp,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          // ── To field (search) ──────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: AppRadius.allMD,
              border: Border.all(
                color: isFocused
                    ? AppColors.primary
                    : AppColors.outline,
                width: isFocused ? 1.5 : 0.8,
              ),
              boxShadow: isFocused
                  ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [],
            ),
            child: Row(
              children: [
               
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Icon(
                    Icons.search_rounded,
                    size: 16.sp,
                    color: isFocused ? AppColors.primary : AppColors.muted,
                  ),
                ),
                // Text field
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focus,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: state.selectedPlace?.mainText ??
                          'Where do you want to go?',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Roboto',
                        color: AppColors.muted,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 11.h),
                    ),
                    onChanged: (v) =>
                        context.read<WhereToGoCubit>().onSearchChanged(v),
                  ),
                ),
                // Clear / loading
                if (state.status == WhereToGoStatus.searching)
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: CircularProgressIndicator(
                          strokeWidth: 1.5, color: AppColors.primary),
                    ),
                  )
                else if (controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: onClear,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 10.sp, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
        
        
        
        
          ),

          SizedBox(height: 12.h),

          // ── Find Route button ──────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: state.canSearch &&
                    state.status != WhereToGoStatus.loadingRoute
                    ? LinearGradient(
                  colors: [AppColors.primary, AppColors.darkBlue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
                    : null,
                color: state.canSearch &&
                    state.status != WhereToGoStatus.loadingRoute
                    ? null
                    : AppColors.outline,
                borderRadius: AppRadius.allMD,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppRadius.allMD,
                  onTap: state.canSearch &&
                      state.status != WhereToGoStatus.loadingRoute
                      ? cubit.findRoute
                      : null,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.route_rounded,
                          size: 16.sp,
                          color: state.canSearch
                              ? Colors.white
                              : AppColors.grey,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Find Route',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: state.canSearch
                                ? Colors.white
                                : AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Location display row ──────────────────────────────────────────────────────

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isHint;
  final bool isLoading;
  final VoidCallback onTap;

  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isHint,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: AppRadius.allMD,
          border: Border.all(color: AppColors.outline, width: 0.8),
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
                  fontFamily: 'Roboto',
                  color: isHint ? AppColors.muted : AppColors.textPrimary,
                  fontWeight: isHint ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.my_location_rounded,
                size: 13.sp, color: iconColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
