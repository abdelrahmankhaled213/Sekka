import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/Profile/Logic/trip_history_cubit.dart';
import 'package:sekka/Features/Profile/Logic/trip_history_state.dart';

class ProfileStatsWidget extends StatelessWidget {
  const ProfileStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripHistoryCubit, TripHistoryState>(
      builder: (context, state) {
        final isLoading =
            state.tripStateEnum == TripStateEnum.loading ||
                state.tripStateEnum == TripStateEnum.initial;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: isLoading
              ? const _LoadingStats()
              : Row(
            children: [
              _StatItem(
                icon: Icons.train_rounded,
                label: 'Metro',
                count: state.metroTripsCount,
                color: const Color(0xFF1565C0),
              ),
              _Divider(),
              _StatItem(
                icon: Icons.tram_rounded,
                label: 'Monorail',
                count: state.monorailTripsCount,
                color: const Color(0xFF6A1B9A),
              ),
              _Divider(),
              _StatItem(
                icon: Icons.directions_bus_rounded,
                label: 'Bus',
                count: state.busTripsCount,
                color: const Color(0xFF2E7D32),
              ),
              _Divider(),
              _StatItem(
                icon: Icons.directions_bus_filled_rounded,
                label: 'BRT',
                count: state.brtTripsCount,
                color: const Color(0xFFDC2626),
              ),
              _Divider(),
              _StatItem(
                icon: Icons.route_rounded,
                label: 'Total',
                count: state.totalTripsCount,
                color: AppColor.main,
                isHighlighted: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Single stat cell ─────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final bool isHighlighted;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(isHighlighted ? 30 : 20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: isHighlighted ? color : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: Theme.of(context).dividerColor.withAlpha(80),
    );
  }
}


class _LoadingStats extends StatelessWidget {
  const _LoadingStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
            (i) => Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 28,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(40),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 36,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}