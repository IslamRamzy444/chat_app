import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:chat_app/features/auth/register/domain/repositories/register_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class RegisterUseCase {
  final RegisterRepoContract _repoContract;
  RegisterUseCase(this._repoContract);
  Future<BaseResponse<RegisterEntity>> call(String email,String name,String password)async{
    return _repoContract.register(email, name, password);
  }
}