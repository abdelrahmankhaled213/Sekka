import 'package:sekka/Core/Helper/date_time_helper.dart';

enum MessageType {
  text,
  image,
  file,
}

class Message {

  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final String createdAt;
  final bool isRead;
  final bool isEdited;
  final MessageType messageType;
  final String? fileUrl;
  final String? fileName;
  final String? fileSize;

  Message({
    required this.isEdited,
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.isRead,
    this.messageType = MessageType.text,
    this.fileUrl,
    this.fileName,
    this.fileSize,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final messageTypeStr = json['message_type'] ?? 'text';
    MessageType messageType = MessageType.text;
    
    if (messageTypeStr == 'image') {
      messageType = MessageType.image;
    } else if (messageTypeStr == 'file') {
      messageType = MessageType.file;
    }
     
    return Message(
      isEdited: json['is_edited'] ?? false,
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      text: json['text'] ?? '',
      createdAt: DateTimeHelper.formatTimestamp(json['created_at']),
      isRead: json['is_read']?? false,
      messageType: messageType,
      fileUrl: json['file_url'],
      fileName: json['file_name'],
      fileSize: json['file_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'text': text,
      'created_at': createdAt,
      'is_read': isRead,
      'is_edited': isEdited,
      'message_type': messageType.name,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': fileSize,
    };
  }
}