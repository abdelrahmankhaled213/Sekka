import 'package:flutter/material.dart';
import 'package:sekka/core/theme/app_colors.dart';


class TripFilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final Map<String, int> tripCounts;

  const TripFilterChipsWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.tripCounts,
  });

  static const List<Map<String, dynamic>> _filters = [
    {'id': 'all', 'label': 'All Trips', 'icon': Icons.list_rounded},
    {'id': 'metro', 'label': 'Metro', 'icon': Icons.subway_rounded},
    {
      'id': 'monorail',
      'label': 'Monorail',
      'icon': Icons.tram_rounded
    },
    {
      'id': 'bus',
      'label': 'Bus',
      'icon': Icons.directions_bus_rounded
    },
    {
      'id': 'microbus',
      'label': 'Microbus',
      'icon': Icons.airport_shuttle_rounded
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = selectedFilter == filter['id'];
          final count = tripCounts[filter['id']] ?? 0;

          return GestureDetector(
            onTap: () => onFilterChanged(filter['id'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color:
                isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFE0E0E0),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(64),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 15,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF616161),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter['label'] as String,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF424242),
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withAlpha(64)
                            : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF616161),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
