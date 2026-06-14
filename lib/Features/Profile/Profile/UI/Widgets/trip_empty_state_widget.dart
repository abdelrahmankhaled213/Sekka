import 'package:flutter/material.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class TripEmptyStateWidget extends StatelessWidget {
  const TripEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration:  BoxDecoration(
                color: AppColor.main.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_transit_outlined,
                size: 48,
                color: AppColor.main,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No trips found',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t taken any trips with this transport '
                  'mode yet. Start exploring Sekka-powered metro and '
                  'monorail routes.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF9E9E9E),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.explore_rounded, size: 18),
              label: const Text('Explore Routes'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.main ,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
