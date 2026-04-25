import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/chat_bubble.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/chat_input_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/item_info_card_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/status_badge_widget.dart';

class ItemDetailAndChatScreen extends StatefulWidget {
  
  const ItemDetailAndChatScreen({super.key});

  @override
  State<ItemDetailAndChatScreen> createState() =>
      _ItemDetailAndChatScreenState();
}

class _ItemDetailAndChatScreenState extends State<ItemDetailAndChatScreen> {
  // TODO: Replace with Riverpod/Bloc for production
  late ScrollController _scrollController;

  final List<Map<String, dynamic>> _messageMaps = [
    {
      'id': '1',
      'senderName': 'Ahmed Mohamed',
      'senderAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_18b8a61b5-1772542028452.png',
      'senderAvatarSemanticLabel':
          'Middle-aged Egyptian man with short black hair in casual shirt',
      'message':
          'I lost my black wallet at Central Metro Station around 5 PM yesterday. It has my ID card and credit cards inside.',
      'timestamp': '10:31 AM',
      'isMine': false,
    },
    {
      'id': '2',
      'senderName': 'Fatima Hassan',
      'senderAvatar':
          'https://images.unsplash.com/photo-1718041127108-d477a9e6a155',
      'senderAvatarSemanticLabel':
          'Young woman with hijab smiling warmly at camera',
      'message':
          'Hi! I think I saw a black wallet near the ticket machines. Did it have any distinctive features?',
      'timestamp': '02:31 PM',
      'isMine': true,
    },
    {
      'id': '3',
      'senderName': 'Ahmed Mohamed',
      'senderAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_18b8a61b5-1772542028452.png',
      'senderAvatarSemanticLabel':
          'Middle-aged Egyptian man with short black hair in casual shirt',
      'message':
          'Yes! It has a small scratch on the corner and a photo of my family inside. Did you find it?',
      'timestamp': '03:31 PM',
      'isMine': false,
    },
  ];




  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

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
    // TODO: Replace with actual message send API
    setState(() {
      _messageMaps.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'senderName': 'You',
        'senderAvatar':
            'https://img.rocket.new/generatedImages/rocket_gen_img_11e223970-1767170769836.png',
        'senderAvatarSemanticLabel': 'Your profile photo',
        'message': text.trim(),
        'timestamp': _formatNow(),
        'isMine': true,
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  String _formatNow() {
    final now = DateTime.now();
    final h = now.hour > 12
        ? now.hour - 12
        : now.hour == 0
        ? 12
        : now.hour;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final maxWidth = isTablet ? 600.0 : double.infinity;

    final title = args?['title'] as String? ?? 'Found iPhone 13';
    final postType = args?['postType'] as String? ?? 'found';
    final station = args?['station'] as String? ?? 'Downtown Station';
    final description =
        args?['description'] as String? ??
        'Found an iPhone 13 Pro on the Blue Line train. It has a blue case. Contact me to claim it.';
    final messageCount = args?['messageCount'] as int? ?? _messageMaps.length;
    final isFound = postType == 'found';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: maxWidth,
            child: Column(
              children: [
                _buildGradientHeader(title, postType, messageCount, isFound),
                ItemInfoCardWidget(station: station, description: description),
                _buildListView(),
                ChatInputWidget(onSend: _sendMessage),
               _buildBeRespectful(),
              ],
            ),
          ),
        ),
      ),
    );

  }
Widget _buildBeRespectful(){
    return  Padding(
    padding:  EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
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
Widget _buildListView(){
      return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),

                    itemCount: _messageMaps.length,
                    itemBuilder: (context, index) {
                      final msg = _messageMaps[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(
                          milliseconds: 250 + (index * 40).clamp(0, 200),
                        ),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 16 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: ChatBubbleWidget(messageData: msg),
                      );
                    },
                  ),
                );

}
  Widget _buildGradientHeader(
    String title,
    String postType,
    int messageCount,
    bool isFound,
  ) {
    return Container(
    
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppStyle.brandGradient),
      padding:  EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      child: Row(
        children: [
     
     _buildArrowBack(),

           SizedBox(width: 12.w),

   _buildMessageCount(isFound, messageCount),       
        
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                 SizedBox(height: 4.h),
              ],
            ),
          ),
    
    _buildIconMore()

        ],
      ),
    );
  }

Widget _buildIconMore(){
         return GestureDetector(
            onTap: () {},
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child:  Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          );

}






  Widget _buildArrowBack(){
return   GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
      color: Colors.white.withAlpha(51),
      shape: BoxShape.circle,
        ),
      child:  Icon(
        Icons.arrow_back_rounded,
           color: Colors.white,
           size: 18.sp,
              ),
            ),
          );
  }

Widget _buildMessageCount(bool isFound, int messageCount){
 return Row(
         children: [
          StatusBadgeWidget(
          status: isFound ? PostStatus.found : PostStatus.lost,
          fontSize: 10.sp,
                    ),
          const SizedBox(width: 8),
          Icon(
          Icons.chat_bubble_outline_rounded,
          size: 12.sp,
          color: Colors.white.withAlpha(217),
                    ),
        const SizedBox(width: 4),
          Text(
           '$messageCount messages',
          style: AppStyle.regular18RobotoWhite.copyWith (
          fontSize: 12.sp,
          color: Colors.white.withAlpha(217),
                      ),
                    ),
                  ],
                );
    
}

}
