import 'package:equatable/equatable.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/conversation.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/message.dart';

enum ChatStateEnum{
 initial,  
 getConversationsLoading,
 getConversationsSuccess,
 getConversationsFailure,
 getConversationLoading,
 getConversationSuccess,
 getConversationFailure,
 getMessagesLoading,
 getMessagesSuccess,
 getMessagesFailure,
 sendMessageLoading,
 sendMessageSuccess,
 sendMessageFailure,
 MarkMesssageAsReadSuccess,
 MarkMesssageAsReadFailure,
 updateMessageLoading,
 updateMessageSuccess,
 updateMessageFailure,
 deleteMessageLoading,
 deleteMessageSuccess,
 deleteMessageFailure,
 createConversationAndSendSuccess,
 createConversationAndSendFailure
}

class ChatState extends Equatable{

  final ChatStateEnum status;
  final List<Message>? messages;
  final List<Conversation>? conversations;
  final String? errorMsg;
  final Conversation? conversation;
  const ChatState({required this.status, this.errorMsg,this.conversations,this.messages,this.conversation});

  ChatState copyWith({

    ChatStateEnum? status,
    String? errorMsg,
    List<Message>? messages,
    List<Conversation>? conversations,
    Conversation? conversation

  }) {
    
    return ChatState(
      
      conversation: conversation ?? this.conversation,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations
    
    );
  }
  
  @override
  List<Object?> get props => [status,errorMsg,messages,conversations,conversation];

}