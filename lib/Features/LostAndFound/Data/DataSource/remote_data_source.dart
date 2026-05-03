import 'package:sekka/Core/API/api_constants.dart';
import 'package:sekka/Core/API/api_service.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_response.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/update_comment_request.dart';

class RemoteDataSource {

final ApiConsumer api;

RemoteDataSource(this.api);

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

}
