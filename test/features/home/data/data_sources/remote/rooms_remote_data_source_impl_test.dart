import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/data/data_sources/remote/rooms_remote_data_source_impl.dart';
import 'package:chat_app/features/home/data/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'rooms_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([FirebaseFirestore,DocumentReference,CollectionReference,QuerySnapshot,QueryDocumentSnapshot,DocumentSnapshot])
void main() {
  late RoomsRemoteDataSourceImpl dataSourceImpl;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockCollectionReference<Map<String,dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String,dynamic>> mockDocumentReference;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  const testUserId = 'test_user_123';
  const testRoomId = 'test_room_456';
  const testRoomName = 'Test Room';
  const testRoomDescription = 'Test Description';
  const testCategoryId = 'sports';
  setUp(() {
    mockFirebaseFirestore=MockFirebaseFirestore();
    mockCollectionReference=MockCollectionReference<Map<String,dynamic>>();
    mockDocumentReference=MockDocumentReference<Map<String,dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    dataSourceImpl=RoomsRemoteDataSourceImpl(mockFirebaseFirestore);
  },);
  group('rooms remote data source implementation test cases',() {
    group('getRooms test cases', () {
      test('success case with success response with list of rooms', () async{
        final testRoomData = {
          'id': testRoomId,
          'name': testRoomName,
          'description': testRoomDescription,
          'categoryId': testCategoryId,
          'createdAt': Timestamp.now(),
        };
        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(testUserId))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.collection('rooms'))
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
        final result=await dataSourceImpl.getRooms(testUserId);
        expect(result, isA<SuccessResponse<List<RoomModel>>>());
        expect((result as SuccessResponse<List<RoomModel>>).data.length, equals(1));
        expect(result.data[0].id,equals(testRoomId));
        expect(result.data[0].name,equals(testRoomName));
        expect(result.data[0].description,equals(testRoomDescription));
        expect(result.data[0].categoryId,equals(testCategoryId));
        expect(result.data[0].createdAt,equals(isNotNull));
      },);
      test('success case with success response with empty list', () async{
        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(testUserId))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.collection('rooms'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.orderBy('createdAt', descending: false))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs)
            .thenReturn([]);
        final result=await dataSourceImpl.getRooms(testUserId);
        expect(result, isA<SuccessResponse<List<RoomModel>>>());
        expect((result as SuccessResponse<List<RoomModel>>).data, equals(isEmpty));
      },);
      test('error case with error response', () async{
        final testError = Exception('Firestore error');
        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(testUserId))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.collection('rooms'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.orderBy('createdAt', descending: false))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.get())
            .thenThrow(testError);
        final result = await dataSourceImpl.getRooms(testUserId);
        expect(result, isA<ErrorResponse<List<RoomModel>>>());
        expect((result as ErrorResponse<List<RoomModel>>).error.toString(), equals(contains(testError.toString())));
      },);
    },);
    group('createRooms test cases', () {
      test('success case with success response', () async{
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
        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(testUserId))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.collection('rooms'))
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
        final result = await dataSourceImpl.createRoom(room, testUserId);
        expect(result, isA<SuccessResponse<RoomModel>>());
        expect((result as SuccessResponse<RoomModel>).data.id, equals(testRoomId));
        expect(result.data.name, equals(testRoomName));
        expect(result.data.description, equals(testRoomDescription));
        expect(result.data.categoryId, equals(testCategoryId));
        expect(result.data.createdAt, equals(isNotNull));
      },);
      test('error case with error response', () async{
        final room = RoomModel(
          name: testRoomName,
          description: testRoomDescription,
          categoryId: testCategoryId,
        );
        final testError = Exception('Firestore write error');
        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(testUserId))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.collection('rooms'))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc())
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.id).thenReturn(testRoomId);
        when(mockDocumentReference.set(any))
            .thenThrow(testError);
        final result = await dataSourceImpl.createRoom(room, testUserId);
        expect(result, isA<ErrorResponse<RoomModel>>());
        expect((result as ErrorResponse<RoomModel>).error.toString(), equals(contains(testError.toString())));
      },);
    },);
  },);
}