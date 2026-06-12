import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_image.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Widget/custom_image_widget.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/status_badge_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/update_post.dart';
import 'package:sekka/core/constants/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostCardWidget extends StatelessWidget {
  final ItemModel postData;
  final void Function()? onTap;

  const PostCardWidget({
    super.key,
    required this.postData,
    required this.onTap,
  });

  bool get _isOwner =>
      FirebaseAuth.instance.currentUser?.uid == postData.userId;

  void _openEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<LostAndFoundCubit>(),
        child: EditPostModalWidget(post: postData),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => _DeleteConfirmDialog(
        postTitle: postData.title,
        onConfirm: () {
          Navigator.pop(dialogCtx);
          context.read<LostAndFoundCubit>().deletePost(postData.id!);
        },
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _OptionsSheet(
        onEdit: () {
          Navigator.pop(context);
          _openEditModal(context);
        },
        onDelete: () {
          Navigator.pop(context);
          _showDeleteDialog(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final isFound    = postData.type == ItemType.found;
    final isResolved = postData.isActive;
    final accentColor = isFound ? AppColor.success : AppColor.error;

    return BlocListener<LostAndFoundCubit, LostFoundState>(
      listenWhen: (_, current) =>
          current.status == LostFoundStatus.deletePostSuccess ||
          current.status == LostFoundStatus.deletePostFailure,
      listener: (context, state) {
        if (state.status == LostFoundStatus.deletePostSuccess) {
          context.read<LostAndFoundCubit>().getPosts();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Post deleted',
                style: AppStyle.regular16RobotoBlack
                    .copyWith(fontSize: 14.sp, color: Colors.white)),
            backgroundColor: AppColor.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ));
        }
        if (state.status == LostFoundStatus.deletePostFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMsg ?? 'Delete failed',
                style: AppStyle.regular16RobotoBlack
                    .copyWith(fontSize: 14.sp, color: Colors.white)),
            backgroundColor: AppColor.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ));
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () {
          if (_isOwner) _showOptions(context);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColor.surfaceVariant,
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
                // ── top row ──────────────────────────────────────────────
                Row(
                  children: [
                    ClipOval(
                      child:postData.userImage == null ? Image.asset(AppImage.profileIcon, width: 40.w, height: 40.h
                      , fit: BoxFit.cover,) : CustomImageWidget(
                        placeHolder: AppImage.profileIcon,
                        imageUrl: postData.userImage,
                        width:    40.w,
                        height:   40.h,
                        fit:      BoxFit.cover,
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
                                  fontSize:   14,
                                  fontWeight: FontWeight.w700,
                                  color:      AppColor.textPrimary,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              StatusBadgeWidget(
                                status:   isFound ? PostStatus.found : PostStatus.lost,
                                fontSize: 10.sp,
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded,
                                  size: 11.sp, color: AppColor.muted),
                              SizedBox(width: 3.w),
                              Text(postData.createdAt,
                                  style: AppStyle.regular11RobotoGrey),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // // send button
                    // GestureDetector(
                    //   onTap: () => Navigator.pushNamed(
                    //     context,
                    //     AppRoute.chat,
                    //     arguments: {
                    //       'conversationId': null,
                    //       'userId':         postData.userId,
                    //       'postData':       postData,
                    //     },
                    //   ),
                    //   child: Container(
                    //     width:  36.w,
                    //     height: 36.h,
                    //     decoration: BoxDecoration(
                    //       color: accentColor.withAlpha(26),
                    //       shape: BoxShape.circle,
                    //     ),
                    //     child: Icon(Icons.send, size: 17.sp, color: accentColor),
                    //   ),
                    // ),

                    if (_isOwner) ...[
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: () => _showOptions(context),
                        child: Container(
                          width:  36.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color:  AppColor.surfaceVariant,
                            shape:  BoxShape.circle,
                            border: Border.all(
                                color: AppColor.outline, width: 1),
                          ),
                          child: Icon(Icons.more_vert_rounded,
                              size: 18.sp, color: AppColor.textSecondary),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 10.h),

                // ── title ─────────────────────────────────────────────────
                Text(
                  postData.title,
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize:   15.sp,
                    fontWeight: FontWeight.w700,
                    color:      AppColor.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),

                // ── description ───────────────────────────────────────────
                Text(
                  postData.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize:   13.sp,
                    fontWeight: FontWeight.w400,
                    color:      AppColor.textSecondary,
                    height:     1.5,
                  ),
                ),
                SizedBox(height: 10.h),

                // ── image ─────────────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CustomImageWidget(
                    imageUrl: postData.imageUrl,
                    width:    double.infinity,
                    height:   220.h,
                    fit:      BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10.h),

                // ── station chip ──────────────────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color:        AppColor.background,
                    borderRadius: BorderRadius.circular(8),
                    border:       Border.all(color: AppColor.outline),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 13.sp, color: AppColor.secondary),
                      const SizedBox(width: 4),
                      Text(
                        postData.stationName,
                        style: AppStyle.regular16RobotoGrey.copyWith(
                          fontSize:   12.sp,
                          fontWeight: FontWeight.w500,
                          color:      AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                // ── bottom row: comments + status + save ──────────────────
                Row(
                  children: [
                    // comments
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoute.itemDetailAndChatScreen,
                        arguments: {
                          'item':  postData,
                          'cubit': context.read<LostAndFoundCubit>(),
                        },
                      ),
                      icon: Icon(Icons.chat_bubble_outline_rounded,
                          size: 14.sp, color: AppColor.secondary),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${postData.commentCount} messages',
                      style: AppStyle.regular16RobotoGrey.copyWith(
                        fontSize:   12.sp,
                        fontWeight: FontWeight.w500,
                        color:      AppColor.secondary,
                      ),
                    ),

                    const Spacer(),

                    // status badge
                    StatusBadgeWidget(
                      status:   isResolved
                          ? PostStatus.resolved
                          : PostStatus.active,
                      fontSize: 10.sp,
                    ),

                    SizedBox(width: 8.w),

                    // ── save toggle button ────────────────────────────────
                    _SaveButton(postData: postData),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Save button — animated toggle
// ─────────────────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final ItemModel postData;

  const _SaveButton({required this.postData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LostAndFoundCubit, LostFoundState>(
      buildWhen: (prev, curr) =>
          curr.status == LostFoundStatus.toggleSavePostSuccess ||
          curr.status == LostFoundStatus.toggleSavePostLoading ||
          curr.status == LostFoundStatus.toggleSavePostFailure,
      builder: (context, state) {
        // أخذ الـ isSaved من الـ items list عشان يتحدث بعد الـ toggle
        final updatedItem = state.items?.firstWhere(
          (i) => i.id == postData.id,
          orElse: () => postData,
        ) ?? postData;

        final isSaved   = updatedItem.isSaved;
        final isLoading = state.status == LostFoundStatus.toggleSavePostLoading;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () => context
                  .read<LostAndFoundCubit>()
                  .toggleSavePost(postData.id.toString()),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width:  32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: isSaved
                  ? const Color(0xFF8B5CF6).withOpacity(0.12)
                  : AppColor.surfaceVariant,
              shape:  BoxShape.circle,
              border: Border.all(
                color: isSaved
                    ? const Color(0xFF8B5CF6)
                    : AppColor.outline,
                width: 1,
              ),
            ),
            child: isLoading
                ? Padding(
                    padding: EdgeInsets.all(7.w),
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color:       Color(0xFF8B5CF6),
                    ),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      key:   ValueKey(isSaved),
                      size:  16.sp,
                      color: isSaved
                          ? const Color(0xFF8B5CF6)
                          : AppColor.textSecondary,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Options sheet
// ─────────────────────────────────────────────────────────────────────────────

class _OptionsSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _OptionsSheet({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColor.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:  40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color:        AppColor.outline,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          _OptionTile(
            icon:  Icons.edit_rounded,
            label: 'Edit Post',
            color: AppColor.secondary,
            onTap: onEdit,
          ),
          Divider(height: 1, color: AppColor.outline),
          _OptionTile(
            icon:  Icons.delete_outline_rounded,
            label: 'Delete Post',
            color: AppColor.error,
            onTap: onDelete,
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width:  double.infinity,
            height: 48.h,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: AppColor.surfaceVariant,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                'Cancel',
                style: AppStyle.regular16RobotoBlack.copyWith(
                  fontSize:   14.sp,
                  fontWeight: FontWeight.w600,
                  color:      AppColor.textSecondary,
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
  final String   label;
  final Color    color;
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
        width:  38.w,
        height: 38.h,
        decoration: BoxDecoration(
          color:        color.withAlpha(26),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: color, size: 18.sp),
      ),
      title: Text(
        label,
        style: AppStyle.regular16RobotoBlack.copyWith(
          fontSize:   14.sp,
          fontWeight: FontWeight.w600,
          color:      color,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: AppColor.muted, size: 18.sp),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Delete dialog
// ─────────────────────────────────────────────────────────────────────────────

class _DeleteConfirmDialog extends StatelessWidget {
  final String       postTitle;
  final VoidCallback onConfirm;

  const _DeleteConfirmDialog({
    required this.postTitle,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color:        AppColor.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width:  60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColor.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline_rounded,
                  color: AppColor.error, size: 28.sp),
            ),
            SizedBox(height: 16.h),
            Text(
              'Delete Post?',
              style: AppStyle.regular16RobotoBlack.copyWith(
                fontSize:   17.sp,
                fontWeight: FontWeight.w800,
                color:      AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Are you sure you want to delete "$postTitle"? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: AppStyle.regular16RobotoBlack.copyWith(
                fontSize: 13.sp,
                color:    AppColor.textSecondary,
                height:   1.5,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColor.surfaceVariant,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppStyle.regular16RobotoBlack.copyWith(
                          fontSize:   14.sp,
                          fontWeight: FontWeight.w600,
                          color:      AppColor.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.error,
                        shadowColor:     Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(
                        'Delete',
                        style: AppStyle.regular16RobotoBlack.copyWith(
                          fontSize:   14.sp,
                          fontWeight: FontWeight.w700,
                          color:      Colors.white,
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