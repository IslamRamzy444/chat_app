import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';

abstract class MessagesRemoteDataSourceContract {
  Future<BaseResponse<MessageModel>> sendMessage(MessageModel message);
  BaseResponse<Stream<List<MessageModel>>> getMessages(String roomId);
}