import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/login/data/repositories/login_repo_impl.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:chat_app/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([LoginRepoImpl])
void main() {
  late LoginUseCase loginUseCase;
  late MockLoginRepoImpl mockLoginRepoImpl;
  setUp(() {
    mockLoginRepoImpl=MockLoginRepoImpl();
    loginUseCase=LoginUseCase(mockLoginRepoImpl);
    provideDummy<BaseResponse<LoginEntity>>(SuccessResponse<LoginEntity>(data: LoginEntity()));
  },);
  group('login use case test cases', () {
    String email='testemail@gmail.com';
    String password='test_password';
    test('success case with success response', () async{
      when(mockLoginRepoImpl.login(email, password)).thenAnswer(
        (_) async=> SuccessResponse<LoginEntity>(data: LoginEntity(email: email)),
      );
      final result=await loginUseCase.call(email, password);
      expect(result, isA<SuccessResponse<LoginEntity>>());
      expect((result as SuccessResponse<LoginEntity>).data.email, equals(email));
      verify(mockLoginRepoImpl.login(email, password)).called(1);
    },);
    test('failure case with error response', () async{
      final dummyException=Exception('Invalid email or password');
      when(mockLoginRepoImpl.login(email, password)).thenAnswer(
        (_) async=> ErrorResponse<LoginEntity>(error: dummyException),
      );
      final result=await loginUseCase.call(email, password);
      expect(result, isA<ErrorResponse<LoginEntity>>());
      expect((result as ErrorResponse<LoginEntity>).error, equals(dummyException));
      verify(mockLoginRepoImpl.login(email, password)).called(1);
    },);
  },);
}