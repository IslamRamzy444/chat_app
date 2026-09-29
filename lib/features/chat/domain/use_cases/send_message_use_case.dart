import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/messages_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class SendMessageUseCase {
  final MessagesRepoContract _repoContract;
  SendMessageUseCase(this._repoContract);
  Future<BaseResponse<MessageEntity>> call({
    required String senderId,
    required String senderName,
    required String roomId,
    required String content,
  }) async {
    return _repoContract.sendMessage(
      senderId: senderId,
      senderName: senderName,
      roomId: roomId,
      content: content,
    );
  }
}