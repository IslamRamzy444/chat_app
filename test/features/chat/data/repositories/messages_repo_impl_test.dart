import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/data_sources/remote/messages_remote_data_source_impl.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/data/repositories/messages_repo_impl.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'messages_repo_impl_test.mocks.dart';

@GenerateMocks([MessagesRemoteDataSourceImpl])
void main() {
  late MessagesRepoImpl messagesRepoImpl;
  late MockMessagesRemoteDataSourceImpl mockMessagesRemoteDataSourceImpl;
  setUp(() {
    final message=MessageModel(content: 'test_content', senderId: 'test_senderId', senderName: 'test_senderName', dateTime: DateTime.now(), roomId: 'test_roomId');
    provideDummy<BaseResponse<Stream<List<MessageModel>>>>(SuccessResponse<Stream<List<MessageModel>>>(data: Stream.empty()));
    provideDummy<BaseResponse<MessageModel>>(SuccessResponse<MessageModel>(data: message));
    mockMessagesRemoteDataSourceImpl=MockMessagesRemoteDataSourceImpl();
    messagesRepoImpl=MessagesRepoImpl(mockMessagesRemoteDataSourceImpl);
  },);
  group('getMessages test cases', () {
    final roomId='test_room_id';
    test('success case with stream of message models', () async{
      List<MessageModel> dummyModels=[
        MessageModel(content: 'test_content1', senderId: 'test_senderId1', senderName: 'test_senderName1', dateTime: DateTime(2026,9,25), roomId: roomId),
        MessageModel(content: 'test_content2', senderId: 'test_senderId2', senderName: 'test_senderName2', dateTime: DateTime(2026,9,26), roomId: roomId),
      ];
      when(mockMessagesRemoteDataSourceImpl.getMessages(roomId)).thenAnswer((_) => SuccessResponse<Stream<List<MessageModel>>>(data: Stream<List<MessageModel>>.value(dummyModels)),);
      final result=messagesRepoImpl.getMessages(roomId);
      expect(result, isA<BaseResponse<Stream<List<MessageEntity>>>>());
      final stream =(result as SuccessResponse<Stream<List<MessageEntity>>>).data;
      final messages=await stream.first;
      expect(messages.length, equals(dummyModels.length));
      expect(messages[0].content, equals(dummyModels[0].content));
      expect(messages[0].senderId, equals(dummyModels[0].senderId));
      expect(messages[0].senderName, equals(dummyModels[0].senderName));
      expect(messages[0].dateTime, equals(dummyModels[0].dateTime));
      expect(messages[0].roomId, equals(dummyModels[0].roomId));
      expect(messages[1].content, equals(dummyModels[1].content));
      expect(messages[1].senderId, equals(dummyModels[1].senderId));
      expect(messages[1].senderName, equals(dummyModels[1].senderName));
      expect(messages[1].dateTime, equals(dummyModels[1].dateTime));
      expect(messages[1].roomId, equals(dummyModels[1].roomId));
    },);
    test('success case with stream of empty list of message models', () async{
      List<MessageModel> dummyModels=[];
      when(mockMessagesRemoteDataSourceImpl.getMessages(roomId)).thenAnswer((_) => SuccessResponse<Stream<List<MessageModel>>>(data: Stream<List<MessageModel>>.value(dummyModels)),);
      final result=messagesRepoImpl.getMessages(roomId);
      expect(result, isA<BaseResponse<Stream<List<MessageEntity>>>>());
      final stream =(result as SuccessResponse<Stream<List<MessageEntity>>>).data;
      final messages=await stream.first;
      expect(messages.length, equals(dummyModels.length));
    },);
    test('failure case with exception', () {
      final dummyException=Exception('Network Error');
      when(mockMessagesRemoteDataSourceImpl.getMessages(roomId)).thenAnswer(
        (_) => ErrorResponse<Stream<List<MessageModel>>>(error: dummyException),
      );
      final result=messagesRepoImpl.getMessages(roomId);
      expect(result, isA<BaseResponse<Stream<List<MessageEntity>>>>());
      expect((result as ErrorResponse<Stream<List<MessageEntity>>>).error.toString(), equals(dummyException.toString()));
    },);
  },);
  group('sendMessage test cases', () {
    final message=MessageModel(content: 'test_content', senderId: 'test_senderId', senderName: 'test_senderName', dateTime: DateTime.now(), roomId: 'test_roomId');
    test('success case with success response', () async{
      when(mockMessagesRemoteDataSourceImpl.sendMessage(any)).thenAnswer(
        (_) async=> SuccessResponse<MessageModel>(data: message),
      );
      final result=await messagesRepoImpl.sendMessage(senderId: message.senderId, senderName: message.senderName, roomId: message.roomId, content: message.content);
      expect(result, isA<BaseResponse<MessageEntity>>());
      expect((result as SuccessResponse<MessageEntity>).data.content, equals(message.content));
      expect(result.data.senderId, equals(message.senderId));
      expect(result.data.senderName, equals(message.senderName));
      expect(result.data.dateTime, equals(message.dateTime));
      expect(result.data.roomId, equals(message.roomId));
    },);
    test('failure case with exception', () async{
      final dummyException=Exception('Network Error');
      when(mockMessagesRemoteDataSourceImpl.sendMessage(any)).thenAnswer(
        (_) async=> ErrorResponse<MessageModel>(error: dummyException),
      );
      final result=await messagesRepoImpl.sendMessage(senderId: message.senderId, senderName: message.senderName, roomId: message.roomId, content: message.content);
      expect(result, isA<BaseResponse<MessageEntity>>());
      expect((result as ErrorResponse<MessageEntity>).error.toString(), equals(dummyException.toString()));
    },);
  },);
}