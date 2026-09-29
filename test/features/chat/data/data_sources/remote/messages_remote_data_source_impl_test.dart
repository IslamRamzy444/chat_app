import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/data_sources/remote/messages_remote_data_source_impl.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'messages_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  Query,
  QuerySnapshot,
  DocumentSnapshot,
  QueryDocumentSnapshot,
])
void main() {
  late MessagesRemoteDataSourceImpl dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockRoomsCollection;
  late MockDocumentReference<Map<String, dynamic>> mockRoomDoc;
  late MockCollectionReference<Map<String, dynamic>> mockMessagesCollection;

  const tRoomId = 'room_123';
  final tDateTime = DateTime(2024, 1, 15, 10, 30);

  final tMessage = MessageModel(
    id: 'msg_1',
    roomId: tRoomId,
    senderId: 'user_1',
    senderName: 'Alice',
    content: 'Hello World',
    dateTime: tDateTime,
  );

  final tMessageJson = {
    'id': 'msg_1',
    'roomId': tRoomId,
    'senderId': 'user_1',
    'senderName': 'Alice',
    'content': 'Hello World',
    'dateTime': Timestamp.fromDate(tDateTime),
  };

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockRoomsCollection = MockCollectionReference<Map<String, dynamic>>();
    mockRoomDoc = MockDocumentReference<Map<String, dynamic>>();
    mockMessagesCollection = MockCollectionReference<Map<String, dynamic>>();

    dataSource = MessagesRemoteDataSourceImpl(mockFirestore);

    when(mockFirestore.collection('rooms')).thenReturn(mockRoomsCollection);
    when(mockRoomsCollection.doc(tRoomId)).thenReturn(mockRoomDoc);
    when(mockRoomDoc.collection('messages')).thenReturn(mockMessagesCollection);
  });

  group('getMessages', () {
    test('should return SuccessResponse with a stream of messages '
        'when firestore call is successful', () async {
      // Arrange
      final mockQuery = MockQuery<Map<String, dynamic>>();
      final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      final mockDocSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();

      when(
        mockMessagesCollection.orderBy('dateTime', descending: true),
      ).thenReturn(mockQuery);

      when(mockDocSnapshot.id).thenReturn('msg_1');
      when(mockDocSnapshot.data()).thenReturn(Map.from(tMessageJson));

      when(mockQuerySnapshot.docs).thenReturn([mockDocSnapshot]);

      when(
        mockQuery.snapshots(),
      ).thenAnswer((_) => Stream.value(mockQuerySnapshot));

      final result = dataSource.getMessages(tRoomId);

      expect(result, isA<SuccessResponse<Stream<List<MessageModel>>>>());

      final stream =
          (result as SuccessResponse<Stream<List<MessageModel>>>).data;
      final messages = await stream.first;

      expect(messages.length, 1);
      expect(messages.first.id, 'msg_1');
      expect(messages.first.content, 'Hello World');
      expect(messages.first.roomId, tRoomId);
      expect(messages.first.senderId, 'user_1');

      verify(mockFirestore.collection('rooms')).called(1);
      verify(mockRoomsCollection.doc(tRoomId)).called(1);
      verify(mockRoomDoc.collection('messages')).called(1);
      verify(
        mockMessagesCollection.orderBy('dateTime', descending: true),
      ).called(1);
      verify(mockQuery.snapshots()).called(1);
    });

    test(
      'should propagate stream error when firestore stream emits error',
      () async {
        // Arrange
        final mockQuery = MockQuery<Map<String, dynamic>>();
        final expectedException = Exception('Stream failed');

        when(
          mockMessagesCollection.orderBy('dateTime', descending: true),
        ).thenReturn(mockQuery);
        when(
          mockQuery.snapshots(),
        ).thenAnswer((_) => Stream.error(expectedException));

        final result = dataSource.getMessages(tRoomId);

        expect(result, isA<SuccessResponse<Stream<List<MessageModel>>>>());

        final stream =
            (result as SuccessResponse<Stream<List<MessageModel>>>).data;
        expect(stream.first, throwsA(expectedException));
      },
    );

    test(
      'should return ErrorResponse when a synchronous exception occurs',
      () async {
        when(
          mockFirestore.collection('rooms'),
        ).thenThrow(Exception('Firestore unavailable'));

        final result = dataSource.getMessages(tRoomId);

        expect(result, isA<ErrorResponse<Stream<List<MessageModel>>>>());
        final error = (result as ErrorResponse).error;
        expect(error.toString(), contains('Firestore unavailable'));
      },
    );
  });

  group('sendMessage', () {
    test(
      'should save message and return SuccessResponse with created message',
      () async {
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockMessagesCollection.doc()).thenReturn(mockDocRef);
        when(mockDocRef.id).thenReturn('new_msg_id');

        when(mockDocRef.set(any)).thenAnswer((_) async => Future.value());

        final savedData = Map<String, dynamic>.from(tMessageJson);
        savedData['id'] = 'new_msg_id';
        savedData['dateTime'] = Timestamp.fromDate(tDateTime);

        when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.id).thenReturn('new_msg_id');
        when(mockSnapshot.data()).thenReturn(savedData);

        final result = await dataSource.sendMessage(tMessage);

        expect(result, isA<SuccessResponse<MessageModel>>());
        final created = (result as SuccessResponse<MessageModel>).data;
        expect(created.id, 'new_msg_id');
        expect(created.content, 'Hello World');
        expect(created.roomId, tRoomId);

        verify(mockFirestore.collection('rooms')).called(1);
        verify(mockRoomsCollection.doc(tRoomId)).called(1);
        verify(mockRoomDoc.collection('messages')).called(1);
        verify(mockMessagesCollection.doc()).called(1);
        verify(mockDocRef.set(any)).called(1);
        verify(mockDocRef.get()).called(1);
      },
    );

    test(
      'should include server timestamp and doc id when setting data',
      () async {
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

        when(mockMessagesCollection.doc()).thenReturn(mockDocRef);
        when(mockDocRef.id).thenReturn('new_msg_id');
        when(mockDocRef.set(any)).thenAnswer((_) async {});

        final savedData = Map<String, dynamic>.from(tMessageJson);
        savedData['id'] = 'new_msg_id';
        savedData['dateTime'] = Timestamp.fromDate(tDateTime);

        when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.id).thenReturn('new_msg_id');
        when(mockSnapshot.data()).thenReturn(savedData);

        await dataSource.sendMessage(tMessage);

        final captured =
            verify(mockDocRef.set(captureAny)).captured.single
                as Map<String, dynamic>;

        expect(captured['id'], 'new_msg_id');
        expect(captured['dateTime'], isA<FieldValue>());
        expect(captured['content'], 'Hello World');
        expect(captured['roomId'], tRoomId);
      },
    );

    test('should return ErrorResponse when set() throws', () async {
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();

      when(mockMessagesCollection.doc()).thenReturn(mockDocRef);
      when(mockDocRef.id).thenReturn('new_msg_id');
      when(mockDocRef.set(any)).thenThrow(Exception('Write failed'));

      final result = await dataSource.sendMessage(tMessage);

      expect(result, isA<ErrorResponse<MessageModel>>());
      final error = (result as ErrorResponse).error;
      expect(error.toString(), contains('Write failed'));

      verify(mockDocRef.set(any)).called(1);
      verifyNever(mockDocRef.get());
    });

    test(
      'should return ErrorResponse when get() throws after successful set',
      () async {
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();

        when(mockMessagesCollection.doc()).thenReturn(mockDocRef);
        when(mockDocRef.id).thenReturn('new_msg_id');
        when(mockDocRef.set(any)).thenAnswer((_) async {});
        when(mockDocRef.get()).thenThrow(Exception('Read failed'));

        final result = await dataSource.sendMessage(tMessage);

        expect(result, isA<ErrorResponse<MessageModel>>());
        expect(
          (result as ErrorResponse).error.toString(),
          contains('Read failed'),
        );
        verify(mockDocRef.set(any)).called(1);
        verify(mockDocRef.get()).called(1);
      },
    );
  });
}
