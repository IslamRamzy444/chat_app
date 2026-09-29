import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/repositories/user_repo_impl.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'user_repo_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  User,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late UserRepoImpl userRepoImpl;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockUsersCollection;
  late MockDocumentReference<Map<String, dynamic>> mockUserDoc;

  const tUid = 'uid_123';
  const tEmail = 'alice@example.com';
  const tDisplayName = 'Alice';

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUsersCollection = MockCollectionReference<Map<String, dynamic>>();
    mockUserDoc = MockDocumentReference<Map<String, dynamic>>();

    userRepoImpl = UserRepoImpl(mockAuth, mockFirestore);

    // Common Firestore chain: collection('users') -> doc(uid)
    when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
    when(mockUsersCollection.doc(tUid)).thenReturn(mockUserDoc);
  });

  group('getCurrentUser', () {
    test(
      'returns ErrorResponse when firebase user is null (unauthenticated)',
      () async {
        // Arrange
        when(mockAuth.currentUser).thenReturn(null);

        // Act
        final result = await userRepoImpl.getCurrentUser();

        // Assert
        expect(result, isA<ErrorResponse<UserEntity>>());
        expect(
          (result as ErrorResponse).error.toString(),
          contains('User not authenticated'),
        );

        verifyNever(mockFirestore.collection(any));
      },
    );

    test('returns SuccessResponse from firebase user when firestore doc '
        'has no data', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn(tUid);
      when(mockUser.email).thenReturn(tEmail);
      when(mockUser.displayName).thenReturn(tDisplayName);
      when(mockAuth.currentUser).thenReturn(mockUser);

      final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      when(mockUserDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(null);

      // Act
      final result = await userRepoImpl.getCurrentUser();

      // Assert
      expect(result, isA<SuccessResponse<UserEntity>>());
      final entity = (result as SuccessResponse<UserEntity>).data;
      expect(entity.id, tUid);
      expect(entity.email, tEmail);
      expect(entity.name, tDisplayName);
    });

    test(
      'returns SuccessResponse using firestore data when doc exists',
      () async {
        // Arrange
        final mockUser = MockUser();
        when(mockUser.uid).thenReturn(tUid);
        when(mockUser.email).thenReturn('fallback@example.com');
        when(mockUser.displayName).thenReturn('Fallback Name');
        when(mockAuth.currentUser).thenReturn(mockUser);

        final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockUserDoc.get()).thenAnswer((_) async => mockSnapshot);
        when(
          mockSnapshot.data(),
        ).thenReturn({'email': tEmail, 'displayName': tDisplayName});

        // Act
        final result = await userRepoImpl.getCurrentUser();

        // Assert
        expect(result, isA<SuccessResponse<UserEntity>>());
        final entity = (result as SuccessResponse<UserEntity>).data;
        expect(entity.id, tUid);
        expect(entity.email, tEmail); // came from firestore, not auth
        expect(entity.name, tDisplayName); // came from firestore, not auth
      },
    );

    test('falls back to firebase auth values when firestore doc is missing '
        'email and displayName', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn(tUid);
      when(mockUser.email).thenReturn(tEmail);
      when(mockUser.displayName).thenReturn(tDisplayName);
      when(mockAuth.currentUser).thenReturn(mockUser);

      final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      when(mockUserDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(<String, dynamic>{});

      // Act
      final result = await userRepoImpl.getCurrentUser();

      // Assert
      final entity = (result as SuccessResponse<UserEntity>).data;
      expect(entity.email, tEmail);
      expect(entity.name, tDisplayName);
    });

    test(
      'uses empty string / "User" defaults when both sources are null',
      () async {
        // Arrange
        final mockUser = MockUser();
        when(mockUser.uid).thenReturn(tUid);
        when(mockUser.email).thenReturn(null);
        when(mockUser.displayName).thenReturn(null);
        when(mockAuth.currentUser).thenReturn(mockUser);

        final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockUserDoc.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.data()).thenReturn(null);

        // Act
        final result = await userRepoImpl.getCurrentUser();

        // Assert
        final entity = (result as SuccessResponse<UserEntity>).data;
        expect(entity.email, '');
        expect(entity.name, 'User');
      },
    );

    test('returns ErrorResponse when firestore.get() throws', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.uid).thenReturn(tUid);
      when(mockUser.email).thenReturn(tEmail);
      when(mockUser.displayName).thenReturn(tDisplayName);
      when(mockAuth.currentUser).thenReturn(mockUser);

      when(mockUserDoc.get()).thenThrow(Exception('Firestore down'));

      // Act
      final result = await userRepoImpl.getCurrentUser();

      // Assert
      expect(result, isA<ErrorResponse<UserEntity>>());
      expect(
        (result as ErrorResponse).error.toString(),
        contains('Firestore down'),
      );
    });
  });
}
