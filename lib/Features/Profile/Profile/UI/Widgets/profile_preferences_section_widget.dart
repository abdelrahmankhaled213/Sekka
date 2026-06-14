import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Profile/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Profile/Logic/profile_state.dart';


class ProfilePreferencesSectionWidget extends StatefulWidget {
  const ProfilePreferencesSectionWidget({super.key});

  @override
  State<ProfilePreferencesSectionWidget> createState() =>
      _ProfilePreferencesSectionWidgetState();
}

class _ProfilePreferencesSectionWidgetState
    extends State<ProfilePreferencesSectionWidget> {
  // Notifications are local-only for now; wire to your notification service.
  bool _notificationsEnabled = true;

  static final List<Map<String, dynamic>> _transportModes = [
    {
      'type': TransportType.metro,
      'label': 'Metro',
      'icon': Icons.subway_rounded,
      'color': AppColor.main,
      'bg': AppColor.main.withOpacity(0.1),
    },
    {
      'type': TransportType.monorail,
      'label': 'Monorail',
      'icon': Icons.tram_rounded,
      'color': AppColor.darkPurple,
      'bg': AppColor.darkPurple.withOpacity(0.1),
    },
    {
      'type': TransportType.bus,
      'label': 'Bus',
      'icon': Icons.directions_bus_rounded,
      'color': AppColor.green,
      'bg': AppColor .green.withOpacity(0.1),
    },
    {
      'type': TransportType.microbus,
      'label': 'Microbus',
      'icon': Icons.airport_shuttle_rounded,
      'color': AppColor.orange,
      'bg': AppColor.orange.withOpacity(0.1),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final selectedModes = state.selectedTransports;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'PREFERENCES',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF9E9E9E),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // ── Notifications toggle ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _notificationsEnabled
                            ? AppColor.successContainer
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _notificationsEnabled
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_outlined,
                        color: _notificationsEnabled
                            ? AppColor.main
                            : const Color(0xFF9E9E9E),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Notifications',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _notificationsEnabled
                                ? 'Arrival alerts & crowd predictions on'
                                : 'Notifications are disabled',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _notificationsEnabled
                                  ? AppColor.success
                                  : const Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (v) =>
                          setState(() => _notificationsEnabled = v),
                    ),
                  ],
                ),
              ),

              const Divider(
                height: 1,
                indent: 72,
                endIndent: 16,
                color: Color(0xFFF0F0F0),
              ),

              // ── Favourite transport modes ────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.favorite_rounded,
                          color: AppColor.secondary, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Favorite Transport Modes',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(color: const Color(0xFF1A1A1A)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _transportModes.map((mode) {
                    final type = mode['type'] as TransportType;
                    final isSelected = selectedModes.contains(type);
                    final modeColor = mode['color'] as Color;

                    return GestureDetector(
                      onTap: () =>
                          context.read<ProfileCubit>().toggleTransport(type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? modeColor
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? modeColor
                                : const Color(0xFFE0E0E0),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              mode['icon'] as IconData,
                              size: 16,
                              color: isSelected ? Colors.white : modeColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              mode['label'] as String,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF424242),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.check_rounded,
                                  size: 14, color: Colors.white),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
