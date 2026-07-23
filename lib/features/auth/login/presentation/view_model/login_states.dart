import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';

class LoginStates {
  BaseState<LoginEntity>? loginUserState;
  bool? isPasswordHidden;
  LoginStates({this.loginUserState,this.isPasswordHidden=true});
  LoginStates copyWith({
    BaseState<LoginEntity>? loginUserState,
    bool? isPasswordHidden
  }){
    return LoginStates(
      loginUserState: loginUserState ?? this.loginUserState,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden
    );
  }
}