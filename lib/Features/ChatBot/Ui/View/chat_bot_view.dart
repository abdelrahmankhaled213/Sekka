import 'package:flutter/material.dart';
import 'package:sekka/core/theme/app_colors.dart';
import 'package:sekka/Features/ChatBot/Data/Model/chat_message_model.dart';
import 'package:sekka/Features/ChatBot/Data/Model/DataSource/chat_bot_service.dart';
import 'package:sekka/Features/ChatBot/Ui/Widget/chat_header_widget.dart';
import 'package:sekka/Features/ChatBot/Ui/Widget/chat_input_widget.dart';
import 'package:sekka/Features/ChatBot/Ui/Widget/chat_messages_widget.dart';
import 'package:sekka/Features/ChatBot/Ui/Widget/quick_suggestions_widget.dart';

class ChatBotView extends StatefulWidget {

  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  final ChatBotService _chatBotService = ChatBotService();

  bool _isTyping = false;
  bool _showQuickSuggestions = true;

  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      id: '1',
      text: 'مرحباً بيك! أنا مساعدك الذكي في Sekka. إزاي أقدر أساعدك في رحلتك النهارده؟',
      isBot: true,
      timestamp: '',
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  String _formatTime() {
    final now = TimeOfDay.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : now.hour == 0
        ? 12
        : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final timeStr = _formatTime();

    setState(() {
      _messages.add(ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text.trim(),
        isBot: false,
        timestamp: timeStr,
      ));
      _showQuickSuggestions = false;
      _isTyping = true;
    });

    _inputController.clear();
    _scrollToBottom();

    try {
      final reply = await _chatBotService.sendMessage(text.trim());

      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: reply,
          isBot: true,
          timestamp: _formatTime(),
        ));
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'There was an error processing your request. Please try again later.',
          isBot: true,
          timestamp: _formatTime(),
        ));
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const ChatHeaderWidget(),
            Expanded(
              child: GestureDetector(
                onTap: () => _inputFocusNode.unfocus(),
                child: Column(
                  children: [
                    Expanded(
                      child: ChatMessagesWidget(
                        messages: _messages,
                        isTyping: _isTyping,
                        scrollController: _scrollController,
                      ),
                    ),
                    if (_showQuickSuggestions && _messages.length <= 1)
                      QuickSuggestionsWidget(
                        onSuggestionTapped: _sendMessage,
                      ),
                  ],
                ),
              ),
            ),
            ChatInputWidget(
              controller: _inputController,
              focusNode: _inputFocusNode,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
