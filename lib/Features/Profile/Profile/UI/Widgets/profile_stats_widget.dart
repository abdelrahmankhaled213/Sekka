// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sekka/Features/Profile/Profile/Data/Model/trip_history_model.dart';
// import 'package:sekka/Features/Profile/Profile/Logic/trip_history_cubit.dart';
// import 'package:sekka/Features/Profile/Profile/Logic/trip_history_state.dart';
// import 'package:sekka/core/constants/app_color.dart';
//
// class ProfileStatsWidget extends StatelessWidget {
//   const ProfileStatsWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TripHistoryCubit, TripHistoryState>(
//       builder: (context, state) {
//         final totalTrips = state.totalTrips;
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withAlpha(15),
//                 blurRadius: 16,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           padding:
//           const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
//           child: Row(
//             children: [
//               _StatItem(
//                 icon: Icons.directions_transit_rounded,
//                 iconColor: AppColor.main,
//                 iconBg: AppColor.main.withOpacity(0.1),
//                 value: totalTrips.toString(),
//                 label: 'Total Trips',
//               ),
//               _StatDivider(),
//               _StatItem(
//                 icon: Icons.route_rounded,
//                 iconColor: AppColor.main,
//                 iconBg: AppColor.main.withOpacity(0.1),
//                 label: 'Travel Time',
//               ),
//
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _StatItem extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final Color iconBg;
//   final String value;
//   final String label;
//
//   const _StatItem({
//     required this.icon,
//     required this.iconColor,
//     required this.iconBg,
//     required this.value,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: iconBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: iconColor, size: 22),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: theme.textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF1A1A1A),
//               fontFeatures: const [FontFeature.tabularFigures()],
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             label,
//             style: theme.textTheme.labelSmall
//                 ?.copyWith(color: const Color(0xFF9E9E9E)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _StatDivider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: 1, height: 56, color: const Color(0xFFF0F0F0));
//   }
// }
