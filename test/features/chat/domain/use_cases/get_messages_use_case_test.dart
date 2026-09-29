import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/repositories/messages_repo_impl.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_messages_use_case_test.mocks.dart';

@GenerateMocks([MessagesRepoImpl])
void main() {
  late GetMessagesUseCase getMessagesUseCase;
  late MockMessagesRepoImpl mockMessagesRepoImpl;
  setUp(() {
    provideDummy<BaseResponse<Stream<List<MessageEntity>>>>(SuccessResponse<Stream<List<MessageEntity>>>(data: Stream.empty()));
    mockMessagesRepoImpl=MockMessagesRepoImpl();
    getMessagesUseCase=GetMessagesUseCase(mockMessagesRepoImpl);
  },);
  group('getMessagesUseCase test cases', () {
    String roomId='test_room_id';
    test('success case with stream of list of messages', () async{
      List<MessageEntity> dummyEntities=[
        MessageEntity(content: 'content1', senderId: 'senderId1', senderName: 'senderName1', dateTime: DateTime(2026,9,26), roomId: roomId),
        MessageEntity(content: 'content2', senderId: 'senderId2', senderName: 'senderName2', dateTime: DateTime(2026,9,27), roomId: roomId),
      ];
      when(mockMessagesRepoImpl.getMessages(roomId)).thenAnswer(
        (_) => SuccessResponse<Stream<List<MessageEntity>>>(data: Stream<List<MessageEntity>>.value(dummyEntities)),
      );
      final result=getMessagesUseCase.call(roomId);
      expect(result, isA<BaseResponse<Stream<List<MessageEntity>>>>());
      final stream=(result as SuccessResponse<Stream<List<MessageEntity>>>).data;
      final messages=await stream.first;
      expect(messages.length, equals(dummyEntities.length));
      expect(messages[0].content, equals(dummyEntities[0].content));
      expect(messages[0].senderId, equals(dummyEntities[0].senderId));
      expect(messages[0].senderName, equals(dummyEntities[0].senderName));
      expect(messages[0].dateTime, equals(dummyEntities[0].dateTime));
      expect(messages[0].roomId, equals(dummyEntities[0].roomId));
      expect(messages[1].content, equals(dummyEntities[1].content));
      expect(messages[1].senderId, equals(dummyEntities[1].senderId));
      expect(messages[1].senderName, equals(dummyEntities[1].senderName));
      expect(messages[1].dateTime, equals(dummyEntities[1].dateTime));
      expect(messages[1].roomId, equals(dummyEntities[1].roomId));
    },);
    test('success case with stream of empty list', () async{
      List<MessageEntity> dummyEntities=[];
      when(mockMessagesRepoImpl.getMessages(roomId)).thenAnswer(
        (_) => SuccessResponse<Stream<List<MessageEntity>>>(data: Stream<List<MessageEntity>>.value(dummyEntities)),
      );
      final result=getMessagesUseCase.call(roomId);
      expect(result, isA<BaseResponse<Stream<List<MessageEntity>>>>());
      final stream=(result as SuccessResponse<Stream<List<MessageEntity>>>).data;
      final messages=await stream.first;
      expect(messages.length, equals(dummyEntities.length));
    },);
    test('failure case with error response', () {
      final dummyException=Exception('Network Error');
      when(mockMessagesRepoImpl.getMessages(roomId)).thenAnswer(
        (_) => ErrorResponse<Stream<List<MessageEntity>>>(error: dummyException),
      );
      final result=getMessagesUseCase.call(roomId);
      expect(result, isA<BaseResponse<Stream<List<MessageEntity>>>>());
      expect((result as ErrorResponse<Stream<List<MessageEntity>>>).error.toString(), equals(dummyException.toString()));
    },);
  },);
}