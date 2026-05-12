import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekka/Core/API/api_constants.dart';
import 'package:sekka/Core/API/api_service.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/conversation.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/message.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/update_comment_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDataSource {

final ApiConsumer api;
final SupabaseClient _supabase;
RemoteDataSource(this.api,this._supabase);


  static const _conversationsTable = 'conversations';
  static const _messagesTable = 'messages'; 
  static const _colId = 'id';
  static const _colUser1Id = 'user1_id';
  static const _colUser2Id = 'user2_id';
  static const _colCreatedAt = 'created_at';
  static const _colConversationId = 'conversation_id';
  static const _colSenderId = 'sender_id';
  static const _colText = 'text';
 
Future<ItemModel> post(ItemModel data) async {
 
  final response = await api.post(endPointCreatePost, data: data.toJson());
  
  return ItemModel.fromJson(response); 

}

Future<List<ItemModel>> fetchLostAndFoundPosts()async{ 

final response = await api.get(endPointGetLostAndFoundPosts);
return (response["data"] as List<dynamic>).map((e) => ItemModel.fromJson(e)).toList();
  
}

Future<void> updatePost(ItemModel data)async{

return await api.put("$endPointUpdatePost/${data.id}",data: data.toJson());

}

Future<void> deletePost(int postId)async{

 return await api.delete("$endPointDeletePost/$postId");

}

Future<List<CommentModel>>getComments(int postId)async{

  final response =await api.get("$endPointGetComments/$postId");
  return (response["data"] as List<dynamic>).map((e) => CommentModel.fromJson(e)).toList();

}

Future<CommentModel> postComment(AddCommentRequest request)async{

final response =await api.post(endPointCreateComment,data: request.toJson());

return CommentModel.fromJson(response);
  
}

Future<void>updateComment(UpdateCommentRequest data)async{

return await api.put("$endPointUpdateComment/${data.commentId}",data: data.toJson());

}

Future<void>deleteComment(int commentId)async{

return await api.delete("$endPointDeleteComment/$commentId");

}

Future<List<Conversation>> getUserConversations(String userId) async {
  
  final response = await _supabase
      .from(_conversationsTable)
      .select('''
        *,
        user1:user1_id(id, name, image),
        user2:user2_id(id, name, image),
        last_message:last_message_id(
          text,
          is_read
        ) 
      ''') 
      .or('user1_id.eq.$userId,user2_id.eq.$userId')
      .order('last_message_time', ascending: false);

  return (response as List)
      .map((json) => Conversation.fromJson(json))
      .toList();
}

   Future<Conversation?> getConversation(String conversationId) async {
  final response = await _supabase
      .from(_conversationsTable)
      .select('''
        *,
        user1:user1_id(id, name, image),
        user2:user2_id(id, name, image),
        last_message:last_message_id(text, is_read)
      ''')
      .eq(_colId, conversationId)
      .maybeSingle();

  if (response == null) return null;

  return Conversation.fromJson(response);
}
  
Future<String> createConversation(String otherUserId) async {
  
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  final response = await _supabase
      .from(_conversationsTable)
      .upsert({
        'user1_id': currentUserId,
        'user2_id': otherUserId,
      })

      .select('id') 
      .single();    

  return response['id'] as String;

}


  Future<List<Message>> getMessages(String conversationId) async {
  
    final response = await _supabase
          .from(_messagesTable)
          .select()
          .eq(_colConversationId, conversationId)
          .order(_colCreatedAt, ascending: true);
 
      return (response as List<dynamic>)
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    
  
 
  
  Future<void> sendMessage(
    String conversationId,
    String senderId,
    String text,
  ) async {
      if (text.trim().isEmpty) {
        throw Exception(
          'Message text cannot be empty.',
        );
      }
 
      await _supabase.from(_messagesTable).insert({
        _colConversationId: conversationId,
        _colSenderId: senderId,
        _colText: text.trim(),
      });
    } 

  Stream<List<Message>> listenToMessages(String conversationId) {
    
      return _supabase
          .from(_messagesTable)
          .stream(primaryKey: [_colId])
          .eq(_colConversationId, conversationId)
          .order(_colCreatedAt, ascending: true)
          .map(
            (data) => data
                .map((json) => Message.fromJson(json))
                .toList(),
          );
 
  }
}

