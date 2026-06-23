// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sekka/Core/theme/app_colors.dart';
// import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
// import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';
// import 'package:sekka/Features/WhereToGo/Ui/Widgets/recent_trips_widget.dart';
// import 'package:sekka/Features/WhereToGo/Ui/Widgets/search_card.dart';
// import 'package:sekka/Features/WhereToGo/Ui/Widgets/segment_card.dart';
// import 'package:sekka/Features/WhereToGo/Ui/Widgets/suggestions.dart';
// import 'package:sekka/Features/WhereToGo/Ui/Widgets/summary.dart';
// import 'package:sekka/Features/WhereToGo/Ui/widgets/location_header_widget.dart';

// class WhereToGoScreen extends StatefulWidget {
//   const WhereToGoScreen({super.key});

//   @override
//   State<WhereToGoScreen> createState() => _WhereToGoScreenState();
// }

// class _WhereToGoScreenState extends State<WhereToGoScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focus = FocusNode();
//   bool _isFocused = false;
//   late AnimationController _headerAnim;
//   late Animation<double> _headerFade;

//   @override
//   void initState() {
//     super.initState();
//     _focus.addListener(() => setState(() => _isFocused = _focus.hasFocus));

//     _headerAnim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _headerFade =
//         CurvedAnimation(parent: _headerAnim, curve: Curves.easeOutCubic);
//     _headerAnim.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focus.dispose();
//     _headerAnim.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<WhereToGoCubit, WhereToGoState>(
//       listenWhen: (p, c) => p.status != c.status,
//       listener: (context, state) {
//         if (state.status == WhereToGoStatus.error &&
//             state.errorMessage != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.errorMessage!),
//               backgroundColor: AppColors.error,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r)),
//               margin: EdgeInsets.all(16.w),
//             ),
//           );
//         }
//         // When a place is selected, clear controller text display but keep cubit state
//         if (state.status == WhereToGoStatus.locationReady &&
//             state.selectedPlace != null) {
//           _controller.text = state.selectedPlace!.mainText;
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: AppColors.background,
//           body: SafeArea(
//             child: Column(
//               children: [
//                 // ── Fixed header chrome ────────────────────────────────────
//                 FadeTransition(
//                   opacity: _headerFade,
//                   child: Container(
//                     color: AppColors.surface,
//                     child: Column(
//                       children: [
//                         LocationHeaderWidget(
//                           locationLabel:
//                           state.currentLocationLabel ?? 'Cairo, Egypt',
//                           isLocating:
//                           state.status == WhereToGoStatus.locating,
//                           onLocationTap: () => context
//                               .read<WhereToGoCubit>()
//                               .fetchCurrentLocation(),
//                         ),
//                         SizedBox(height: 10.h),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: SearchCard(
//                             controller: _controller,
//                             focus: _focus,
//                             isFocused: _isFocused,
//                             state: state,
//                             onClear: () {
//                               _controller.clear();
//                               context.read<WhereToGoCubit>().reset();
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // ── Scrollable body ────────────────────────────────────────
//                 Expanded(
//                   child: _buildBody(context, state),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBody(BuildContext context, WhereToGoState state) {
//     // Suggestions list while typing
//     if (state.suggestions.isNotEmpty) {
//       return SuggestionsList(state: state);
//     }

//     // Loading spinner while calculating route
//     if (state.status == WhereToGoStatus.loadingRoute) {
//       return _LoadingRoute();
//     }

//     // Route results
//     if (state.status == WhereToGoStatus.routeReady &&
//         state.segments.isNotEmpty) {
//       return CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           SliverToBoxAdapter(child: SummaryBar(segments: state.segments)),
//           SliverPadding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//             sliver: SliverList(
//               delegate: SliverChildBuilderDelegate(
//                     (_, i) {
//                   final seg = state.segments[i];
//                   final isLast = i == state.segments.length - 1;
//                   return Column(
//                     children: [
//                       SegmentCard(segment: seg, isLast: isLast),
//                       if (!isLast)
//                         _Connector(
//                             nextLine: state.segments[i + 1].lineName ?? ''),
//                     ],
//                   );
//                 },
//                 childCount: state.segments.length,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(child: SizedBox(height: 24.h)),
//         ],
//       );
//     }

//     // Default: recent trips / suggestions
//     return RecentTripsWidget(
//       onDestinationTap: (dest) {
//         _controller.text = dest;
//         context.read<WhereToGoCubit>().onSearchChanged(dest);
//         _focus.requestFocus();
//       },
//     );
//   }
// }

// // ── Connector between segments ───────────────────────────────────────────────

// class _Connector extends StatelessWidget {
//   final String nextLine;
//   const _Connector({required this.nextLine});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         children: [
//           Expanded(
//               child: Divider(
//                   color: AppColors.outline.withOpacity(0.5), height: 1)),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8.w),
//             child: Container(
//               padding:
//               EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
//               decoration: BoxDecoration(
//                 color: AppColors.offWhite,
//                 borderRadius: BorderRadius.circular(99.r),
//                 border:
//                 Border.all(color: AppColors.outline, width: 0.5),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.swap_horiz_rounded,
//                       size: 11.sp, color: AppColors.grey),
//                   SizedBox(width: 4.w),
//                   Text(
//                     'change to $nextLine',
//                     style: TextStyle(
//                         fontSize: 10.sp, color: AppColors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//               child: Divider(
//                   color: AppColors.outline.withOpacity(0.5), height: 1)),
//         ],
//       ),
//     );
//   }
// }

// // ── Loading route ────────────────────────────────────────────────────────────

// class _LoadingRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 56.w,
//             height: 56.w,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primary.withOpacity(0.15),
//                   AppColors.secondary.withOpacity(0.15),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(14.w),
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.5,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'Finding best route…',
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500,
//               color: AppColors.textSecondary,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             'Calculating transit options for you',
//             style: TextStyle(
//               fontSize: 12.sp,
//               color: AppColors.muted,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/recent_trips_widget.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/search_card.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/segment_card.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/suggestions.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/summary.dart';
import 'package:sekka/Features/WhereToGo/Ui/widgets/location_header_widget.dart';

class WhereToGoScreen extends StatefulWidget {
  const WhereToGoScreen({super.key});

  @override
  State<WhereToGoScreen> createState() => _WhereToGoScreenState();
}

class _WhereToGoScreenState extends State<WhereToGoScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final FocusNode _fromFocus = FocusNode();
  final FocusNode _toFocus = FocusNode();

  late AnimationController _headerAnim;
  late Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();

    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFade =
        CurvedAnimation(parent: _headerAnim, curve: Curves.easeOutCubic);
    _headerAnim.forward();

    // Keep "from" field text in sync with cubit state when using GPS
    _fromFocus.addListener(() => setState(() {}));
    _toFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _fromFocus.dispose();
    _toFocus.dispose();
    _headerAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WhereToGoCubit, WhereToGoState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        // Error toast
        if (state.status == WhereToGoStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              margin: EdgeInsets.all(16.w),
            ),
          );
        }

        // Sync TO controller text when a place is selected
        if (state.status == WhereToGoStatus.locationReady &&
            state.selectedPlace != null) {
          _toController.text = state.selectedPlace!.mainText;
        }

        // Sync FROM controller text when custom from-place is resolved
        if (state.status == WhereToGoStatus.locationReady &&
            !state.useCurrentLocationAsFrom &&
            state.fromSelectedPlace != null) {
          _fromController.text = state.fromSelectedPlace!.mainText;
        }

        // When switching to GPS origin, clear the from controller
        if (state.useCurrentLocationAsFrom) {
          _fromController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ── Fixed header chrome ──────────────────────────────────
                FadeTransition(
                  opacity: _headerFade,
                  child: Container(
                    color: AppColors.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocationHeaderWidget(
                          locationLabel:
                              state.currentLocationLabel ?? 'Cairo, Egypt',
                          isLocating:
                              state.status == WhereToGoStatus.locating,
                          onLocationTap: () => context
                              .read<WhereToGoCubit>()
                              .fetchCurrentLocation(),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: RouteSearchCard(
                            fromController: _fromController,
                            toController: _toController,
                            fromFocus: _fromFocus,
                            toFocus: _toFocus,
                            state: state,
                            onClear: () {
                              _toController.clear();
                              context.read<WhereToGoCubit>().reset();
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),

                // ── Scrollable body ──────────────────────────────────────
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WhereToGoState state) {
    final cubit = context.read<WhereToGoCubit>();

    // Active suggestions (from or to field)
    final hasFromSuggestions = state.fromSuggestions.isNotEmpty &&
        state.activeField == ActiveSearchField.from;
    final hasToSuggestions = state.suggestions.isNotEmpty &&
        state.activeField == ActiveSearchField.to;

    if (hasFromSuggestions || hasToSuggestions) {
      return SuggestionsList(
        state: state,
        onSelectFrom: (place) {
          _fromFocus.unfocus();
          cubit.selectFromPlace(place);
        },
        onSelectTo: (place) {
          _toFocus.unfocus();
          cubit.selectPlace(place);
        },
      );
    }

    // Loading route
    if (state.status == WhereToGoStatus.loadingRoute) {
      return const _LoadingRoute();
    }

    // Route results
    if (state.status == WhereToGoStatus.routeReady &&
        state.segments.isNotEmpty) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SummaryBar(segments: state.segments)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final seg = state.segments[i];
                  final isLast = i == state.segments.length - 1;
                  return Column(
                    children: [
                      SegmentCard(segment: seg, isLast: isLast),
                      if (!isLast)
                        _Connector(
                            nextLine: state.segments[i + 1].lineName ?? ''),
                    ],
                  );
                },
                childCount: state.segments.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        ],
      );
    }

    // Default: recent trips
    return RecentTripsWidget(
      onDestinationTap: (dest) {
        _toController.text = dest;
        cubit.onSearchChanged(dest);
        _toFocus.requestFocus();
      },
    );
  }
}

// ── Connector between segments ────────────────────────────────────────────────

class _Connector extends StatelessWidget {
  final String nextLine;
  const _Connector({required this.nextLine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
              child: Divider(
                  color: AppColors.outline.withOpacity(0.5), height: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(99.r),
                border: Border.all(color: AppColors.outline, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swap_horiz_rounded,
                      size: 11.sp, color: AppColors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    'change to $nextLine',
                    style:
                        TextStyle(fontSize: 10.sp, color: AppColors.grey),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Divider(
                  color: AppColors.outline.withOpacity(0.5), height: 1)),
        ],
      ),
    );
  }
}

// ── Loading route ─────────────────────────────────────────────────────────────

class _LoadingRoute extends StatelessWidget {
  const _LoadingRoute();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.12),
                  AppColors.secondary.withOpacity(0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.12),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Finding best route…',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Calculating transit options for you',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}