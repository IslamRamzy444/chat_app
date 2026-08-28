import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/register/data/data_sources/register_remote_data_source_impl.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'register_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {
  late RegisterRemoteDataSourceImpl dataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testName = 'Test User';
  const testUid = 'uid123';
  const testDisplayName = 'Test User';

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    dataSource = RegisterRemoteDataSourceImpl(mockFirebaseAuth);
  });

  group('register remote data source impl test cases', () {
    test('success case with success response', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(testUid);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUser.displayName).thenReturn(testDisplayName);
      final result = await dataSource.registerWithEmailAndPassword(
        testEmail,
        testName,
        testPassword,
      );
      expect(result, isA<SuccessResponse<RegisterEntity>>());
      expect((result as SuccessResponse<RegisterEntity>).data.userId, testUid);
      expect(result.data.email, testEmail);
      expect(result.data.name, testDisplayName);
    });

    test(
      'should return ErrorResponse when FirebaseAuthException is thrown',
      () async {
        const errorMessage = 'Email already in use';
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'email-already-in-use',
            message: errorMessage,
          ),
        );
        final result = await dataSource.registerWithEmailAndPassword(
          testEmail,
          testName,
          testPassword,
        );
        expect(result, isA<ErrorResponse<RegisterEntity>>());
        expect(
          (result as ErrorResponse<RegisterEntity>).error.toString(),
          contains(errorMessage),
        );
      },
    );

    test(
      'should return ErrorResponse when generic Exception is thrown',
      () async {
        const errorMessage = 'Network error';
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenThrow(Exception(errorMessage));
        final result = await dataSource.registerWithEmailAndPassword(
          testEmail,
          testName,
          testPassword,
        );
        expect(result, isA<ErrorResponse<RegisterEntity>>());
        expect(
          (result as ErrorResponse<RegisterEntity>).error.toString(),
          contains(errorMessage),
        );
      },
    );
  });
}
