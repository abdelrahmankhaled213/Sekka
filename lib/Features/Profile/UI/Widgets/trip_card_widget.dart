import 'package:flutter/material.dart';
import 'package:sekka/Core/Constants/app_color.dart';

import '../../Data/Model/trip_history_model.dart';

/// ──────────────────────────────────────────────────────────────────────────
/// TripCardWidget
/// Single trip card for the history list. Accepts [TripHistoryModel].
/// Path: lib/Features/Profile/UI/Widgets/trip_card_widget.dart
/// ──────────────────────────────────────────────────────────────────────────
class TripCardWidget extends StatelessWidget {
  final TripHistoryModel trip;

  const TripCardWidget({super.key, required this.trip});

  // ── Helpers ──────────────────────────────────────────────────────────────

  static Color _modeColor(String? mode) {
    switch (mode) {
      case 'metro':
        return AppColor.main;
      case 'monorail':
        return AppColor.darkPurple;
      case 'bus':
        return AppColor.green;
      case 'microbus':
        return AppColor.orange;
      default:
        return AppColor.main;
    }
  }

  static Color _modeBg(String? mode) {
    switch (mode) {
      case 'metro':
        return AppColor.grey.withAlpha(30);
      case 'monorail':
        return const Color(0xFFF3E5F5);
      case 'bus':
        return AppColor.successContainer;
      case 'microbus':
        return AppColor.warningContainer;
      default:
        return AppColor.grey.withAlpha(30);
    }
  }

  static IconData _modeIcon(String? mode) {
    switch (mode) {
      case 'metro':
        return Icons.subway_rounded;
      case 'monorail':
        return Icons.tram_rounded;
      case 'bus':
        return Icons.directions_bus_rounded;
      case 'microbus':
        return Icons.airport_shuttle_rounded;
      default:
        return Icons.train_rounded;
    }
  }

  static String _modeLabel(String? mode) {
    switch (mode) {
      case 'metro':
        return 'Metro';
      case 'monorail':
        return 'Monorail';
      case 'bus':
        return 'Bus';
      case 'microbus':
        return 'Microbus';
      default:
        return 'Transit';
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modeColor = _modeColor(trip.mode);
    final modeBg = _modeBg(trip.mode);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        splashColor: modeBg,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Mode badge + route code + status ────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: modeBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_modeIcon(trip.mode),
                            size: 14, color: modeColor),
                        const SizedBox(width: 5),
                        Text(
                          _modeLabel(trip.mode),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(
                            color: modeColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trip.routeCode != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        trip.routeCode!,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(
                          color: const Color(0xFF424242),
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [
                            FontFeature.tabularFigures()
                          ],
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
              //     Container(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 10, vertical: 5),
              //       decoration: BoxDecoration(
              //         color: statusStyle['bg'] as Color,
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Icon(statusStyle['icon'] as IconData,
              //               size: 12,
              //               color: statusStyle['color'] as Color),
              //           const SizedBox(width: 4),
              //           Text(
              //             statusStyle['label'] as String,
              //             style: theme.textTheme.labelSmall
              //                 ?.copyWith(
              //               color: statusStyle['color'] as Color,
              //               fontWeight: FontWeight.w700,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

              const SizedBox(height: 14),

              // ── Route from → to ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FROM',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(
                              color: const Color(0xFF9E9E9E),
                              letterSpacing: 0.8,
                              fontSize: 10,
                            )),
                        const SizedBox(height: 2),
                        Text(
                          trip.fromStation,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    child: Row(
                      children: [
                        Container(
                            width: 20,
                            height: 1.5,
                            color: const Color(0xFFBDBDBD)),
                        Icon(Icons.flight_rounded,
                            size: 18, color: modeColor),
                        Container(
                            width: 20,
                            height: 1.5,
                            color: const Color(0xFFBDBDBD)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('TO',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(
                              color: const Color(0xFF9E9E9E),
                              letterSpacing: 0.8,
                              fontSize: 10,
                            )),
                        const SizedBox(height: 2),
                        Text(
                          trip.toStation,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ── Meta row ─────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _MetaChip(
                      icon: Icons.calendar_today_rounded,
                      value: trip.dateTime,
                      flex: 2,
                    ),
                    _MetaDivider(),
                    _MetaChip(
                      icon: Icons.timer_outlined,
                      value: trip.durationMin != null
                          ? '${trip.durationMin} min'
                          : '—',
                    ),
                    _MetaDivider(),
                    _MetaChip(
                      icon: Icons.payments_outlined,
                      value: trip.fareEGP != null
                          ? 'EGP ${trip.fareEGP!.toStringAsFixed(0)}'
                          : '—',
                      valueColor: AppColor.main,
                    ),
                  ],
                ),
              ),
            ],
          ),
        
        
     ] ),
    )
  ));
    
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color? valueColor;
  final int flex;

  const _MetaChip({
    required this.icon,
    required this.value,
    this.valueColor,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF9E9E9E)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.labelSmall?.copyWith(
                color: valueColor ?? const Color(0xFF424242),
                fontWeight: valueColor != null
                    ? FontWeight.w700
                    : FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFFE0E0E0),
    );
  }
}
