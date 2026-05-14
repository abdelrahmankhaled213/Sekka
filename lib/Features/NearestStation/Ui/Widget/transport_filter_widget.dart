import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_state.dart';

class TransportFilterWidget extends StatelessWidget {
  
  const TransportFilterWidget({super.key});

  static const _filters = [
    _FilterItem(label: 'All',      icon: Icons.location_on,     type: null),
    _FilterItem(label: 'Metro',    icon: Icons.subway,           type: TransportType.metro),
    _FilterItem(label: 'Monorail', icon: Icons.train,            type: TransportType.monorail),
    _FilterItem(label: 'Bus',      icon: Icons.directions_bus,   type: TransportType.bus),
    _FilterItem(label: 'Microbus', icon: Icons.airport_shuttle,  type: TransportType.microbus),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearestStationCubit, NearestStationState>(
      buildWhen: (p, c) => p.selectedFilter != c.selectedFilter,
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: _filters.asMap().entries.map((entry) {
              final i = entry.key;
              final f = entry.value;
              final isSelected = f.type == state.selectedFilter;
              return Padding(
                padding: EdgeInsets.only(right: i < _filters.length - 1 ? 8.w : 0),
                child: _FilterChip(
                  item: f,
                  isSelected: isSelected,
                  onTap: () => context.read<NearestStationCubit>().applyFilter(f.type),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _FilterItem {
  final String label;
  final IconData icon;
  final TransportType? type;
  const _FilterItem({required this.label, required this.icon, required this.type});
}

class _FilterChip extends StatelessWidget {
  final _FilterItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : AppColor.outline,
          ),
          boxShadow: isSelected
              ? [BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 14.sp,
              color: isSelected ? Colors.white : AppColor.grey,
            ),
            SizedBox(width: 5.w),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColor.grey,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}