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

  Future<void> getConversations() async {

    emit(state.copyWith(status: ChatStateEnum.getConversationsLoading));
    try {
      final conversations = await lostAndFoundRepo.getConversations(
        FirebaseAuth.instance.currentUser!.uid,
      );
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
      final conversation =
          await lostAndFoundRepo.getConversation(conversationId);
      emit(state.copyWith(
        status: ChatStateEnum.getConversationSuccess,
        conversation: conversation,
      ));
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


  Future<void> createConversation(String participantId) async {
    emit(state.copyWith(status: ChatStateEnum.createConversationLoading));
    try {
      await lostAndFoundRepo.createConversation(FirebaseAuth.instance.currentUser!.uid,participantId);
      emit(state.copyWith(status: ChatStateEnum.createConversationSuccess));
    } catch (e, stackTrace) {
      _mapError(e, stackTrace, ChatStateEnum.createConversationFailure);
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
    assert(() {
      // ignore: avoid_print
      print('[ChatCubit] Error: $e\n$stackTrace');
      return true;
    }());

    emit(state.copyWith(
      status: failureStatus,
      errorMsg: _extractMessage(e),
    ));
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