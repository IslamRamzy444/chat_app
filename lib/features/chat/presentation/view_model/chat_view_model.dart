import 'dart:async';

import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_current_user_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_events.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
@injectable
class ChatViewModel extends Cubit<ChatStates>{
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  StreamSubscription? _messagesSubscription;
  UserEntity? _currentUser;
  ChatViewModel(this._getCurrentUserUseCase,this._getMessagesUseCase,this._sendMessageUseCase):super(ChatStates());
  void doIntent(ChatEvents event){
    if (isClosed) return;
    switch(event){
      
      case LoadCurrentUserEvent():
        _loadCurrentUser();
      case LoadMessagesEvent():
        _loadMessages(event);
      case SendMessageEvent():
        _sendMessage(event);
      case UpdateMessageTextEvent():
        _updateMessageText(event);
    }
  } 
  UserEntity? get currentUser => _currentUser;
  Future<void> _loadCurrentUser()async{
    if (isClosed) return;
    emit(state.copyWith(
      currentUserState: BaseState<UserEntity>(isLoading: true)
    ));
    final res=await _getCurrentUserUseCase.call();
    if (isClosed) return;
    switch(res){
      
      case SuccessResponse<UserEntity>():
        _currentUser=res.data;
        emit(state.copyWith(
          currentUserState: BaseState<UserEntity>(
            isLoading: false,
            data: res.data
          )
        ));
      case ErrorResponse<UserEntity>():
        emit(state.copyWith(
          currentUserState: BaseState<UserEntity>(
            isLoading: false,
            errorMessage: res.error.toString()
          )
        ));
    }
  }
  void _loadMessages(LoadMessagesEvent event){
    if (isClosed) return;
    _messagesSubscription?.cancel();
    final res=_getMessagesUseCase.call(event.roomId);
    switch(res){
      
      case SuccessResponse<Stream<List<MessageEntity>>>():
        emit(state.copyWith(
          messagesState: BaseState<List<MessageEntity>>(isLoading: false)
        ));
        _messagesSubscription=res.data.listen((messages) {
          if (isClosed) return;
          emit(state.copyWith(
            messagesState: BaseState<List<MessageEntity>>(
              isLoading: false,
              data: messages
            )
          ));
        },
        onError: (error) {
          if (isClosed) return;
          emit(state.copyWith(
            messagesState: BaseState<List<MessageEntity>>(
              isLoading: false,
              errorMessage: error.toString()
            )
          ));
        },
        );
      case ErrorResponse<Stream<List<MessageEntity>>>():
        emit(state.copyWith(
          messagesState: BaseState<List<MessageEntity>>(
            isLoading: false,
            errorMessage: res.error.toString()
          )
        ));
    }
  }
  Future<void> _sendMessage(SendMessageEvent event)async{
    if (event.content.trim().isEmpty || _currentUser == null) return;
    emit(state.copyWith(
      messageText: '',
      sendMessageState: BaseState<MessageEntity>(
        isLoading: true
      )
    ));
    final res=await _sendMessageUseCase.call(
      senderId: _currentUser!.id, 
      senderName: _currentUser!.name, 
      roomId: event.roomId, 
      content: event.content
    );
    if (isClosed) return;
    switch(res){
      
      case SuccessResponse<MessageEntity>():
        emit(state.copyWith(
          sendMessageState: BaseState<MessageEntity>(
            isLoading: false,
            data: res.data
          )
        ));
      case ErrorResponse<MessageEntity>():
        emit(state.copyWith(
          sendMessageState: BaseState<MessageEntity>(
            isLoading: false,
            errorMessage: res.error.toString()
          )
        ));
    }
  }
  void _updateMessageText(UpdateMessageTextEvent event) {
    if (isClosed) return;
    emit(state.copyWith(messageText: event.text));
  }
  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}