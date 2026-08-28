import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/data/data_sources/remote/rooms_remote_data_source_impl.dart';
import 'package:chat_app/features/home/data/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'rooms_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
  DocumentSnapshot,
])
void main() {
  late RoomsRemoteDataSourceImpl dataSourceImpl;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

  const testRoomId = 'test_room_456';
  const testRoomName = 'Test Room';
  const testRoomDescription = 'Test Description';
  const testCategoryId = 'sports';

  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    dataSourceImpl = RoomsRemoteDataSourceImpl(mockFirebaseFirestore);
  });

  group('rooms remote data source implementation test cases', () {
    group('getRooms test cases', () {
      test('success case with success response with list of rooms', () async {
        final testRoomData = {
          'id': testRoomId,
          'name': testRoomName,
          'description': testRoomDescription,
          'categoryId': testCategoryId,
          'createdAt': Timestamp.now(),
        };

        when(mockFirebaseFirestore.collection('rooms'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.orderBy('createdAt', descending: false))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs)
            .thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data())
            .thenReturn(testRoomData);
        when(mockQueryDocumentSnapshot.id)
            .thenReturn(testRoomId);

        final result = await dataSourceImpl.getRooms();

        expect(result, isA<SuccessResponse<List<RoomModel>>>());
        final successResponse = result as SuccessResponse<List<RoomModel>>;
        expect(successResponse.data.length, equals(1));
        expect(successResponse.data[0].id, equals(testRoomId));
        expect(successResponse.data[0].name, equals(testRoomName));
        expect(successResponse.data[0].description, equals(testRoomDescription));
        expect(successResponse.data[0].categoryId, equals(testCategoryId));
        expect(successResponse.data[0].createdAt, isNotNull);
      });

      test('success case with success response with empty list', () async {
        when(mockFirebaseFirestore.collection('rooms'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.orderBy('createdAt', descending: false))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs)
            .thenReturn([]);

        final result = await dataSourceImpl.getRooms();

        expect(result, isA<SuccessResponse<List<RoomModel>>>());
        final successResponse = result as SuccessResponse<List<RoomModel>>;
        expect(successResponse.data, isEmpty);
      });

      test('error case with error response', () async {
        final testError = Exception('Firestore error');

        when(mockFirebaseFirestore.collection('rooms'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.orderBy('createdAt', descending: false))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.get())
            .thenThrow(testError);

        final result = await dataSourceImpl.getRooms();

        expect(result, isA<ErrorResponse<List<RoomModel>>>());
        final errorResponse = result as ErrorResponse<List<RoomModel>>;
        expect(errorResponse.error.toString(), contains(testError.toString()));
      });
    });

    group('createRooms test cases', () {
      test('success case with success response', () async {
        final room = RoomModel(
          name: testRoomName,
          description: testRoomDescription,
          categoryId: testCategoryId,
        );

        final testRoomData = {
          'id': testRoomId,
          'name': testRoomName,
          'description': testRoomDescription,
          'categoryId': testCategoryId,
          'createdAt': Timestamp.now(),
        };

        when(mockFirebaseFirestore.collection('rooms'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc())
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.id)
            .thenReturn(testRoomId);
        when(mockDocumentReference.set(any))
            .thenAnswer((_) async => Future.value());
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data())
            .thenReturn(testRoomData);
        when(mockDocumentSnapshot.id)
            .thenReturn(testRoomId);

        final result = await dataSourceImpl.createRoom(room);

        expect(result, isA<SuccessResponse<RoomModel>>());
        final successResponse = result as SuccessResponse<RoomModel>;
        expect(successResponse.data.id, equals(testRoomId));
        expect(successResponse.data.name, equals(testRoomName));
        expect(successResponse.data.description, equals(testRoomDescription));
        expect(successResponse.data.categoryId, equals(testCategoryId));
        expect(successResponse.data.createdAt, isNotNull);
      });

      test('error case with error response', () async {
        final room = RoomModel(
          name: testRoomName,
          description: testRoomDescription,
          categoryId: testCategoryId,
        );

        final testError = Exception('Firestore write error');

        when(mockFirebaseFirestore.collection('rooms'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc())
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.id)
            .thenReturn(testRoomId);
        when(mockDocumentReference.set(any))
            .thenThrow(testError);

        final result = await dataSourceImpl.createRoom(room);

        expect(result, isA<ErrorResponse<RoomModel>>());
        final errorResponse = result as ErrorResponse<RoomModel>;
        expect(errorResponse.error.toString(), contains(testError.toString()));
      });
    });
  });
}