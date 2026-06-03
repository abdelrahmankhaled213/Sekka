import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_radius.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

class SuggestionsList extends StatelessWidget {
 
  final WhereToGoState state;

  const SuggestionsList({super.key,required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: AppRadius.allLG,
        border: Border.all(
            color: Colors.grey.withOpacity(0.12), width: 0.5),
      ),
      child: ListView.separated(
        shrinkWrap:  true,
        physics:     const NeverScrollableScrollPhysics(),
        itemCount:   state.suggestions.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey.withOpacity(0.08)),
        itemBuilder: (_, i) {
          final place = state.suggestions[i];
          return ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
            leading: Container(
              width:  32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color:        Colors.grey.shade50,
                borderRadius: AppRadius.allMD,
                border: Border.all(
                    color: Colors.grey.withOpacity(0.12), width: 0.5),
              ),
              child: Icon(Icons.location_on_rounded,
                  size: 16.sp, color: Colors.grey.shade400),
            ),
            title: Text(
              place.mainText,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: Colors.black87),
            ),
            subtitle: Text(
              place.secondaryText,
              style: TextStyle(
                  fontSize: 11.sp, fontFamily: 'Roboto', color: Colors.grey.shade500),
            ),
            onTap: () =>
                context.read<WhereToGoCubit>().selectPlace(place),
          );
        },
      ),
    );
  }
}