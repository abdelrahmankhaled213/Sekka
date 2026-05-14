import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Error/failure.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/update_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Repo/lost_and_found_repo.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';

class LostAndFoundCubit extends Cubit<LostFoundState> {
  
  final LostAndFoundRepo lostAndFoundRepo;

  LostAndFoundCubit(this.lostAndFoundRepo) : super(LostFoundState(
    
    status: LostFoundStatus.initial
  ));

  final controller = TextEditingController();



void _mapError(Object e, StackTrace stackTrace,LostFoundStatus status) {
  
   print(stackTrace.toString());
      print(e.toString());
      final Failure failure = ErrorHandler.handleError(e);
      emit(state.copyWith(status: LostFoundStatus.addPostfailure,errorMsg: failure.message));
}


  Future<void> postLostAndFound(ItemModel item) async {
  
    emit(state.copyWith(status: LostFoundStatus.addPostloading));
    try {
    
   final addedItemModel= await lostAndFoundRepo.post(item);
     

      emit(state.copyWith( status: LostFoundStatus.addPostsuccess,addedItemModel:addedItemModel ));

    } catch (e,stackTrace) {
     _mapError(e, stackTrace, LostFoundStatus.addPostfailure);
    }
  }


 Future<void> getPosts()async{

emit(state.copyWith(status: LostFoundStatus.getPostLoading));

try{
final posts=await lostAndFoundRepo.getPosts();

emit(state.copyWith(status: LostFoundStatus.getPostSuccess,items: posts));
}
catch(e,stackTrace){
_mapError(e, stackTrace, LostFoundStatus.getPostFailure);
}

  }


  // Future<void> createConversation(String participantId) async {
  //   emit(state.copyWith(status: LostFoundStatus.createConversationLoading));
  //   try {
  //    final id= await lostAndFoundRepo.createConversation(participantId);
  //     emit(state.copyWith(status: LostFoundStatus.createConversationSuccess,conversationId: id));
  //   } catch (e, stackTrace) {
  //     _mapError(e, stackTrace, LostFoundStatus.createConversationFailure);
  //   }
  // }

Future<void> deletePost(int postId)async{

emit(
  state.copyWith(
    status: LostFoundStatus.deletePostLoading
  )
);

try{

await lostAndFoundRepo.deletePost(postId);

emit(state.copyWith(
    status: LostFoundStatus.deletePostSuccess
  )
);
}
catch(e,stackTrace){
_mapError(e, stackTrace, LostFoundStatus.deletePostFailure);
}

}

Future<void> updatePost(ItemModel item)async{

emit(
  state.copyWith(
    status: LostFoundStatus.updatePostLoading
  )
);

try{

await lostAndFoundRepo.updatePost(item);

emit(state.copyWith(
    status: LostFoundStatus.updatePostSuccess
  )
);
}
catch(e,stackTrace){
_mapError(e, stackTrace, LostFoundStatus.updatePostFailure);
}

}


void closeTextField() {
    controller.clear();
    emit(state.copyWith(hasText: false,
    editingCommentId: null,
    isUpdatePressed: false
    
    ));
  }
void openTextField({required int commentId, required String commentText}) {
  controller.text = commentText;
  emit(state.copyWith(
    hasText: true,
    isUpdatePressed: true,
    editingCommentId: commentId,
  ));
}
void checkingTextFiledIsNotEmpty(bool isNotEmpty) {
   emit(state.copyWith(hasText: isNotEmpty));
  }

Future<void>getComments(int postId)async{

emit(
  state.copyWith(
    status: LostFoundStatus.getCommmentLoading
  )
);

try{

final data=await lostAndFoundRepo.getComments(postId);

emit(state.copyWith(
    status: LostFoundStatus.getCommentSuccess,
    comments: data  
  )
);

}catch(e,stackTrace){
_mapError(e, stackTrace, LostFoundStatus.getCommentFailure);

}

}

Future<void>addComment(AddCommentRequest request)async{

emit(
  state.copyWith(
    status: LostFoundStatus.createCommentLoading
  )
);

try{

final commentAdded=await lostAndFoundRepo.addComment(request);

emit(state.copyWith(
    status: LostFoundStatus.createCommentSuccess,
    addCommentResponse: commentAdded,
    
  )
);

}catch(e,stackTrace){
_mapError(e, stackTrace, LostFoundStatus.createCommentFailure);
}

}



Future<void>deleteComment(int commentId)async{

emit(
  state.copyWith(
    status: LostFoundStatus.deleteCommentLoading
  )
);

try{

await lostAndFoundRepo.deleteComment(commentId);

emit(state.copyWith(
    status: LostFoundStatus.deleteCommentSuccess
  )
);
}
catch(e,stackTrace){
_mapError(e, stackTrace, LostFoundStatus.deleteCommentFailure);

}
}

Future<void> updateComment(String newContent) async {

  if (state.editingCommentId == null) return;

  emit(state.copyWith(status: LostFoundStatus.updateCommentLoading));

  try {
    
    final originalComment = state.comments!.firstWhere((c) => c.id == state.editingCommentId);

    
    final updatedCommentModel = UpdateCommentRequest(
      commentId: originalComment.id!,
       comment: newContent,
    );

    
    await lostAndFoundRepo.updateComment(updatedCommentModel);

    emit(state.copyWith(status: LostFoundStatus.updateCommentSuccess));
    
    closeTextField(); 

  } catch (e, stackTrace) {
    _mapError(e, stackTrace, LostFoundStatus.updateCommentFailure);
  }
}

@override
 Future<void> close() {
    controller.dispose();
    return super.close();
  }

}