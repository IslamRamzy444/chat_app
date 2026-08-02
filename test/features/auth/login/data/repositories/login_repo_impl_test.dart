import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/login/data/data_sources/login_remote_data_source_impl.dart';
import 'package:chat_app/features/auth/login/data/repositories/login_repo_impl.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'login_repo_impl_test.mocks.dart';

@GenerateMocks([LoginRemoteDataSourceImpl])
void main() {
  late LoginRepoImpl loginRepoImpl;
  late MockLoginRemoteDataSourceImpl mockLoginRemoteDataSourceImpl;
  setUp(() {
    mockLoginRemoteDataSourceImpl=MockLoginRemoteDataSourceImpl();
    loginRepoImpl=LoginRepoImpl(mockLoginRemoteDataSourceImpl);
    provideDummy<BaseResponse<LoginEntity>>(SuccessResponse<LoginEntity>(data: LoginEntity()));
  },);
  group('login repo impl test cases', () {
    String testEmail='testemail@gmail.com';
        String testPassword='test_password';
      test('success case with success response', () async{
        when(mockLoginRemoteDataSourceImpl.loginWithEmailAndPassword(testEmail, testPassword)).thenAnswer(
          (_) async=> SuccessResponse<LoginEntity>(data: LoginEntity(
            email: testEmail
          )),
        );
        final result=await loginRepoImpl.login(testEmail, testPassword);
        expect(result, isA<SuccessResponse<LoginEntity>>());
        expect((result as SuccessResponse<LoginEntity>).data.email, equals(testEmail));
        verify(mockLoginRemoteDataSourceImpl.loginWithEmailAndPassword(testEmail, testPassword)).called(1);
      },);
      test('failure case with error response', () async{
        final dummyException=Exception('invalid email or password');
        when(mockLoginRemoteDataSourceImpl.loginWithEmailAndPassword(testEmail, testPassword)).thenAnswer(
          (_) async=> ErrorResponse<LoginEntity>(error: dummyException),
        );
        final result=await loginRepoImpl.login(testEmail, testPassword);
        expect(result, isA<ErrorResponse<LoginEntity>>());
        expect((result as ErrorResponse<LoginEntity>).error, equals(dummyException));
        verify(mockLoginRemoteDataSourceImpl.loginWithEmailAndPassword(testEmail, testPassword)).called(1);
      },);
    },);
}