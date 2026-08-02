import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/register/data/data_sources/register_remote_data_source_impl.dart';
import 'package:chat_app/features/auth/register/data/repositories/register_repo_impl.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'register_repo_impl_test.mocks.dart';

@GenerateMocks([RegisterRemoteDataSourceImpl])
void main() {
  late RegisterRepoImpl registerRepoImpl;
  late MockRegisterRemoteDataSourceImpl mockRegisterRemoteDataSourceImpl;
  setUp(() {
    mockRegisterRemoteDataSourceImpl=MockRegisterRemoteDataSourceImpl();
    registerRepoImpl=RegisterRepoImpl(mockRegisterRemoteDataSourceImpl);
    provideDummy<BaseResponse<RegisterEntity>>(SuccessResponse<RegisterEntity>(data: RegisterEntity()));
  },);
  group('register repo impl test cases', () {
    String dummyName='TestName';
    String dummyEmail='test@email.com';
    String dummyPassword='Pas@1234';
    test('success case with success response', () async{
      when(mockRegisterRemoteDataSourceImpl.registerWithEmailAndPassword(dummyEmail, dummyName, dummyPassword)).thenAnswer(
        (_) async=> SuccessResponse<RegisterEntity>(data: RegisterEntity(email: dummyEmail,name: dummyName)),
      );
      final result=await registerRepoImpl.register(dummyEmail, dummyName, dummyPassword);
      expect(result, isA<SuccessResponse<RegisterEntity>>());
      expect((result as SuccessResponse<RegisterEntity>).data.email, equals(dummyEmail));
      expect(result.data.name, equals(dummyName));
      verify(mockRegisterRemoteDataSourceImpl.registerWithEmailAndPassword(dummyEmail, dummyName, dummyPassword)).called(1);
    },);
    test('error case with error response', () async{
      final dummyException=Exception('Network error');
      when(mockRegisterRemoteDataSourceImpl.registerWithEmailAndPassword(dummyEmail, dummyName, dummyPassword)).thenAnswer(
        (_) async=> ErrorResponse<RegisterEntity>(error: dummyException),
      );
      final result=await registerRepoImpl.register(dummyEmail, dummyName, dummyPassword);
      expect(result, isA<ErrorResponse<RegisterEntity>>());
      expect((result as ErrorResponse<RegisterEntity>).error, equals(dummyException));
      verify(mockRegisterRemoteDataSourceImpl.registerWithEmailAndPassword(dummyEmail, dummyName, dummyPassword)).called(1);
    },);
  },);
}