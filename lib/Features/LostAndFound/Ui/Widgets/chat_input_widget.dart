import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';

class ChatInputWidget extends StatefulWidget {
  
  final Function(String) onSend;

  const ChatInputWidget({super.key, required this.onSend});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {


static final List<BoxShadow> _boxShadow = [
   BoxShadow(
   color: AppColor.secondary.withAlpha(77),
   blurRadius: 8,
   offset: const Offset(0, 3),
                          ),
                        

];

Future<void> _handleSend() async {
  final cubit = context.read<LostAndFoundCubit>();
  final text = cubit.controller.text.trim();
  
  if (text.isEmpty) return;

   if (cubit.state.isUpdatePressed) {
    
    await cubit.updateComment(text); 
  } else {
 
    widget.onSend(text);
  }
  
  cubit.closeTextField(); 

  FocusScope.of(context).unfocus();
}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
              child: _buildTextField()
            ),
          ),
          const SizedBox(width: 10),
          _buildAnimatedContainer()
        ],
      ),
    );
  }

  Widget _buildAnimatedContainer(){

    final _hasText = context.read<LostAndFoundCubit>().controller.text.trim().isNotEmpty;

    return  AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: GestureDetector(
              onTap: _hasText ? _handleSend : null,
              child: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  gradient: _hasText ? AppStyle.brandGradient : null,
                  color: _hasText ? null : AppColor.outline,
                  shape: BoxShape.circle,
                  boxShadow: _hasText
                      ? _boxShadow
                      : null,
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
  
  
  
  
  Widget _buildTextField() {

               return BlocBuilder<LostAndFoundCubit,LostFoundState>(
                builder:(context, state) =>  
                  TextField(
                  controller: context.read<LostAndFoundCubit>().controller,
                  onChanged: (v) =>
                      context.read<LostAndFoundCubit>().checkingTextFiledIsNotEmpty(v.isNotEmpty),  
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: AppStyle.regular16RobotoBlack.copyWith(
                      fontSize: 14.sp,
                      color: AppColor.muted,
                    ),
                 
                    contentPadding:  EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                               ),
               );
  }
}
