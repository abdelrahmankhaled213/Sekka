import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_image.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/best_path_destination.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TransportSwitiching model
// ─────────────────────────────────────────────────────────────────────────────

class TransportSwitiching {
  final String image;
  final IconData icon;
  final Color color1;
  final Color color2;
  final TransportType title;

  const TransportSwitiching({
    required this.image,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.title,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PlanYourRoute
// ─────────────────────────────────────────────────────────────────────────────

class PlanYourRoute extends StatefulWidget {
  const PlanYourRoute({super.key});

  @override
  State<PlanYourRoute> createState() => _PlanYourRouteState();
}

class _PlanYourRouteState extends State<PlanYourRoute> {
  final List<TransportSwitiching> _transportList = [
    TransportSwitiching(
      image: AppImage.planYourRouteMetro,
      icon: Icons.directions_subway_rounded,
      color1: AppColor.darkBlue,
      color2: AppColor.lightBlue,
      title: TransportType.metro,
    ),
    TransportSwitiching(
      image: AppImage.planYourRouteMonorail,
      icon: Icons.directions_railway_rounded,
      color1: AppColor.darkPurple,
      color2: AppColor.lightPurple,
      title: TransportType.monorail,
    ),
    TransportSwitiching(
      image: AppImage.planYourRouteBus,
      icon: Icons.directions_bus_rounded,
      color1: AppColor.darkGreen,
      color2: AppColor.lightGreen,
      title: TransportType.bus,
    ),
  ];

  static LinearGradient _buildGradient(Color c1, Color c2) =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [c1.withOpacity(0.8), c2.withOpacity(0.4)],
        stops: const [0, 1],
      );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RoutesCubit>().state;
    final selected =
        state.selectedTransportSwitching ?? _transportList.first;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero image + gradient ────────────────────────────────
          _HeroSection(selected: selected, gradient: _buildGradient(selected.color1, selected.color2)),

          // ── Transport type switcher ──────────────────────────────
          _TransportSwitcher(
            list: _transportList,
            selected: selected,
            gradient: _buildGradient,
          ),

          SizedBox(height: 16.h),

          // ── Search + results ─────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BestPathDestination(icon: selected.icon),
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero image section
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final TransportSwitiching selected;
  final LinearGradient gradient;

  const _HeroSection({required this.selected, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Image.asset(
            selected.image,
            key: ValueKey(selected.title),
            height: 200.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(gradient: gradient),
        ),
        // Title overlay
        Positioned(
          bottom: 20.h,
          left: 20.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppText.planYourRoute,
                style: AppStyle.regular16RobotoBlack.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                selected.title.name[0].toUpperCase() +
                    selected.title.name.substring(1),
                style: AppStyle.bold14RobotoBlue.copyWith(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Transport type switcher — pill style
// ─────────────────────────────────────────────────────────────────────────────

class _TransportSwitcher extends StatelessWidget {
  final List<TransportSwitiching> list;
  final TransportSwitiching selected;
  final LinearGradient Function(Color, Color) gradient;

  const _TransportSwitcher({
    required this.list,
    required this.selected,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: list.map((t) {
          final isSelected = t == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<RoutesCubit>().changeTransportType(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? t.color1.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? t.color1
                        : Colors.grey.withOpacity(0.18),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? t.color1
                            : Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        t.icon,
                        size: 18.sp,
                        color: isSelected ? Colors.white : Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      t.title.name,
                      style: AppStyle.regular16RobotoBlack.copyWith(
                        fontSize: 12.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? t.color1 : AppColor.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}