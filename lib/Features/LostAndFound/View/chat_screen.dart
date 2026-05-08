import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/message_buble.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/message_shimmer.dart';

class ChatScreen extends StatefulWidget {

  final String conversationId;
  final String otherUserId;

  const ChatScreen({

    super.key,
    required this.conversationId,
    required this.otherUserId,
 
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _canSend = false;

  String get _currentUserId => FirebaseAuth.instance.currentUser!.uid;

  String get _displayName {
    final id = widget.otherUserId;
    return 'User ${id.length > 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase()}';
  }

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      final canSend = _textController.text.trim().isNotEmpty;
      if (canSend != _canSend) {
        setState(() => _canSend = canSend);
      }
    });

    context.read<ChatCubit>().listenToMessages(widget.conversationId);
 
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {

    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() => _canSend = false);

    await context.read<ChatCubit>().sendMessage(widget.conversationId, text);

   
    _scrollToBottom();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_rounded,
              color: AppColor.textPrimary, size: 20.sp,),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                gradient: AppStyle.brandGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _displayName[5],
                  style: AppStyle.regular18RobotoWhite.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),

             SizedBox(width: 10.w),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
              
                Text(
                  "Chat",
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(color: AppColor.success, fontSize: 12.sp ,fontFamily: 'Roboto'),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {

                if (state.status == ChatStateEnum.getMessagesSuccess) {
                  _scrollToBottom();
                }

                if (state.status == ChatStateEnum.getMessagesFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMsg ?? "Error"),
                      backgroundColor: AppColor.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == ChatStateEnum.getMessagesLoading) {
                  return const MessageShimmer();
                }

                if (state.messages!.isEmpty) {
                  return _buildEmptyMessages();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding:  EdgeInsets.fromLTRB(16.w, 12.h, 16.h, 8.w),
                  itemCount: state.messages!.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages![index];
                    final isMine = msg.senderId == _currentUserId;

                    return MessageBubble(
                      message: msg,
                      isSentByMe: isMine,
                    );
                  },
                );
              },
            ),
          ),

          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyMessages() {
    return  Center(
      child: Text(
        "Say hello 👋",
        style: TextStyle(color: AppColor.textSecondary, fontSize: 16.sp, fontFamily: 'Roboto'),
      ),
    );
  }

  Widget _buildInputArea() {

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 12.w,
        top: 10.h,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: _canSend ? _sendMessage : null,
            icon:  Icon(Icons.send, color: AppColor.main, size: 20.sp,),
          )
        ],
      ),
    );
  }
}