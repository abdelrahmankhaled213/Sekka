import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Widget/custom_image_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/status_badge_widget.dart';
import 'package:sekka/core/constants/app_color.dart';

class PostCardWidget extends StatelessWidget {
  final Map<String, dynamic> postData;
  final VoidCallback onTap;

  const PostCardWidget({
    super.key,
    required this.postData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFound = postData['postType'] == 'found';
    final isResolved = postData['status'] == 'resolved';
    final accentColor = isFound ? AppColor.success : AppColor.error;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isResolved ? AppColor.surfaceVariant : AppColor.surface,
          borderRadius: BorderRadius.circular(16),
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
              // Header row: avatar, name, badge, time, phone action
              Row(
                children: [
                  ClipOval(
                    child: CustomImageWidget(
                      imageUrl: postData['posterAvatar'] as String,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      semanticLabel:
                          postData['posterAvatarSemanticLabel'] as String,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              postData['posterName'] as String,
                              style: AppStyle.regular16RobotoBlack.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColor.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadgeWidget(
                              status: isFound
                                  ? PostStatus.found
                                  : PostStatus.lost,
                              fontSize: 10,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 11.sp,
                              color: AppColor.muted,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              postData['timeAgo'] as String,
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
                    child: Icon(
                      isFound ? Icons.phone_rounded : Icons.search_rounded,
                      size: 17.sp,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Title
              Text(
                postData['title'] as String,
                style: AppStyle.regular16RobotoBlack.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                postData['description'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.regular16RobotoBlack.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColor.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              // Station chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
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
                      size: 13,
                      color: AppColor.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      postData['station'] as String,
                      style: AppStyle.regular16RobotoGrey.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Footer: messages + status
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 14,
                    color: AppColor.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${postData['messageCount']} messages',
                    style: AppStyle.regular16RobotoGrey.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.secondary,
                    ),
                  ),
                  const Spacer(),
                  StatusBadgeWidget(
                    status: isResolved
                        ? PostStatus.resolved
                        : PostStatus.active,
                    fontSize: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
