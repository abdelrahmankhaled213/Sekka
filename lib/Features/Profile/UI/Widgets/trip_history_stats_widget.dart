import 'package:flutter/material.dart';
import 'package:sekka/core/theme/app_colors.dart';

class TripHistoryStatsWidget extends StatelessWidget {
  final int totalTrips;
  final int completedTrips;
  final double totalSpentEGP;

  const TripHistoryStatsWidget({
    super.key,
    required this.totalTrips,
    required this.completedTrips,
    required this.totalSpentEGP,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB71C1C), Color(0xFFD32F2F)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding:
      const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      child: Row(
        children: [
          _StatItem(
            value: totalTrips.toString(),
            label: 'Total Trips',
            icon: Icons.route_rounded,
          ),
          _VerticalDivider(),
          _StatItem(
            value: completedTrips.toString(),
            label: 'Completed',
            icon: Icons.check_circle_outline_rounded,
          ),
          _VerticalDivider(),
          _StatItem(
            value: 'EGP ${totalSpentEGP.toStringAsFixed(0)}',
            label: 'Total Spent',
            icon: Icons.payments_outlined,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 48, color: Colors.white24);
  }
}
