import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';

abstract class MessagesRepoContract {
  Future<BaseResponse<MessageEntity>> sendMessage({
    required String senderId,
    required String senderName,
    required String roomId,
    required String content,
  });
  BaseResponse<Stream<List<MessageEntity>>> getMessages(String roomId);
}