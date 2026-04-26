import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Navigation/nav_entities.dart';

class AnimatedNavItem extends StatelessWidget {
  const AnimatedNavItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final NavItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey(isSelected),
                  size: isSelected ? 26 : 22,
                  color: isSelected
                      ? AppColor.main
                      : AppColor.textSecondary,
                ),
              ),
              
              const SizedBox(height: 2),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: isSelected ? 12.sp : 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColor.main
                      : AppColor.textSecondary,
                ),
                child: Text(item.label),
              )
            ],
          ),
        ),
      ),
    );
  }
}