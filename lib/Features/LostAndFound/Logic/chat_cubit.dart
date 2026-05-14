import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Features/LostAndFound/Data/Repo/lost_and_found_repo.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {

  final LostAndFoundRepo lostAndFoundRepo;

  StreamSubscription? _messagesSubscription;

  ChatCubit({required this.lostAndFoundRepo}) : super(const ChatState(
    status: ChatStateEnum.initial
  ));





Future<void> updateMessage(String messageId, String text) async {
 
  emit(state.copyWith(status: ChatStateEnum.updateMessageLoading));
  try {
    await lostAndFoundRepo.updateMessage(messageId, text);
    emit(state.copyWith(status: ChatStateEnum.updateMessageSuccess));
  } catch (e, s) {
    _mapError(e, s, ChatStateEnum.updateMessageFailure);
  }
}

Future<void> deleteMessage(String messageId) async {
  emit(state.copyWith(status: ChatStateEnum.deleteMessageLoading));
  try {
    await lostAndFoundRepo.deleteMessage(messageId);
    emit(state.copyWith(status: ChatStateEnum.deleteMessageSuccess));
  } catch (e, s) {
    _mapError(e, s, ChatStateEnum.deleteMessageFailure);
  }
}



  Future<void> getConversations() async {

    emit(state.copyWith(status: ChatStateEnum.getConversationsLoading));
    
    try {

      final conversations = await lostAndFoundRepo.getConversations(FirebaseAuth.instance.currentUser!.uid);
      emit(state.copyWith(
        status: ChatStateEnum.getConversationsSuccess,
        conversations: conversations,
      ));
    } catch (e, stackTrace) {
      _mapError(e, stackTrace, ChatStateEnum.getConversationsFailure);
    }
  }

  Future<void> getConversation(String conversationId) async {
  emit(state.copyWith(status: ChatStateEnum.getConversationLoading));
  try {
    final conversation = await lostAndFoundRepo.getConversation(conversationId);
    
    if (conversation == null) {
            emit(state.copyWith(status: ChatStateEnum.getConversationFailure, errorMsg: "Conversation not found"));
    } else {
      emit(state.copyWith(
        status: ChatStateEnum.getConversationSuccess,
        conversation: conversation,
      ));
    }
  } catch (e, stackTrace) {
    _mapError(e, stackTrace, ChatStateEnum.getConversationFailure);
  }
}

  Future<void> getMessages(String conversationId) async {

    emit(state.copyWith(status: ChatStateEnum.getMessagesLoading));
    try {
      final messages = await lostAndFoundRepo.getMessages(conversationId);
      emit(state.copyWith(
        status: ChatStateEnum.getMessagesSuccess,
        messages: messages,
      ));
    } catch (e, stackTrace) {
      _mapError(e, stackTrace, ChatStateEnum.getMessagesFailure);
    }
  }

  Future<void> listenToMessages(String conversationId) async {
  
  _messagesSubscription?.cancel();
  
  
  _messagesSubscription = lostAndFoundRepo
      .listenToMessages(conversationId)
      .listen(
        (event) => emit(state.copyWith(
          messages: event,
          status: ChatStateEnum.getMessagesSuccess,
        )),
      )
    ..onError(
      (e, stackTrace) =>
          _mapError(e, stackTrace, ChatStateEnum.getMessagesFailure),
    );
}

  Future<void> stopListeningToMessages() async {
    await _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }


Future<void> markMessagesAsRead(String conversationId) async {

    try {
      await lostAndFoundRepo.markMessageAsRead(conversationId);
      emit(state.copyWith(status: ChatStateEnum.MarkMesssageAsReadSuccess));
    } catch (e, stackTrace) {
      _mapError(e, stackTrace, ChatStateEnum.MarkMesssageAsReadFailure);
    }
  }

Future<void> setCurrentChat(String? conversationId) async {
  try {
    await lostAndFoundRepo.setCurrentChat(conversationId);
  } catch (e, s) {
    _mapError(e, s, ChatStateEnum.sendMessageFailure);
  }
}
  Future<void> sendMessage(String conversationId, String message) async {
    
    emit(state.copyWith(status: ChatStateEnum.sendMessageLoading));
    
    try {
      await lostAndFoundRepo.sendMessage(
        conversationId,
        FirebaseAuth.instance.currentUser!.uid,
        message,
      );
      emit(state.copyWith(status: ChatStateEnum.sendMessageSuccess));
    
   
    } catch (e, stackTrace) {
      _mapError(e, stackTrace, ChatStateEnum.sendMessageFailure);
    }
  }


  void _mapError(
    Object e,
    StackTrace stackTrace,
    ChatStateEnum failureStatus,
  ) {

 print('Error: $e');
 print('StackTrace: $stackTrace');
    
    emit(state.copyWith(
      status: failureStatus,
      errorMsg: _extractMessage(e),
    ));
  }

Future<void> createConversationAndSend(String otherUserId, String text) async {
  
  emit(state.copyWith(status: ChatStateEnum.sendMessageLoading));
  
  try {
    final conversation = await lostAndFoundRepo.createConversation(otherUserId);
    await lostAndFoundRepo.sendMessage(
      conversation.id,
      FirebaseAuth.instance.currentUser!.uid,
      text,
    );
    listenToMessages(conversation.id);
    markMessagesAsRead(conversation.id);
    setCurrentChat(conversation.id);
    emit(state.copyWith(
      status: ChatStateEnum.createConversationAndSendSuccess,
      conversation: conversation,
    ));
  } catch (e, s) {
    _mapError(e, s, ChatStateEnum.createConversationAndSendFailure);
  }
}

  String _extractMessage(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }


  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    return super.close();
  }
}