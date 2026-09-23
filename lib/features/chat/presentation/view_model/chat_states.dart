import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';

class ChatStates {
  final BaseState<UserEntity>? currentUserState;
  final BaseState<List<MessageEntity>>? messagesState;
  final String messageText;
  final BaseState<MessageEntity>? sendMessageState;
  ChatStates({this.currentUserState,this.messagesState,this.messageText='',this.sendMessageState});
  ChatStates copyWith({
    BaseState<UserEntity>? currentUserState,
    BaseState<List<MessageEntity>>? messagesState,
    String? messageText,
    BaseState<MessageEntity>? sendMessageState
  }){
    return ChatStates(
      currentUserState: currentUserState ?? this.currentUserState,
      messagesState: messagesState ?? this.messagesState,
      messageText: messageText ?? this.messageText,
      sendMessageState: sendMessageState ?? this.sendMessageState
    );
  }
}