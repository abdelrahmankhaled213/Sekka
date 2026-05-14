import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Core/Widget/custom_image_widget.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/status_badge_widget.dart';
import 'package:sekka/core/constants/app_color.dart';

class PostCardWidget extends StatelessWidget {

  final ItemModel postData;
  final void Function()? onTap;

  const PostCardWidget({
    super.key,
    required this.postData,
    required this.onTap,
  });

  @override

  Widget build(BuildContext context) {

    final isFound = postData.type == ItemType.found;
    final isResolved = postData.isActive;
    final accentColor = isFound ? AppColor.success : AppColor.error;

    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color:  AppColor.surfaceVariant ,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(left: BorderSide(color: accentColor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    
            Row(
              children: [
                ClipOval(
                  child: CustomImageWidget(
                    imageUrl: postData.userImage,
                    width: 40.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                    // semanticLabel:
                    //     postData['posterAvatarSemanticLabel'] as String,
                  ),
                ),
    
                SizedBox(width: 10.w),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            postData.userName ?? '',
                            style: AppStyle.regular16RobotoBlack.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColor.textPrimary,
                            ),
                          ),
    
                           SizedBox(width: 8.w),
                          
                          StatusBadgeWidget(
                            status: isFound
                                ? PostStatus.found
                                : PostStatus.lost,
                            fontSize: 10.sp,
                          ),
                        ],
                      ),
    
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 11.sp,
                            color: AppColor.muted,
                          ),
                           SizedBox(width: 3.w),
                          Text(
                            postData.createdAt,
                            style: AppStyle.regular11RobotoGrey
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: () =>
                      Navigator.pushNamed(context, AppRoute.chat,
                          arguments:{
                            "conversationId":null,
                            "userId":postData.userId,
                            'postData': postData,
                          }),
                    child: Icon(
                      Icons.send, 
                      size: 17.sp,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            
            
             SizedBox(height: 10.h),
          
            Text(
              postData.title,
              style: AppStyle.regular16RobotoBlack.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
             SizedBox(height: 4.h),
            
            Text(
              postData.description ,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.regular16RobotoBlack.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.textSecondary,
                height: 1.5,
              ),
            ),
            
             SizedBox(height: 10.h),
            
            Container(
              padding:  EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                color: AppColor.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.outline),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 13.sp,
                    color: AppColor.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    postData.stationName,
                    style: AppStyle.regular16RobotoGrey.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
    
             SizedBox(height: 10.h),
            
            Row(
              children: [
                IconButton(
onPressed: (){
Navigator.pushNamed(context, AppRoute.itemDetailAndChatScreen, arguments: postData);
},

                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 14.sp,
                    color: AppColor.secondary,
                  ),
                ),
    
                 SizedBox(width: 4.w),
                Text(
                  '${postData.commentCount} messages',
                  style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.secondary,
                  ),
                ),
                
                const Spacer(),

                StatusBadgeWidget(
                  status: isResolved
                      ? PostStatus.resolved
                      : PostStatus.active,
                  fontSize: 10.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
