import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';

abstract class LoginRepoContract {
  Future<BaseResponse<LoginEntity>> login(String email,String password);
}