import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'profile_section_card.dart';

class PreferredTransportSection extends StatelessWidget {

  const PreferredTransportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
           Text(
            AppText.preferredTransport,
            style:AppStyle.regular16RobotoBlack,
          ),

           SizedBox(height: 14.h),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffEEF2F8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.blue.withOpacity(.3)),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff3A7BFF) 
                        , Color(0xff1E5AEF)
                        ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.train, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Metro",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    SizedBox(height: 2),
                    Text("1 trips",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}