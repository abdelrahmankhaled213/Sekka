import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart'; // تأكد من المسار
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/chat_bubble.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/chat_input_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/item_info_card_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/status_badge_widget.dart';

class ItemDetailAndChatScreen extends StatefulWidget {
  
  final ItemModel? item;
  final String? id;
  const ItemDetailAndChatScreen({super.key, required this.item,required this.id});

  @override
  State<ItemDetailAndChatScreen> createState() =>
      _ItemDetailAndChatScreenState();
}

class _ItemDetailAndChatScreenState extends State<ItemDetailAndChatScreen> {

  late ScrollController _scrollController;

    final List<Map<String, dynamic>> _messageMaps = [
    {
      'id': '1',
      'senderName': 'Ahmed Mohamed',
      'senderAvatar': 'https://img.rocket.new/generatedImages/rocket_gen_img_18b8a61b5-1772542028452.png',
      'message': 'I lost my wallet at the station. Did you find it?',
      'timestamp': '10:31 AM',
      'isMine': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.item == null && widget.id != null) {
        // context.read<LostAndFoundCubit>().getPostDetails(widget.id!);
      } else if (widget.item != null) {
      
        context.read<LostAndFoundCubit>().getComments(widget.item!.id.toString());
      }
    });
  }
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messageMaps.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'senderName': 'You',
        'message': text.trim(),
        'timestamp': _formatNow(),
        'isMine': true,
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  String _formatNow() {
    final now = DateTime.now();
    final h = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {

    final item = widget.item; 
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final maxWidth = isTablet ? 600.0 : double.infinity;

    return BlocConsumer<LostAndFoundCubit, LostFoundState>(
      listenWhen: (previous, current) => current is CommentAdded 
      || current is CommentDeleted ,
      
      listener: (context, state) {
        if (state is CommentAdded) {
          setState(() {
            _messageMaps.add({
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'senderName': 'You',
              'message': state.comment.message,
              'timestamp': _formatNow(),
              'isMine': true,
            });
          });
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }
      },

      builder: Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: maxWidth,
              child: Column(
                children: [
                  _buildGradientHeader(
                    item?.title??'', 
                    item?.type == ItemType.found, 
                    _messageMaps.length
                  ),
                  ItemInfoCardWidget(
                    station: item?.stationName??"", 
                    description: item?.description??""
                  ),
                  _buildListView(),
                  ChatInputWidget(onSend: _sendMessage),
                  _buildBeRespectful(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientHeader(String title, bool isFound, int messageCount) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppStyle.brandGradient),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildArrowBack(),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildIconMore(),
            ],
          ),
          SizedBox(height: 12.h),
          _buildMessageCount(isFound, messageCount),
        ],
      ),
    );
  }

  Widget _buildBeRespectful() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      child: Text(
        'Please be respectful and verify item ownership before exchange.',
        textAlign: TextAlign.center,
        style: AppStyle.regular16RobotoBlack.copyWith(
          fontSize: 11.sp,
          color: AppColor.muted,
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: _messageMaps.length,
        itemBuilder: (context, index) {
          final msg = _messageMaps[index];
          return ChatBubbleWidget(messageData: msg);
        },
      ),
    );
  }

  Widget _buildIconMore() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(51),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.more_vert_rounded, color: Colors.white, size: 18.sp),
      ),
    );
  }

  Widget _buildArrowBack() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(51),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18.sp),
      ),
    );
  }

  Widget _buildMessageCount(bool isFound, int messageCount) {
    return Row(
      children: [
        StatusBadgeWidget(
          status: isFound ? PostStatus.found : PostStatus.lost,
          fontSize: 10.sp,
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.chat_bubble_outline_rounded,
          size: 14.sp,
          color: Colors.white.withAlpha(217),
        ),
        const SizedBox(width: 4),
        Text(
          '$messageCount messages',
          style: AppStyle.regular18RobotoWhite.copyWith(
            fontSize: 12.sp,
            color: Colors.white.withAlpha(217),
          ),
        ),
      ],
    );
  }
}