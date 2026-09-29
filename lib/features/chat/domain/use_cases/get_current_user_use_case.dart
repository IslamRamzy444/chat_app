import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/user_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetCurrentUserUseCase {
  final UserRepoContract _repoContract;
  GetCurrentUserUseCase(this._repoContract);
  Future<BaseResponse<UserEntity>> call()async{
    return _repoContract.getCurrentUser();
  }
}