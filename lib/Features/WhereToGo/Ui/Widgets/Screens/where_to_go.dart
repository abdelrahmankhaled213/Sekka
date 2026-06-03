import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/search_card.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/segment_card.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/suggestions.dart';
import 'package:sekka/Features/WhereToGo/Ui/Widgets/summary.dart';
import 'package:sekka/core/theme/app_colors.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class WhereToGoScreen extends StatefulWidget {

  const WhereToGoScreen({super.key});

  @override
  State<WhereToGoScreen> createState() => _WhereToGoScreenState();
}

class _WhereToGoScreenState extends State<WhereToGoScreen> {
  
  final _controller = TextEditingController();
  final _focus      = FocusNode();
  bool _isFocused   = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _isFocused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<WhereToGoCubit, WhereToGoState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == WhereToGoStatus.error &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SearchCard(
                    controller:  _controller,
                    focus:       _focus,
                    isFocused:   _isFocused,
                    state:       state,
                  ),
                ),

                // suggestions
                if (state.suggestions.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SuggestionsList(state: state),
                  ),

                if (state.status == WhereToGoStatus.routeReady &&
                    state.segments.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: SummaryBar(segments: state.segments),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 8.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final seg    = state.segments[i];
                          final isLast = i == state.segments.length - 1;
                          return Column(
                            children: [
                              SegmentCard(
                                  segment: seg, isLast: isLast),
                              if (!isLast)
                                _Connector(
                                    nextLine: state
                                        .segments[i + 1].lineName ?? ''),
                            ],
                          );
                        },
                        childCount: state.segments.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                ],

                // loading
                if (state.status == WhereToGoStatus.loadingRoute)
                  SliverToBoxAdapter(child: _LoadingRoute()),

                // empty state
                if (state.status == WhereToGoStatus.locationReady &&
                    state.segments.isEmpty)
                  SliverToBoxAdapter(
                    child: _EmptyHint(hasDestination: state.hasDestination),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}





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
                  color: Colors.grey.withOpacity(0.18), height: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text('change to $nextLine',
                style: TextStyle(
                    fontSize: 10.sp, color: Colors.grey.shade400)),
          ),
          Expanded(
              child: Divider(
                  color: Colors.grey.withOpacity(0.18), height: 1)),
        ],
      ),
    );
  }
}

class _LoadingRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          SizedBox(
            width: 28.w,
            height: 28.w,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.darkBlue),
          ),
          SizedBox(height: 12.h),
          Text('Finding best route…',
              style: TextStyle(
                  fontSize: 13.sp, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final bool hasDestination;

  const _EmptyHint({required this.hasDestination});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 32.w),
      child: Column(
        children: [
          Icon(Icons.route_rounded,
              size: 40.sp, color: Colors.grey.shade300),
          SizedBox(height: 12.h),
          Text(
            hasDestination
                ? 'Press "Find Route" to calculate your trip'
                : 'Enter your destination to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13.sp, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}