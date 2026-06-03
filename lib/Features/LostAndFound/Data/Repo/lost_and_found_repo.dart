import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/conversation.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/DataSource/remote_data_source.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/message.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/update_comment_request.dart';

class LostAndFoundRepo {

  final RemoteDataSource remoteDataSource;
  
  LostAndFoundRepo({required this.remoteDataSource});

Future<ItemModel> post(ItemModel data) async {
  return await remoteDataSource.post(data);
}

Future<List<ItemModel>>getPosts() async{
return await remoteDataSource.fetchLostAndFoundPosts();
}

Future<List<CommentModel>>getComments(int postId) async{
return await remoteDataSource.getComments(postId);
}

Future<CommentModel> addComment(AddCommentRequest request) async{
return await remoteDataSource.postComment(request);
}


Future<void> updatePost(ItemModel data)async{
return await remoteDataSource.updatePost(data);
}

Future<void> deletePost(int postId)async{
return await remoteDataSource.deletePost(postId);
}

Future<void> updateComment(UpdateCommentRequest data)async{
return await remoteDataSource.updateComment(data);
}

Future<void> deleteComment(int commentId)async{
return await remoteDataSource.deleteComment(commentId);
}

Future<void> sendMessage(
  String conversationId,
  String senderId,
  String text, {
  MessageType messageType = MessageType.text,
  String? fileUrl,
  String? fileName,
  String? fileSize,
}) async {
  return await remoteDataSource.sendMessage(
    conversationId,
    senderId,
    text,
    messageType: messageType,
    fileUrl: fileUrl,
    fileName: fileName,
    fileSize: fileSize,
  );
}

Future<String> uploadChatFile(File file, String userId) async {
  return await remoteDataSource.uploadChatFile(file, userId);
}

Future<String> uploadPostImage(File file, String userId) async {
  return await remoteDataSource.uploadPostImage(file, userId);
}

Future<void> markMessageAsRead(String conversationId)async{
return await remoteDataSource.markMessageAsRead(conversationId);
}

Future<List<Message>>getMessages(String conversationId)async{
return await remoteDataSource.getMessages(conversationId);
}

Future<Conversation?> getConversation(String conversationId)async{
return await remoteDataSource.getConversation(conversationId);
}
Future<List<Conversation>> getConversations(String userId)async{
return await remoteDataSource.getUserConversations(userId);
}


Future<Conversation> createConversation(String participantId)async{
return await remoteDataSource.createConversation( participantId);
}


Stream<List<Message>> listenToMessages(String conversationId){
  return remoteDataSource.listenToMessages(conversationId);
}

Future<void> setCurrentChat(String? conversationId) async {
  await remoteDataSource.setCurrentChat(conversationId);
}

Future<void>updateMessage(String messageId, String text) async {
return await remoteDataSource.updateMessage(messageId, text);
}


Future<void>deleteMessage(String messageId)async{  
return await remoteDataSource.deleteMessage(messageId);
}

}