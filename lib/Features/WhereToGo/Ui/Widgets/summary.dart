import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Core/theme/app_radius.dart';

class SummaryBar extends StatelessWidget {

  final List<SegmentModel> segments;

  const SummaryBar({super.key,required this.segments});

  @override
  Widget build(BuildContext context) {
    final totalMin  = segments.fold(0, (sum, segment) => sum + segment.durationMinutes);
    final totalCost = segments.fold(0, (sum, segment) => sum + segment.ticketPrice);
    // final transfers = segments.fold(0, (sum, segment) => sum + segment.transfers) - 1;
    final hours     = totalMin ~/ 60;
    final mins      = totalMin % 60;
    final timeLabel = hours > 0 ? '${hours}h ${mins}m' : '${mins} min';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: AppRadius.allLG,
        border: Border.all(
            color: Colors.grey.withOpacity(0.12), width: 0.5),
      ),
      child: Row(
        children: [
          _SummaryChip(
              value: timeLabel,
              label: 'est. time',
              icon: Icons.access_time_rounded),
          _SummaryDivider(),
          _SummaryChip(
              value: 'EGP ${totalCost.toStringAsFixed(0)}',
              label: 'total cost',
              icon: Icons.payments_outlined),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _SummaryChip({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16.sp, color: AppColors.muted),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: 10.sp, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 0.5, height: 36.h, color: Colors.grey.shade200);
}




