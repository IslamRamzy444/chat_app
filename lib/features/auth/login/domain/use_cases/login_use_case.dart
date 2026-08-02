import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:chat_app/features/auth/login/domain/repositories/login_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class LoginUseCase {
  final LoginRepoContract _repoContract;
  LoginUseCase(this._repoContract);
  Future<BaseResponse<LoginEntity>> call(String email,String password)async{
    return _repoContract.login(email, password);
  }
}