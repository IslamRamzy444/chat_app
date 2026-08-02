import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';

abstract class RegisterRemoteDataSourceContract {
  Future<BaseResponse<RegisterEntity>>registerWithEmailAndPassword(String email,String name,String password);
}