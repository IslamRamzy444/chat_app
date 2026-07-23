import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/login/data/data_sources/login_remote_data_source_contract.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:chat_app/features/auth/login/domain/repositories/login_repo_contract.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: LoginRepoContract)
class LoginRepoImpl implements LoginRepoContract{
  final LoginRemoteDataSourceContract _contract;
  LoginRepoImpl(this._contract);
  @override
  Future<BaseResponse<LoginEntity>> login(String email, String password) async{
    final response=await _contract.loginWithEmailAndPassword(email, password);
    switch(response){
      
      case SuccessResonse<LoginEntity>():
        return SuccessResonse<LoginEntity>(data: response.data);
      case ErrorResponse<LoginEntity>():
        return ErrorResponse<LoginEntity>(error: response.error);
    }
  }

}