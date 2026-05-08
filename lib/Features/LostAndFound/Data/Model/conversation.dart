import 'package:sekka/Core/Helper/date_time_helper.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/message.dart';

class Conversation {
  final String id;
  final String user1Id;
  final String user2Id;
  final Message lastMessage;
  final String lastMessageTime;
  final String createdAt;

  Conversation({
 
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
 
  });

String otherUserId(String currentUserId) {
    return user1Id == currentUserId ? user2Id : user1Id;
  }
  factory Conversation.fromJson(Map<String, dynamic> json) {
 
    return Conversation(
 
      id: json['id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      lastMessage: Message.fromJson(json['last_message']),
      lastMessageTime: DateTimeHelper.formatTimestamp(json['last_message_time']),
      createdAt: DateTimeHelper.formatTimestamp(json['created_at']),
    );
  }


}



