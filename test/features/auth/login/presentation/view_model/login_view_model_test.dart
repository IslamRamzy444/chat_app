import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:chat_app/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:chat_app/features/auth/login/presentation/view_model/login_events.dart';
import 'package:chat_app/features/auth/login/presentation/view_model/login_states.dart';
import 'package:chat_app/features/auth/login/presentation/view_model/login_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'login_view_model_test.mocks.dart';

@GenerateMocks([LoginUseCase])
void main() {
  late LoginViewModel loginViewModel;
  late MockLoginUseCase mockLoginUseCase;
  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginViewModel = LoginViewModel(mockLoginUseCase);
    provideDummy<BaseResponse<LoginEntity>>(
      SuccessResponse<LoginEntity>(data: LoginEntity()),
    );
  });
  tearDown(() {
    loginViewModel.close();
  });
  group('login view model test cases', () {
    group('login user event test cases', () {
      String dummyEmail = 'testemail@gmail.com';
      String dummyPassword = 'test_password';
      test('success case with success response', () {
        when(mockLoginUseCase.call(dummyEmail, dummyPassword)).thenAnswer(
          (_) async => SuccessResponse<LoginEntity>(
            data: LoginEntity(email: dummyEmail),
          ),
        );
        expectLater(
          loginViewModel.stream,
          emitsInOrder([
            predicate<LoginStates>(
              (p0) => p0.loginUserState?.isLoading == true,
            ),
            predicate<LoginStates>(
              (p0) =>
                  p0.loginUserState?.isLoading == false &&
                  p0.loginUserState?.data?.email == dummyEmail,
            ),
          ]),
        );
        loginViewModel.doIntent(LoginUserEvent(dummyEmail, dummyPassword));
      });
      test('failure case with error response', () {
        final dummyException = Exception('Invalid email or password');
        when(mockLoginUseCase.call(dummyEmail, dummyPassword)).thenAnswer(
          (_) async => ErrorResponse<LoginEntity>(error: dummyException),
        );
        expectLater(
          loginViewModel.stream,
          emitsInOrder([
            predicate<LoginStates>(
              (p0) => p0.loginUserState?.isLoading == true,
            ),
            predicate<LoginStates>(
              (p0) =>
                  p0.loginUserState?.isLoading == false &&
                  p0.loginUserState?.errorMessage == dummyException.toString(),
            ),
          ]),
        );
        loginViewModel.doIntent(LoginUserEvent(dummyEmail, dummyPassword));
      });
    });
    group('toggle password visibility event test cases', () {
      test('should toggle isPasswordHidden from true to false', () {
        expect(loginViewModel.state.isPasswordHidden, true);
        loginViewModel.doIntent(TogglePasswordVisibilityEvent());
        expect(loginViewModel.state.isPasswordHidden, false);
      });

      test('should toggle isPasswordHidden from false to true', () {
        loginViewModel.doIntent(TogglePasswordVisibilityEvent());
        expect(loginViewModel.state.isPasswordHidden, false);
        loginViewModel.doIntent(TogglePasswordVisibilityEvent());
        expect(loginViewModel.state.isPasswordHidden, true);
      });

      test('should emit new state when toggling', () {
        expect(loginViewModel.state.isPasswordHidden, true);
        expectLater(
          loginViewModel.stream,
          emitsInOrder([
            predicate<LoginStates>((p0) => p0.isPasswordHidden == false),
          ]),
        );
        loginViewModel.doIntent(TogglePasswordVisibilityEvent());
      });

      test('should preserve other state properties when toggling', () {
        final testEntity = LoginEntity(
          userId: '123',
          email: 'test@example.com',
          name: 'Test User',
        );

        loginViewModel.emit(
          loginViewModel.state.copyWith(
            loginUserState: BaseState<LoginEntity>(
              isLoading: false,
              data: testEntity,
            ),
            isPasswordHidden: true,
          ),
        );

        expect(
          loginViewModel.state.loginUserState?.data?.email,
          'test@example.com',
        );
        expect(loginViewModel.state.isPasswordHidden, true);

        loginViewModel.doIntent(TogglePasswordVisibilityEvent());

        expect(
          loginViewModel.state.loginUserState?.data?.email,
          'test@example.com',
        );
        expect(loginViewModel.state.isPasswordHidden, false);
      });
    });
  });
}
