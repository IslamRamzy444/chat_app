import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/register/data/repositories/register_repo_impl.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:chat_app/features/auth/register/domain/use_cases/register_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'register_use_case_test.mocks.dart';

@GenerateMocks([RegisterRepoImpl])
void main() {
  late RegisterUseCase registerUseCase;
  late MockRegisterRepoImpl mockRegisterRepoImpl;
  setUp(() {
    mockRegisterRepoImpl=MockRegisterRepoImpl();
    registerUseCase=RegisterUseCase(mockRegisterRepoImpl);
    provideDummy<BaseResponse<RegisterEntity>>(SuccessResponse<RegisterEntity>(data: RegisterEntity()));
  },);
  group('register use case test cases', () {
    String dummyName='TestName';
    String dummyEmail='test@email.com';
    String dummyPassword='Pas@1234';
    test('success case with success response', () async{
      when(mockRegisterRepoImpl.register(dummyEmail, dummyName, dummyPassword)).thenAnswer(
        (_) async=> SuccessResponse<RegisterEntity>(data: RegisterEntity(email: dummyEmail,name: dummyName)),
      );
      final result=await registerUseCase.call(dummyEmail, dummyName, dummyPassword);
      expect(result, isA<SuccessResponse<RegisterEntity>>());
      expect((result as SuccessResponse<RegisterEntity>).data.email, equals(dummyEmail));
      expect(result.data.name, equals(dummyName));
      verify(mockRegisterRepoImpl.register(dummyEmail, dummyName, dummyPassword)).called(1);
    },);
    test('error case with error response', () async{
      final dummyException=Exception('NetWork Error');
      when(mockRegisterRepoImpl.register(dummyEmail, dummyName, dummyPassword)).thenAnswer(
        (_) async=> ErrorResponse<RegisterEntity>(error: dummyException),
      );
      final result=await registerUseCase.call(dummyEmail, dummyName, dummyPassword);
      expect(result, isA<ErrorResponse<RegisterEntity>>());
      expect((result as ErrorResponse<RegisterEntity>).error, equals(dummyException));
      verify(mockRegisterRepoImpl.register(dummyEmail, dummyName, dummyPassword)).called(1);
    },);
  },);
}