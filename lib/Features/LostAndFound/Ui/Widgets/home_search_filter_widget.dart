import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Widget/custom_text_field.dart';
import 'package:sekka/core/constants/app_style.dart';

class HomeSearchFilterWidget extends StatelessWidget {
  
  final String activeFilter;
  final String activeCategory;
  final String searchQuery;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;

  const HomeSearchFilterWidget({
    super.key,
    required this.activeFilter,
    required this.activeCategory,
    required this.searchQuery,
    required this.onFilterChanged,
    required this.onCategoryChanged,
    required this.onSearchChanged,
  });

static final List<BoxShadow>active=[
    BoxShadow(
    color: AppColor.secondary.withAlpha(77),
    blurRadius: 8,
    offset: const Offset(0, 3),
             )
];

static final List<BoxShadow>inactive=[
     BoxShadow(
      color: Colors.black.withAlpha(10),
      blurRadius: 4,
      offset: const Offset(0, 1),
                                ),
];

static final List<BoxShadow>shadowTextField=[
        BoxShadow(
        color: Colors.black.withAlpha(20),
        blurRadius: 16,
        offset: const Offset(0, 4),
          ),
];
static final List<BoxShadow>categoryChip=
[
     BoxShadow(
       color: AppColor.secondary.withAlpha(64),
       blurRadius: 6,
       offset: const Offset(0, 2),
                    ),
                  ];

static const List<CategoryChipModel> categories = [
  CategoryChipModel('All', Icons.apps_rounded),
  CategoryChipModel('Phone', Icons.phone_android_rounded),
  CategoryChipModel('Wallet', Icons.account_balance_wallet_outlined),
  CategoryChipModel('Bag', Icons.work_outline_rounded),
  CategoryChipModel('Keys', Icons.key_outlined),
  CategoryChipModel('Other', Icons.inventory_2_outlined),
];


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, 0),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: shadowTextField
              ),
              child: MyTextFormField(
                onChange: (value) =>
                  onSearchChanged(value!),
                hint:"Search lost & found items..."
              ,hintStyle:AppStyle.regular11RobotoGrey.copyWith(
                fontSize: 14.sp,
              ) , )
            ),
          ),

           SizedBox(height: 14.h),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Lost', 'Found'].map((filter) {
                final isActive = activeFilter == filter;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onFilterChanged(filter),
                    child: _buildAnimatedContainer(isActive, filter),
                  ),
                );
              }).toList(),
            ),
          ),
           SizedBox(height: 12.h),
          // Category chips
          SizedBox(
            height: 40.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _buildCategoryChips(context),
            ),
          ),
           SizedBox(height: 16.h),
        ],
      ),
    );
  }

Widget _buildAnimatedContainer(bool isActive, String filter) {

  return  AnimatedContainer(
           duration: const Duration(milliseconds: 200),
           curve: Curves.easeOutCubic,
           margin: EdgeInsets.symmetric(horizontal: 4.w),
           padding: const EdgeInsets.symmetric(vertical: 10),
           decoration: BoxDecoration(
           gradient: isActive ?AppStyle.brandGradient : null,
           color: isActive ? null : AppColor.surface,
           borderRadius: BorderRadius.circular(12),
           boxShadow: isActive
                            ? active
                            :inactive,
                      ),
                      child: Text(
                        filter,
                        textAlign: TextAlign.center,
                        style: AppStyle.regular16RobotoBlack.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.white
                              : AppColor.textSecondary,
                        ),
                      ),
                    );
}



  List<Widget> _buildCategoryChips(BuildContext context) {

    return categories.map((cat) {

      final isActive = activeCategory == cat.label;
      return GestureDetector(
        onTap: () => onCategoryChanged(cat.label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          margin:  EdgeInsets.only(right: 8.w),
          padding:  EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: isActive ? AppStyle.brandGradient : null,
            color: isActive ? null : AppColor.surface,
            borderRadius: BorderRadius.circular(20),
            border: isActive
                ? null
                : Border.all(color: AppColor.outline, width: 1.5),
            boxShadow: isActive
                ? categoryChip
                : null,
          ),
          child: Row(
            children: [
              Icon(
                cat.icon,
                size: 15.sp,
                color: isActive ? Colors.white : AppColor.textSecondary,
              ),
               SizedBox(width: 5.w),
              Text(
                cat.label,
                style: AppStyle.w60012RobotoGrey.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}



class CategoryChipModel {
  final String label;
  final IconData icon;

  const CategoryChipModel(this.label, this.icon);
}

