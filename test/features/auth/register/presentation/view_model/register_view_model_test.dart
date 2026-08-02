import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:chat_app/features/auth/register/domain/use_cases/register_use_case.dart';
import 'package:chat_app/features/auth/register/presentation/view_model/register_events.dart';
import 'package:chat_app/features/auth/register/presentation/view_model/register_states.dart';
import 'package:chat_app/features/auth/register/presentation/view_model/register_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'register_view_model_test.mocks.dart';

@GenerateMocks([RegisterUseCase])
void main() {
  late RegisterViewModel viewModel;
  late MockRegisterUseCase mockRegisterUseCase;
  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    viewModel = RegisterViewModel(mockRegisterUseCase);
    provideDummy<BaseResponse<RegisterEntity>>(
      SuccessResponse<RegisterEntity>(data: RegisterEntity()),
    );
  });
  tearDown(() {
    viewModel.close();
  });
  group('register event test cases', () {
    String dummyName = 'TestName';
    String dummyEmail = 'test@email.com';
    String dummyPassword = 'Pas@1234';
    test('success case with success response', () {
      when(
        mockRegisterUseCase.call(dummyEmail, dummyName, dummyPassword),
      ).thenAnswer(
        (_) async => SuccessResponse<RegisterEntity>(
          data: RegisterEntity(name: dummyName, email: dummyEmail),
        ),
      );
      expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<RegisterStates>(
            (p0) => p0.registerState?.isLoading == true,
          ),
          predicate<RegisterStates>(
            (p0) =>
                p0.registerState?.isLoading == false &&
                p0.registerState?.data?.email == dummyEmail &&
                p0.registerState?.data?.name == dummyName,
          ),
        ]),
      );
      viewModel.doIntent(
        RegisterUserEvent(dummyEmail, dummyName, dummyPassword),
      );
    });
    test('error case with error response', () {
      final dummyException = Exception('Network Error');
      when(
        mockRegisterUseCase.call(dummyEmail, dummyName, dummyPassword),
      ).thenAnswer(
        (_) async => ErrorResponse<RegisterEntity>(error: dummyException),
      );
      expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<RegisterStates>(
            (p0) => p0.registerState?.isLoading == true,
          ),
          predicate<RegisterStates>(
            (p0) =>
                p0.registerState?.isLoading == false &&
                p0.registerState?.errorMessage == dummyException.toString(),
          ),
        ]),
      );
      viewModel.doIntent(
        RegisterUserEvent(dummyEmail, dummyName, dummyPassword),
      );
    });
  });
  group('toggle password visibility event test cases', () {
    test('should toggle isPasswordHidden from true to false', () {
      expect(viewModel.state.isPasswordHidden, true);
      viewModel.doIntent(TogglePasswordVisibilityEvent());
      expect(viewModel.state.isPasswordHidden, false);
    });

    test('should toggle isPasswordHidden from false to true', () {
      viewModel.doIntent(TogglePasswordVisibilityEvent());
      expect(viewModel.state.isPasswordHidden, false);
      viewModel.doIntent(TogglePasswordVisibilityEvent());
      expect(viewModel.state.isPasswordHidden, true);
    });

    test('should emit new state when toggling password', () {
      expect(viewModel.state.isPasswordHidden, true);

      expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<RegisterStates>((p0) => p0.isPasswordHidden == false),
        ]),
      );

      viewModel.doIntent(TogglePasswordVisibilityEvent());
    });

    test('should preserve other state properties when toggling password', () {
      final testEntity = RegisterEntity(
        userId: '123',
        email: 'test@example.com',
        name: 'Test User',
      );

      viewModel.emit(
        viewModel.state.copyWith(
          registerState: BaseState<RegisterEntity>(
            isLoading: false,
            data: testEntity,
          ),
          isPasswordHidden: true,
        ),
      );

      expect(viewModel.state.registerState?.data?.email, 'test@example.com');
      expect(viewModel.state.isPasswordHidden, true);
      viewModel.doIntent(TogglePasswordVisibilityEvent());
      expect(viewModel.state.registerState?.data?.email, 'test@example.com');
      expect(viewModel.state.isPasswordHidden, false);
    });
  });
  group('toggle confirm password visibility event test cases', () {
    test('should toggle isConfirmPasswordHidden from true to false', () {
      expect(viewModel.state.isConfirmPasswordHidden, true);
      viewModel.doIntent(ToggleConfirmPasswordVisibilityEvent());
      expect(viewModel.state.isConfirmPasswordHidden, false);
    });

    test('should toggle isConfirmPasswordHidden from false to true', () {
      viewModel.doIntent(ToggleConfirmPasswordVisibilityEvent());
      expect(viewModel.state.isConfirmPasswordHidden, false);
      viewModel.doIntent(ToggleConfirmPasswordVisibilityEvent());
      expect(viewModel.state.isConfirmPasswordHidden, true);
    });

    test('should emit new state when toggling confirm password', () {
      expect(viewModel.state.isConfirmPasswordHidden, true);
      expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<RegisterStates>(
            (p0) => p0.isConfirmPasswordHidden == false,
          ),
        ]),
      );

      viewModel.doIntent(ToggleConfirmPasswordVisibilityEvent());
    });

    test(
      'should preserve other state properties when toggling confirm password',
      () {
        final testEntity = RegisterEntity(
          userId: '123',
          email: 'test@example.com',
          name: 'Test User',
        );

        viewModel.emit(
          viewModel.state.copyWith(
            registerState: BaseState<RegisterEntity>(
              isLoading: false,
              data: testEntity,
            ),
            isConfirmPasswordHidden: true,
          ),
        );
        expect(viewModel.state.registerState?.data?.email, 'test@example.com');
        expect(viewModel.state.isConfirmPasswordHidden, true);
        viewModel.doIntent(ToggleConfirmPasswordVisibilityEvent());
        expect(viewModel.state.registerState?.data?.email, 'test@example.com');
        expect(viewModel.state.isConfirmPasswordHidden, false);
      },
    );
  });
}
