import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';

class HomeHeaderWidget extends StatelessWidget {

  final VoidCallback onAddPressed;
  final VoidCallback onSavedPressed;

  const HomeHeaderWidget({
    super.key,
    required this.onAddPressed,
    required this.onSavedPressed,
  });

  static const _gradient = LinearGradient(
    colors: [AppColor.main, Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end:   Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: _gradient),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // decorative circles
            Positioned(
              top:   0,
              right: -5,
              child: _buildCircle(height: 120.h, width: 120.w),
            ),
            Positioned(
              bottom: 10,
              left:   60,
              child:  _buildCircle(height: 60.h, width: 60.w),
            ),

            // main content
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
              child:   _buildRow(),
            ),

            // action buttons top-right
            _buildActions(),
          ],
        ),
      ),
    );
  }

  // ── row ────────────────────────────────────────────────────────────────────

  Widget _buildRow() {
    return Row(
      children: [
        Container(
          width:  44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color:        Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withAlpha(77),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.inventory_2_rounded,
            color: Colors.white,
            size:  22,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(child: _buildColumnText()),
      ],
    );
  }

  // ── texts ──────────────────────────────────────────────────────────────────

  Widget _buildColumnText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lost & Found',
          style: AppStyle.regular18RobotoWhite.copyWith(
            fontSize:    18.sp,
            fontWeight:  FontWeight.w800,
            color:       Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          'Help each other find lost items',
          style: AppStyle.regular18RobotoWhite.copyWith(
            fontSize:   12.sp,
            fontWeight: FontWeight.w400,
            color:      Colors.white.withAlpha(217),
          ),
        ),
      ],
    );
  }

  // ── action buttons (bookmark + add) ───────────────────────────────────────

  Widget _buildActions() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: 16.h, right: 16.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             _ActionButton(
              icon:  Icons.add_rounded,
              onTap: onAddPressed,
            ),
          ],
        ),
      ),
    );
  }

  // ── decorative circle ──────────────────────────────────────────────────────

  Widget _buildCircle({required double height, required double width}) {
    return Container(
      width:  width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(15),
      ),
    );
  }
}

// ── reusable action button ─────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color:  Colors.white.withAlpha(51),
          shape:  BoxShape.circle,
          border: Border.all(
            color: Colors.white.withAlpha(102),
            width: 1.5,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 22.sp),
      ),
    );
  }
}