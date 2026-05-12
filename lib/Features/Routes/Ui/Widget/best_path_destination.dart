import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Logic/routes_state.dart';
import 'package:sekka/Features/Routes/Ui/Widget/paginated_search_dropdown.dart';
import 'package:sekka/Features/Routes/Ui/Widget/routes_widget.dart';

class BestPathDestination extends StatelessWidget {
  final IconData icon;
 
  const BestPathDestination({super.key, required this.icon});
 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutesCubit, RoutesState>(
      builder: (context, state) {
        final cubit = context.read<RoutesCubit>();
        final accentColor =
            state.selectedTransportSwitching?.color1 ?? AppColor.darkBlue;
 
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search card ──────────────────────────────────────────
            _SearchCard(accentColor: accentColor, cubit: cubit, state: state),
 
            const SizedBox(height: 16),
 
            // ── Results ──────────────────────────────────────────────
            _ResultsSection(state: state, accentColor: accentColor),
          ],
        );
      },
    );
  }
}
 
class _SearchCard extends StatelessWidget {
  final Color accentColor;
  final RoutesCubit cubit;
  final RoutesState state;
 
  const _SearchCard({
    required this.accentColor,
    required this.cubit,
    required this.state,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── From / To inputs ────────────────────────────────────
          _InputsRow(accentColor: accentColor, cubit: cubit, state: state),
 
          SizedBox(height: 14.h),
 
          // ── Search button ────────────────────────────────────────
          _SearchButton(accentColor: accentColor, cubit: cubit, state: state),
        ],
      ),
    );
  }
}
 
class _InputsRow extends StatelessWidget {
  final Color accentColor;
  final RoutesCubit cubit;
  final RoutesState state;
 
  const _InputsRow({
    required this.accentColor,
    required this.cubit,
    required this.state,
  });
 
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       
        Column(
          children: [
            _Dot(color: accentColor, filled: true),
            SizedBox(
              height: 28.h,
              child: VerticalDivider(
                color: accentColor.withOpacity(0.25),
                thickness: 1.5,
                width: 20,
              ),
            ),
            _Dot(color: AppColor.error, filled: false),
          ],
        ),
 
        SizedBox(width: 10.w),
 
        // Input fields
        Expanded(
          child: Column(
            children: [
              _StopField(
                hint: "Start",
                controller: cubit.selectedStartController,
                isStart: true,
                accentColor: accentColor,
              ),
              SizedBox(height: 6.h),
              _StopField(
                hint: "End",
                controller: cubit.selectedEndController,
                isStart: false,
                accentColor: AppColor.error,
              ),
            ],
          ),
        ),
 
        SizedBox(width: 8.w),
 
        GestureDetector(
          onTap: cubit.replaceMetroStations,
          child: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor.withOpacity(0.3),
                width: 1.5,
              ),
              color: accentColor.withOpacity(0.05),
            ),
            child: Icon(
              Icons.swap_vert_rounded,
              size: 18.sp,
              color: accentColor,
            ),
          ),
        ),
      ],
    );
  }
}
 
class _Dot extends StatelessWidget {
  final Color color;
  final bool filled;
 
  const _Dot({required this.color, required this.filled});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : Colors.white,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}
 
class _StopField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isStart;
  final Color accentColor;
 
  const _StopField({
    required this.hint,
    required this.controller,
    required this.isStart,
    required this.accentColor,
  });
 
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoutesCubit>();
    return PaginatedSearchDropdown(
      controller: controller,
      isStart: isStart,
      isLoading: context.watch<RoutesCubit>().state.isLoading,
      hasMore: context.watch<RoutesCubit>().state.hasMore,
      onLoadMore: cubit.fetchTransports,
      onSearch: (q) => cubit.searchMetros(searchText: q),
      onSelected: (Transport t) {
        if (isStart) {
          cubit.selectMetroStart(t);
        } else {
          cubit.selectMetroEnd(t);
        }
      },
      hint: hint,
    );
  }
}
 
class _SearchButton extends StatelessWidget {
  final Color accentColor;
  final RoutesCubit cubit;
  final RoutesState state;
 
  const _SearchButton({
    required this.accentColor,
    required this.cubit,
    required this.state,
  });
 
  bool get _isLoading =>
      state.routesStateEnum == RoutesStateEnum.gettingRoutePathLoading;
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : cubit.getRoutePath,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          disabledBackgroundColor: accentColor.withOpacity(0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.r),
          ),
        ),
        icon: _isLoading
            ? SizedBox(
                width: 16.w,
                height: 16.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(Icons.bolt_rounded, size: 18.sp),
        label: Text(
          _isLoading ? "Searching" : AppText.search,
          style: AppStyle.regular16RobotoBlack.copyWith(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
 
class _ResultsSection extends StatelessWidget {
  final RoutesState state;
  final Color accentColor;
 
  const _ResultsSection({required this.state, required this.accentColor});
 
  @override
  Widget build(BuildContext context) {
    final routeState = state.routesStateEnum;
 
    if (routeState == RoutesStateEnum.gettingRoutePathLoading) {
      return _SkeletonResults();
    }
 
    if (routeState == RoutesStateEnum.gettingRoutePathError) {
      return _ErrorState(message: state.errorMessage ?? 'Something went wrong');
    }
 
    if (routeState == RoutesStateEnum.gettingRoutePathLoaded) {
      final segments = state.segments ?? [];
      if (segments.isEmpty) {
        return _EmptyRouteState(accentColor: accentColor);
      }
      return _SegmentsList(segments: segments);
    }
 
    return const SizedBox.shrink();
  }
}
 
class _SegmentsList extends StatelessWidget {
  final List<SegmentModel> segments;
 
  const _SegmentsList({required this.segments});
 
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: segments.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, i) => RouteWidget(
        segment: segments[i],
        isLastSegment: i == segments.length - 1,
      ),
    );
  }
}
 
class _SkeletonResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (i) => Container(
          margin: EdgeInsets.only(bottom: 10.h),
          height: 180.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: const _ShimmerBox(),
        ),
      ),
    );
  }
}
 
class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox();
 
  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}
 
class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
 
  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
          ..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }
 
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: LinearGradient(
            begin: Alignment(-1 + _anim.value * 2, 0),
            end: Alignment(1 + _anim.value * 2, 0),
            colors: const [
              Color(0xFFEEEEEE),
              Color(0xFFF8F8F8),
              Color(0xFFEEEEEE),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _ErrorState extends StatelessWidget {
  final String message;
 
  const _ErrorState({required this.message});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: AppColor.error.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.error.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColor.error, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: AppStyle.regular16RobotoBlack.copyWith(
                fontSize: 13.sp,
                color: AppColor.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
class _EmptyRouteState extends StatelessWidget {
  final Color accentColor;
 
  const _EmptyRouteState({required this.accentColor});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Icon(Icons.route_outlined, size: 48.sp, color: Colors.grey.shade400),
          SizedBox(height: 12.h),
          Text(
            'No route found',
            style: AppStyle.bold14RobotoBlue.copyWith(
              fontSize: 15.sp,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Try selecting different stops',
            style: AppStyle.w60012RobotoGrey.copyWith(fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}