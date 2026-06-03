import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
  
class TransportFilterChips extends StatelessWidget {

  final TransportType? selected;
  final ValueChanged<TransportType?> onChanged;

  const TransportFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _types = [
     null,
    TransportType.metro,
    TransportType.monorail,
    TransportType.bus,
    TransportType.microbus,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:         EdgeInsets.symmetric(horizontal: 16.w),
        itemCount:       _types.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final type       = _types[i];
          final isSelected = selected == type;
          final label      =  TransportUIHelper.label(type);
          final icon      =  TransportUIHelper.icon(type);
          final color      = TransportUIHelper.color(type);

          return GestureDetector(
            onTap: () => onChanged(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? color : AppColor.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? color : AppColor.outline,
                  width: isSelected ? 0 : 0.8,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: color.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 2))]
                    : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Icon(icon , size: 16.sp, color: isSelected ? Colors.white : color),
                 
                  SizedBox(width: 5.w),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize:   12.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: isSelected ? Colors.white : AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


}
