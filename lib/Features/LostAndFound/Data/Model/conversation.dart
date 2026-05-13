import 'package:sekka/Core/Helper/date_time_helper.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/message.dart';

class Conversation {

  final String id;
  final String user1Id;
  final String user2Id;
  final String lastMessageTime;
  final String createdAt;
  final Message? lastMessage;
  final UserModel? user1Data; 
  final UserModel? user2Data;
  final int unreadCount;
  
 const Conversation({ 
   required this.unreadCount,
    required this.user1Data,
    required this.user2Data,
    required this.lastMessage,
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessageTime,
    required this.createdAt,
 
  });

String otherUserId(String currentUserId) {
    return user1Id == currentUserId ? user2Id : user1Id;
  }

 factory Conversation.fromJson(Map<String, dynamic> json) {
  
  final lastMsgJson = json['last_message'];

  return Conversation(

    unreadCount: json['unread_count'] ?? 0,
    user1Data: UserModel.fromJson(json['user1']),
    user2Data: UserModel.fromJson(json['user2']),
    user2Id: json['user2_id'],
    id: json['id'],
    user1Id: json['user1_id'],
    lastMessage:  lastMsgJson != null 
        ? Message.fromJson(lastMsgJson is List ? lastMsgJson.first : lastMsgJson) 
        : null, 
    lastMessageTime: DateTimeHelper.formatTimestamp(json['last_message_time'] ?? ''),
    createdAt: DateTimeHelper.formatTimestamp(json['created_at'] ?? ''),
  );
}
}



