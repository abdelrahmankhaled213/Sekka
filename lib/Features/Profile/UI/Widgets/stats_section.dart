import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_section_card.dart';

class StatsSection extends StatelessWidget {
  
  const StatsSection({required this.preferredCount});

  final int preferredCount;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: preferredCount.toString(), label: "Total Trips"),
          _StatItem(value: preferredCount.toString(), label: "Completed"),
          _StatItem(value: '\$8.00', label: "Total Spent"),
        ],
      ),
    );
  }
}
class _StatItem extends StatelessWidget {
  
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppStyle.regular16RobotoBlack),
        if (label.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(label, style: AppStyle.regular11RobotoGrey),
        ],
      ],
    );
  }
}
