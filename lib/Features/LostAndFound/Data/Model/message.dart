import 'package:sekka/Core/Helper/date_time_helper.dart';

class Message {

  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final String createdAt;
  final bool isRead;
  final bool isEdited;
  Message({
    required this.isEdited,
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
     
    return Message(
      isEdited: json['is_edited'] ?? false,
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      text: json['text'],
      createdAt: DateTimeHelper.formatTimestamp(json['created_at']),
      isRead: json['is_read']?? false,
    );
  }
}