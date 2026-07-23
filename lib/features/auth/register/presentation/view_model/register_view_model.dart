import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:chat_app/features/auth/register/domain/use_cases/register_use_case.dart';
import 'package:chat_app/features/auth/register/presentation/view_model/register_events.dart';
import 'package:chat_app/features/auth/register/presentation/view_model/register_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
@injectable
class RegisterViewModel extends Cubit<RegisterStates>{
  final RegisterUseCase _registerUseCase;
  RegisterViewModel(this._registerUseCase):super(RegisterStates());
  void doIntent(RegisterEvents event){
    switch(event){
      
      case RegisterUserEvent():
        _registerUser(event.email, event.name, event.password);
      case TogglePasswordVisibilityEvent():
        _togglePasswordVisibility();
      case ToggleConfirmPasswordVisibilityEvent():
        _toggleConfirmPasswordVisibility();
    }
  }
  Future<void> _registerUser(String email,String name,String password)async{
    emit(state.copyWith(
      registerState: BaseState<RegisterEntity>(isLoading: true)
    ));
    final res=await _registerUseCase.call(email, name, password);
    switch(res){
      
      case SuccessResonse<RegisterEntity>():
        emit(state.copyWith(
          registerState: BaseState<RegisterEntity>(
            isLoading: false,
            data: res.data
          )
        ));
      case ErrorResponse<RegisterEntity>():
        emit(state.copyWith(
          registerState: BaseState<RegisterEntity>(
            isLoading: false,
            errorMessage: res.error.toString()
          )
        ));
    }
  }
  void _togglePasswordVisibility(){
    emit(state.copyWith(
      isPasswordHidden: !state.isPasswordHidden!
    ));
  }
  void _toggleConfirmPasswordVisibility(){
    emit(state.copyWith(
      isConfirmPasswordHidden: !state.isConfirmPasswordHidden!
    ));
  }
}