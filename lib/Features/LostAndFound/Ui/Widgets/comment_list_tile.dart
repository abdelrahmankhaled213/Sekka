import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Widget/custom_image_widget.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentListTile extends StatelessWidget {
  
  final CommentModel comment;

  const CommentListTile({
    super.key,
    required this.comment,
  });

  bool get _isOwner =>
      FirebaseAuth.instance.currentUser?.uid == comment.userId;

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentOptionsSheet(
        onEdit: () {
          Navigator.pop(context);
          context.read<LostAndFoundCubit>().openTextField(
                commentId: comment.id!,
                commentText: comment.content,
              );
        },
        onDelete: () {
          Navigator.pop(context);
          _showDeleteDialog(context);
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => _DeleteConfirmDialog(
        onConfirm: () {
          Navigator.pop(dialogCtx);
          context.read<LostAndFoundCubit>().deleteComment(comment.id!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.outline.withAlpha(77), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          ClipOval(
            child: CustomImageWidget(
              imageUrl: comment.userImage,
              width: 36.w,
              height: 36.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name and timestamp
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: AppStyle.regular16RobotoBlack.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.access_time_rounded,
                        size: 10.sp, color: AppColor.muted),
                    SizedBox(width: 3.w),
                    Text(
                      comment.createdAt ?? '',
                      style: AppStyle.regular11RobotoGrey.copyWith(
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Comment text
                Text(
                  comment.content,
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Edit/Delete button (owner only)
          if (_isOwner) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () => _showOptions(context),
              child: Container(
                padding: EdgeInsets.all(6.w),
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 18.sp,
                  color: AppColor.muted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CommentOptionsSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CommentOptionsSheet({
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColor.outline,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          // Edit option
          _OptionTile(
            icon: Icons.edit_rounded,
            label: 'Edit Comment',
            color: AppColor.secondary,
            onTap: onEdit,
          ),

          Divider(height: 1, color: AppColor.outline),

          // Delete option
          _OptionTile(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Comment',
            color: AppColor.error,
            onTap: onDelete,
          ),

          SizedBox(height: 8.h),

          // Cancel button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: AppColor.surfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppStyle.regular16RobotoBlack.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: color, size: 18.sp),
      ),
      title: Text(
        label,
        style: AppStyle.regular16RobotoBlack.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: AppColor.muted, size: 18.sp),
    );
  }
}

class _DeleteConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _DeleteConfirmDialog({
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColor.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline_rounded,
                  color: AppColor.error, size: 28.sp),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              'Delete Comment?',
              style: AppStyle.regular16RobotoBlack.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),

            // Body
            Text(
              'Are you sure you want to delete this comment? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: AppStyle.regular16RobotoBlack.copyWith(
                fontSize: 13.sp,
                color: AppColor.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                // Cancel
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColor.surfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppStyle.regular16RobotoBlack.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Delete
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.error,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: AppStyle.regular16RobotoBlack.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
