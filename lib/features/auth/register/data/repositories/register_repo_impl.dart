import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/register/data/data_sources/register_remote_data_source_contract.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:chat_app/features/auth/register/domain/repositories/register_repo_contract.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: RegisterRepoContract)
class RegisterRepoImpl implements RegisterRepoContract{
  final RegisterRemoteDataSourceContract _dataSourceContract;
  RegisterRepoImpl(this._dataSourceContract);
  @override
  Future<BaseResponse<RegisterEntity>> register(String email, String name, String password) async{
    final response=await _dataSourceContract.registerWithEmailAndPassword(email, name, password);
    switch(response){
      
      case SuccessResonse<RegisterEntity>():
        return SuccessResonse<RegisterEntity>(data: response.data);
      case ErrorResponse<RegisterEntity>():
        return ErrorResponse<RegisterEntity>(error: response.error);
    }
  }
  
}