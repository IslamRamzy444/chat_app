import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/messages_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetMessagesUseCase {
  final MessagesRepoContract _repoContract;
  GetMessagesUseCase(this._repoContract);
  BaseResponse<Stream<List<MessageEntity>>> call(String roomId) {
    return _repoContract.getMessages(roomId);
  }
}