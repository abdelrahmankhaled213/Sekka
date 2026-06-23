import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class RouteSearchCard extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final FocusNode fromFocus;
  final FocusNode toFocus;
  final WhereToGoState state;
  final VoidCallback onClear;

  const RouteSearchCard({
    super.key,
    required this.fromController,
    required this.toController,
    required this.fromFocus,
    required this.toFocus,
    required this.state,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WhereToGoCubit>();
    final isFromActive = state.activeField == ActiveSearchField.from;
    final isToActive = state.activeField == ActiveSearchField.to;
    final canSwap = state.effectiveFromLat != null && state.destLat != null;
    final isLocating = state.status == WhereToGoStatus.locating;
    final isLoading = isLocating || state.status == WhereToGoStatus.searching;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r), // كبرنا الـ Radius للتصميم العصري
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── FROM + vertical line + TO ─────────────────────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left column: dot ─ line ─ pin ──────────────────────
                SizedBox(
                  width: 24.w, // وسعنا خط الجنب شوية عشان يتماشى مع حجم الحقول الجديد
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 18.h), // ترحيل بسيط ليناسب سنتر الحقل العلوي
                      // FROM dot
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(
                            color: isFromActive
                                ? AppColors.lightGreen
                                : AppColors.lightGreen.withOpacity(0.55),
                            width: isFromActive ? 3 : 2,
                          ),
                          boxShadow: isFromActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.lightGreen.withOpacity(0.30),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [],
                        ),
                      ),

                      // Dashed line between the two dots
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedLinePainter(
                            color: AppColors.outline.withOpacity(0.7),
                          ),
                          child: const SizedBox(width: 1),
                        ),
                      ),

                      // TO pin
                      Icon(
                        Icons.location_on_rounded,
                        size: 20.sp,
                        color: isToActive
                            ? AppColors.error
                            : AppColors.error.withOpacity(0.55),
                      ),
                      SizedBox(height: 18.h), // موازنة مع الحقل السفلي
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                // ── Right column: from field ─ separator ─ to field ────
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // FROM field
                      _SearchField(
                        controller: fromController,
                        focus: fromFocus,
                        hint: state.useCurrentLocationAsFrom
                            ? (state.currentLocationLabel ?? 'My Location')
                            : 'From where?',
                        hintIsValue: state.useCurrentLocationAsFrom,
                        isActive: isFromActive,
                        suffixWidget: state.useCurrentLocationAsFrom
                            ? _GpsTag(isLocating: isLocating)
                            : (fromController.text.isNotEmpty
                                ? _XButton(
                                    onTap: () {
                                      fromController.clear();
                                      cubit.useCurrentLocation();
                                    },
                                  )
                                : null),
                        onChanged: cubit.onFromSearchChanged,
                        onTap: () {
                          if (state.useCurrentLocationAsFrom) {
                            fromController.clear();
                          }
                        },
                      ),

                      // مسافة محترمة بين الحقلين بدل الـ Divider القديم الملزق
                      SizedBox(height: 12.h),

                      // TO field
                      _SearchField(
                        controller: toController,
                        focus: toFocus,
                        hint: 'Where to?',
                        hintIsValue: false,
                        isActive: isToActive,
                        suffixWidget: toController.text.isNotEmpty
                            ? _XButton(
                                onTap: () {
                                  toController.clear();
                                  onClear();
                                },
                              )
                            : null,
                        onChanged: cubit.onSearchChanged,
                        onTap: null,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                // ── Swap button on the right ───────────────────────────
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SwapButton(
                      canSwap: canSwap,
                      onTap: () {
                        final fromLabel = state.useCurrentLocationAsFrom
                            ? (state.currentLocationLabel ?? 'My Location')
                            : (state.fromLocationLabel ?? '');
                        final toLabel = state.selectedPlace?.mainText ?? '';
                        cubit.swapLocations();
                        fromController.text = toLabel;
                        toController.text = fromLabel;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

AnimatedSize(
  duration: const Duration(milliseconds: 280),
  curve: Curves.easeOutCubic,
  child: state.canSearch &&
          state.status != WhereToGoStatus.loadingRoute &&
          state.status != WhereToGoStatus.routeReady
      ? Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: _FindRouteButton(
            isLoading: isLoading,
            onTap: () {
              // 1. شيل الفوكس من الكيبورد
              fromFocus.unfocus();
              toFocus.unfocus();

              // 2. الـ Validation الذكي: التحقق من النصوص أو الإحداثيات
              final fromText = fromController.text.trim().toLowerCase();
              final toText = toController.text.trim().toLowerCase();

              // لو النصوص متطابقة أو الإحداثيات هي نفسها
              if (fromText == toText && fromText.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.white),
                        SizedBox(width: 10.w),
                        const Expanded(
                          child: Text(
                            'نقطة الانطلاق والوصول لا يمكن أن تكونا نفس المكان!',
                            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    margin: EdgeInsets.all(16.w),
                    duration: const Duration(seconds: 3),
                  ),
                );
                return; // اخرج من الدالة ومتقدمش الطلب للـ Cubit
              }

              // 3. لو كله تمام.. ابدأ البحث عن الرحلة
              cubit.findRoute();
            },
          ),
        )
      : const SizedBox.shrink(),
),
       
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final String hint;
  final bool hintIsValue;  
  final bool isActive;
  final Widget? suffixWidget;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;

  const _SearchField({
    required this.controller,
    required this.focus,
    required this.hint,
    required this.hintIsValue,
    required this.isActive,
    required this.onChanged,
    this.suffixWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focus,
      onChanged: onChanged,
      onTap: onTap,
      style: TextStyle(
        fontSize: 15.sp, // كبرنا الخط شوية
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 15.sp,

          fontWeight: hintIsValue ? FontWeight.w600 : FontWeight.w400,
          color: hintIsValue ? AppColors.textPrimary : AppColors.muted,
        ),
        
        
        filled: true,
        fillColor: isActive 
            ? AppColors.primary.withOpacity(0.03) 
            : AppColors.offWhite.withOpacity(0.6),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: AppColors.outline.withOpacity(0.4),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        
        // زرار الـ Clear أو الـ GPS جواه بشكل منسق
        suffixIcon: suffixWidget != null 
            ? Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [suffixWidget!],
                ),
              )
            : null,
        suffixIconConstraints: BoxConstraints(
          minWidth: 24.w,
          minHeight: 24.h,
        ),
      ),
    );
  }
}

// ── Swap button (right side, vertically centered between the two rows) ─────────

class _SwapButton extends StatelessWidget {
  final bool canSwap;
  final VoidCallback onTap;

  const _SwapButton({required this.canSwap, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canSwap ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 40.w, // كبرنا الحجم تماشياً مع الحقول الكبيرة
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: canSwap
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.offWhite,
          boxShadow: canSwap ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ] : [],
          border: Border.all(
            color: canSwap
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.outline.withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.swap_vert_rounded,
            size: 20.sp,
            color: canSwap ? AppColors.primary : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

// ── GPS tag chip ──────────────────────────────────────────────────────────────

class _GpsTag extends StatelessWidget {
  final bool isLocating;
  const _GpsTag({required this.isLocating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h), // وسعنا الـ Chip
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: AppColors.lightGreen.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLocating)
            SizedBox(
              width: 11.w,
              height: 11.w,
              child: CircularProgressIndicator(
                strokeWidth: 1.8,
                color: AppColors.darkGreen,
              ),
            )
          else
            Icon(Icons.my_location_rounded,
                size: 11.sp, color: AppColors.darkGreen),
          SizedBox(width: 5.w),
          Text(
            'GPS',
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── X clear button ────────────────────────────────────────────────────────────

class _XButton extends StatelessWidget {
  final VoidCallback onTap;
  const _XButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22.w, // كبرناه شوية عشان يبق أسهل في الضغط (UX أفضل)
        height: 22.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.muted.withOpacity(0.25),
        ),
        child: Icon(Icons.close_rounded, size: 13.sp, color: AppColors.grey),
      ),
    );
  }
}

// ── Find Route button ─────────────────────────────────────────────────────────

class _FindRouteButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _FindRouteButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 50.h, // كبرنا الارتفاع ليناسب فخامة الكارت الجديد
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.route_rounded, size: 19.sp, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      'Find Route',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Dashed vertical line painter ──────────────────────────────────────────────

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashH = 5.0; // طول الشرطة زاد شوية عشان يتماشى مع الطول الجديد
    const gapH = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    double y = 0;
    final cx = size.width / 2;
    while (y < size.height) {
      canvas.drawLine(Offset(cx, y), Offset(cx, (y + dashH).clamp(0, size.height)), paint);
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}