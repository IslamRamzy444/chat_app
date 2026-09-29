import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';

abstract class UserRepoContract {
  Future<BaseResponse<UserEntity>> getCurrentUser();
}