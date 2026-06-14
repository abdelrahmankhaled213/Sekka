import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_colors.dart';

class CategoryChipRowWidget extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryChipRowWidget({
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  static const List<_ChipData> _categories = [
    _ChipData(label: 'All', icon: Icons.apps_rounded),
    _ChipData(label: 'Metro', icon: Icons.subway_rounded),
    _ChipData(label: 'Monorail', icon: Icons.train_rounded),
    _ChipData(label: 'Microbus', icon: Icons.directions_bus_rounded),
    _ChipData(label: 'Malls', icon: Icons.local_mall_rounded),
    _ChipData(label: 'Parks', icon: Icons.park_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final chip = _categories[index];
          final isSelected = selectedCategory == chip.label;
          return _AnimatedChip(
            chip: chip,
            isSelected: isSelected,
            onTap: () => onCategorySelected(chip.label),
          );
        },
      ),
    );
  }
}

class _AnimatedChip extends StatefulWidget {
  final _ChipData chip;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedChip({
    required this.chip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<_AnimatedChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding:
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary
                : AppColors.surface,
            borderRadius: BorderRadius.circular(99.r),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : AppColors.outline,
              width: 1.2,
            ),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.28),
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
                widget.chip.icon,
                size: 13.sp,
                color: widget.isSelected
                    ? Colors.white
                    : AppColors.grey,
              ),
              SizedBox(width: 5.w),
              Text(
                widget.chip.label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: widget.isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipData {
  final String label;
  final IconData icon;
  const _ChipData({required this.label, required this.icon});
}
