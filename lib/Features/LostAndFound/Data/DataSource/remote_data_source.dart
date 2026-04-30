import 'package:sekka/Core/API/api_constants.dart';
import 'package:sekka/Core/API/api_service.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_response.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
class RemoteDataSource {

final ApiConsumer api;

RemoteDataSource(this.api);

Future<ItemModel> post(ItemModel data)async{

return await api.post(endPointCreatePost,data: data.toJson());

}

Future<List<ItemModel>> fetchLostAndFoundPosts()async{ 

final response = await api.get(endPointGetLostAndFoundPosts);
return (response["data"] as List<dynamic>).map((e) => ItemModel.fromJson(e)).toList();
  
}

Future<void> updatePost(ItemModel data)async{

return await api.put("$endPointUpdatePost/${data.id}",data: data.toJson());

}

Future<void> deletePost(String postId)async{

 return await api.delete("$endPointDeletePost/$postId");

}

Future<List<CommentModel>>getComments(String postId)async{

  final response =await api.get(endPointGetComments,queryParameters: {"postId":postId});
  return (response["data"] as List<dynamic>).map((e) => CommentModel.fromJson(e)).toList();

}

Future<AddCommentResponse> postComment(String postId,CommentModel data)async{
final response =await api.post(endPointCreateComment,data: data.toJson(),queryParameters: {"postId":postId});
return AddCommentResponse.fromJson(response);
}

Future<void>updateComment(CommentModel data)async{

return await api.put("$endPointUpdateComment/${data.id}",data: data.toJson());

}

Future<void>deleteComment(String commentId)async{

return await api.delete("$endPointDeleteComment/$commentId");
}

}
