import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/login/data/data_sources/login_remote_data_source_impl.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'login_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([FirebaseAuth,UserCredential,User])
void main() {
  late LoginRemoteDataSourceImpl dataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testUid = 'uid123';
  const testDisplayName = 'Test User';
  setUp(() {
    mockFirebaseAuth=MockFirebaseAuth();
    mockUser=MockUser();
    mockUserCredential=MockUserCredential();
    dataSource=LoginRemoteDataSourceImpl(mockFirebaseAuth);
  },);
  group('login remote data source impl test cases',() {
    test('success case with success response', () async{
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: testEmail, password: testPassword)).thenAnswer(
        (_) async=> mockUserCredential,
      );
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(testUid);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUser.displayName).thenReturn(testDisplayName);
      final result = await dataSource.loginWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(result, isA<SuccessResponse<LoginEntity>>());
      expect((result as SuccessResponse<LoginEntity>).data.userId, testUid);
      expect(result.data.email, testEmail);
      expect(result.data.name, testDisplayName);
    },);
    test('should return ErrorResponse when FirebaseAuthException is thrown',() async {
      const errorMessage = 'Invalid email or password';
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(FirebaseAuthException(code: 'invalid-credential', message: errorMessage));

      // Act
      final result = await dataSource.loginWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(result, isA<ErrorResponse<LoginEntity>>());
      expect((result as ErrorResponse<LoginEntity>).error.toString(),contains(errorMessage));
    });
    test('should return ErrorResponse when generic Exception is thrown',() async {
      const errorMessage = 'Something went wrong';
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(Exception(errorMessage));
      final result = await dataSource.loginWithEmailAndPassword(
        testEmail,
        testPassword,
      );
      expect(result, isA<ErrorResponse<LoginEntity>>());
      expect((result as ErrorResponse<LoginEntity>).error.toString(),contains(errorMessage));
    });
  }, );
}