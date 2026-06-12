import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentInputWidget extends StatefulWidget {
  final int postId;

  const CommentInputWidget({
    super.key,
    required this.postId,
  });

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  static final List<BoxShadow> _boxShadow = [
    BoxShadow(
      color: AppColor.secondary.withAlpha(77),
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
  ];

  Future<void> _handleSubmit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final cubit = context.read<LostAndFoundCubit>();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final request = AddCommentRequest(
      postId: widget.postId,
      userId: userId,
      commentText: text,
    );

    await cubit.addComment(request);
    _controller.clear();
    setState(() => _hasText = false);
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColor.outline, width: 1.5),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) => setState(() => _hasText = value.trim().isNotEmpty),
                style: AppStyle.regular16RobotoBlack.copyWith(
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize: 14.sp,
                    color: AppColor.muted,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSubmit(),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTap: _hasText ? _handleSubmit : null,
        child: Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            gradient: _hasText ? AppStyle.brandGradient : null,
            color: _hasText ? null : AppColor.outline,
            shape: BoxShape.circle,
            boxShadow: _hasText ? _boxShadow : null,
          ),
          child: Icon(
            Icons.send_rounded,
            size: 18.sp,
            color: _hasText ? Colors.white : AppColor.muted,
          ),
        ),
      ),
    );
  }
}
