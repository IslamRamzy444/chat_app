import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';

class RegisterStates {
  BaseState<RegisterEntity>? registerState;
  bool? isPasswordHidden;
  bool? isConfirmPasswordHidden;
  RegisterStates({this.registerState,this.isPasswordHidden=true,this.isConfirmPasswordHidden=true});
  RegisterStates copyWith({
    BaseState<RegisterEntity>? registerState,
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden
  }){
    return RegisterStates(
      registerState: registerState ?? this.registerState,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden: isConfirmPasswordHidden ?? this.isConfirmPasswordHidden
    );
  }
}