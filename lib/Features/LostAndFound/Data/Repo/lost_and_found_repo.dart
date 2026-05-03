import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/DataSource/remote_data_source.dart';
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

}