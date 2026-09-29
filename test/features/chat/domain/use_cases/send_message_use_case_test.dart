import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/repositories/messages_repo_impl.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'send_message_use_case_test.mocks.dart';

@GenerateMocks([MessagesRepoImpl])
void main() {
  late SendMessageUseCase sendMessageUseCase;
  late MockMessagesRepoImpl mockMessagesRepoImpl;
  final message=MessageEntity(content: 'content1', senderId: 'senderId1', senderName: 'senderName1', dateTime: DateTime.now(), roomId: 'roomId1');
  setUp(() {
    provideDummy<BaseResponse<MessageEntity>>(SuccessResponse<MessageEntity>(data: message));
    mockMessagesRepoImpl=MockMessagesRepoImpl();
    sendMessageUseCase=SendMessageUseCase(mockMessagesRepoImpl);
  },);
  group('sendMessageUseCase test cases', () {
    test('success case with success response', () async{
      when(mockMessagesRepoImpl.sendMessage(senderId: message.senderId, senderName: message.senderName, roomId: message.roomId, content: message.content)).thenAnswer(
        (_) async=> SuccessResponse<MessageEntity>(data: message),
      );
      final result=await sendMessageUseCase.call(senderId: message.senderId, senderName: message.senderName, roomId: message.roomId, content: message.content);
      expect(result, isA<BaseResponse<MessageEntity>>());
      expect((result as SuccessResponse<MessageEntity>).data.senderId, equals(message.senderId));
      expect(result.data.senderName, equals(message.senderName));
      expect(result.data.dateTime, equals(message.dateTime));
      expect(result.data.roomId, equals(message.roomId));
      expect(result.data.content, equals(message.content));
    },);
    test('failure case with error response', () async{
      final dummyException=Exception('Network Error');
      when(mockMessagesRepoImpl.sendMessage(senderId: message.senderId, senderName: message.senderName, roomId: message.roomId, content: message.content)).thenAnswer(
        (_) async=> ErrorResponse<MessageEntity>(error: dummyException),
      );
      final result=await sendMessageUseCase.call(senderId: message.senderId, senderName: message.senderName, roomId: message.roomId, content: message.content);
      expect(result, isA<BaseResponse<MessageEntity>>());
      expect((result as ErrorResponse<MessageEntity>).error.toString(), equals(dummyException.toString()));
    },);
  },);
}