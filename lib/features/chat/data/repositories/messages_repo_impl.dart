import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/data_sources/remote/messages_remote_data_source_contract.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/messages_repo_contract.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: MessagesRepoContract)
class MessagesRepoImpl implements MessagesRepoContract{
  final MessagesRemoteDataSourceContract _dataSourceContract;
  MessagesRepoImpl(this._dataSourceContract);
  @override
  BaseResponse<Stream<List<MessageEntity>>> getMessages(String roomId) {
    final response=_dataSourceContract.getMessages(roomId);
    switch(response){
      
      case SuccessResponse<Stream<List<MessageModel>>>():
        final entityStream = response.data.map((models) {
        return models.map((e) => e.toEntity()).toList();
      });
      return SuccessResponse<Stream<List<MessageEntity>>>(data: entityStream);
      case ErrorResponse<Stream<List<MessageModel>>>():
        return ErrorResponse<Stream<List<MessageEntity>>>(error: response.error);
    }
  }

  @override
  Future<BaseResponse<MessageEntity>> sendMessage({required String senderId, required String senderName, required String roomId, required String content}) async{
    final message = MessageModel(
      content: content,
      senderId: senderId,
      senderName: senderName,
      roomId: roomId,
      dateTime: DateTime.now(),
    );
    final response = await _dataSourceContract.sendMessage(message);
    switch(response){
      
      case SuccessResponse<MessageModel>():
        return SuccessResponse<MessageEntity>(data: response.data.toEntity());
      case ErrorResponse<MessageModel>():
        return ErrorResponse<MessageEntity>(error: response.error);
    }
  }

}