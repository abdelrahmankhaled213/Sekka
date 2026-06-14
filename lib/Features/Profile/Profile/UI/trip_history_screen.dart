import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/trip_history_model.dart';
import 'package:sekka/Features/Profile/Profile/Logic/trip_history_cubit.dart';
import 'package:sekka/Features/Profile/Profile/Logic/trip_history_state.dart';
import 'package:sekka/Features/Profile/Profile/UI/Widgets/trip_card_widget.dart';
import 'package:sekka/Features/Profile/Profile/UI/Widgets/trip_empty_state_widget.dart';
import 'package:sekka/Features/Profile/Profile/UI/Widgets/trip_filter_chips_widget.dart';
import 'package:sekka/Features/Profile/Profile/UI/Widgets/trip_history_stats_widget.dart';

import '../../../../core/constants/app_color.dart';




class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _listAnimController;

  @override
  void initState() {
    super.initState();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();


  }

  @override
  void dispose() {
    _listAnimController.dispose();
    super.dispose();
  }

  void _onFilterChanged(String filter) {
    context.read<TripHistoryCubit>().setFilter(filter);
    _listAnimController.reset();
    _listAnimController.forward();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TripHistoryCubit, TripHistoryState>(
          builder: (context, state) {
            // ── Loading ───────────────────────────────────────────────────
            if (state.status == TripHistoryStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                    color: AppColor.main),
              );
            }

            // ── Error ─────────────────────────────────────────────────────
            if (state.status == TripHistoryStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          size: 56, color: Color(0xFF9E9E9E)),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ??
                            'Failed to load trips',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(
                            color: const Color(0xFF9E9E9E)),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context
                            .read<TripHistoryCubit>()
                            .loadTrips(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColor.main,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final trips = state.filteredTrips;

            // Counts for filter chips (over all trips, not just filtered)
            final counts = {
              'all': state.trips.length,
              'metro': state.trips
                  .where((t) => t.mode == 'metro')
                  .length,
              'monorail': state.trips
                  .where((t) => t.mode == 'monorail')
                  .length,
              'bus':
              state.trips.where((t) => t.mode == 'bus').length,
              'microbus': state.trips
                  .where((t) => t.mode == 'microbus')
                  .length,
            };


            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── App bar ────────────────────────────────────────────────
                SliverAppBar(
                  backgroundColor: AppColor.main,
                  foregroundColor: Colors.white,
                  pinned: true,
                  elevation: 0,
                  scrolledUnderElevation: 2,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: Colors.white),
                    ),
                  ),
                  title: Text(
                    'Trip History',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // TODO: wire up export functionality
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                            Icons.download_rounded,
                            size: 18,
                            color: Colors.white),
                      ),
                      tooltip: 'Export',
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // ── Stats + filter chips ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                        isTablet ? 800 : double.infinity,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 16, 16, 0),
                            child:
                          TripFilterChipsWidget(
                            selectedFilter:
                            state.selectedFilter,
                            onFilterChanged: _onFilterChanged,
                            tripCounts: counts,
                          ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Trip list / grid ───────────────────────────────────────
                if (trips.isEmpty)
                  const SliverFillRemaining(
                      child: TripEmptyStateWidget())
                else if (isTablet)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 8, 16, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final delay =
                          (index * 60).clamp(0, 400);
                          return _AnimatedTripCard(
                            trip: trips[index],
                            animationController:
                            _listAnimController,
                            delayMs: delay,
                          );
                        },
                        childCount: trips.length,
                      ),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.6,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 8, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final delay =
                          (index * 60).clamp(0, 400);
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12),
                            child: _AnimatedTripCard(
                              trip: trips[index],
                              animationController:
                              _listAnimController,
                              delayMs: delay,
                            ),
                          );
                        },
                        childCount: trips.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Animated trip card ───────────────────────────────────────────────────────

class _AnimatedTripCard extends StatelessWidget {
  final dynamic trip; // TripHistoryModel
  final AnimationController animationController;
  final int delayMs;

  const _AnimatedTripCard({
    required this.trip,
    required this.animationController,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    final startInterval =
    (delayMs / 1000.0).clamp(0.0, 0.8);
    final endInterval =
    (startInterval + 0.4).clamp(0.0, 1.0);

    final slideAnim = Tween<Offset>(
        begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(startInterval, endInterval,
          curve: Curves.easeOutCubic),
    ));

    final fadeAnim =
    Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(startInterval, endInterval,
            curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => SlideTransition(
        position: slideAnim,
        child: FadeTransition(opacity: fadeAnim, child: child),
      ),
      child: TripCardWidget(trip: trip),
    );
  }
}
