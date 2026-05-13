class ChatMessageModel {
  final String id;
  final String text;
  final bool isBot;
  final String timestamp;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isBot,
    required this.timestamp,
  });
}
