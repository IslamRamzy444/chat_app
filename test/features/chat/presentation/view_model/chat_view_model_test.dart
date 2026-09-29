import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_current_user_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_events.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_states.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'chat_view_model_test.mocks.dart';

@GenerateMocks([GetCurrentUserUseCase, GetMessagesUseCase, SendMessageUseCase])
void main() {
  late ChatViewModel viewModel;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockGetMessagesUseCase mockGetMessagesUseCase;
  late MockSendMessageUseCase mockSendMessageUseCase;
  final message = MessageEntity(
    content: 'content1',
    senderId: 'senderId1',
    senderName: 'senderName1',
    dateTime: DateTime.now(),
    roomId: 'roomId1',
  );
  final dummyCurrentUser = UserEntity(
    id: 'id1',
    email: 'email1',
    name: 'name1',
  );
  setUp(() {
    provideDummy<BaseResponse<UserEntity>>(
      SuccessResponse<UserEntity>(data: dummyCurrentUser),
    );
    provideDummy<BaseResponse<MessageEntity>>(
      SuccessResponse<MessageEntity>(data: message),
    );
    provideDummy<BaseResponse<Stream<List<MessageEntity>>>>(
      SuccessResponse<Stream<List<MessageEntity>>>(data: Stream.empty()),
    );
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockGetMessagesUseCase = MockGetMessagesUseCase();
    mockSendMessageUseCase = MockSendMessageUseCase();
    viewModel = ChatViewModel(
      mockGetCurrentUserUseCase,
      mockGetMessagesUseCase,
      mockSendMessageUseCase,
    );
  });
  tearDown(() {
    viewModel.close();
  });
  group('ChatViewModel test cases', () {
    group('LoadCurrentUserEvent', () {
      test('success case with success response', () {
        when(
          mockGetCurrentUserUseCase.call(),
        ).thenAnswer((_) async => SuccessResponse(data: dummyCurrentUser));
        expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<ChatStates>(
              (p0) => p0.currentUserState?.isLoading == true,
            ),
            predicate<ChatStates>(
              (p0) =>
                  p0.currentUserState?.isLoading == false &&
                  p0.currentUserState?.data == dummyCurrentUser,
            ),
          ]),
        );
        viewModel.doIntent(LoadCurrentUserEvent());
      });
      test('failure case with error response', () {
        final dummyException = Exception('Network Error');
        when(mockGetCurrentUserUseCase.call()).thenAnswer(
          (_) async => ErrorResponse<UserEntity>(error: dummyException),
        );
        expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<ChatStates>(
              (p0) => p0.currentUserState?.isLoading == true,
            ),
            predicate<ChatStates>(
              (p0) =>
                  p0.currentUserState?.isLoading == false &&
                  p0.currentUserState?.errorMessage ==
                      dummyException.toString(),
            ),
          ]),
        );
        viewModel.doIntent(LoadCurrentUserEvent());
      });
    });
    group('LoadMessagesEvent', () {
      String roomId = 'test_room_id';
      test('success case with success response', () async {
        final dummyEntities = [
          MessageEntity(
            content: 'content1',
            senderId: 'senderId1',
            senderName: 'senderName1',
            dateTime: DateTime(2026, 9, 27),
            roomId: roomId,
          ),
          MessageEntity(
            content: 'content2',
            senderId: 'senderId2',
            senderName: 'senderName2',
            dateTime: DateTime(2026, 9, 28),
            roomId: roomId,
          ),
        ];
        when(mockGetMessagesUseCase.call(roomId)).thenAnswer(
          (_) => SuccessResponse<Stream<List<MessageEntity>>>(
            data: Stream<List<MessageEntity>>.fromIterable([dummyEntities]),
          ),
        );
        final emitted = expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<ChatStates>(
              (s) =>
                  s.messagesState?.isLoading == false &&
                  s.messagesState?.data == null,
            ), // first: loading done, no data
            predicate<ChatStates>(
              (s) =>
                  s.messagesState?.isLoading == false &&
                  s.messagesState?.data?.length == dummyEntities.length,
            ), // second: data
          ]),
        );
        viewModel.doIntent(LoadMessagesEvent(roomId));
        await emitted;
      });
      test('failure case with error response', () {
        final dummyException = Exception('Network Error');
        when(mockGetMessagesUseCase.call(roomId)).thenAnswer(
          (_) =>
              ErrorResponse<Stream<List<MessageEntity>>>(error: dummyException),
        );
        expectLater(
          viewModel.stream,
          emits(
            predicate<ChatStates>(
              (p0) =>
                  p0.messagesState?.isLoading == false &&
                  p0.messagesState?.errorMessage == dummyException.toString(),
            ),
          ),
        );
        viewModel.doIntent(LoadMessagesEvent(roomId));
      });
    });
    group('SendMessageEvent', () {
      test('success case with success response', () async {
        when(mockGetCurrentUserUseCase.call()).thenAnswer(
          (_) async => SuccessResponse<UserEntity>(data: dummyCurrentUser),
        );

        when(
          mockSendMessageUseCase.call(
            senderId: dummyCurrentUser.id,
            senderName: dummyCurrentUser.name,
            roomId: message.roomId,
            content: message.content,
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<MessageEntity>(data: message),
        );
        viewModel.doIntent(LoadCurrentUserEvent());
        await Future<void>.delayed(Duration.zero);
        final emitted = expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<ChatStates>((s) => s.sendMessageState?.isLoading == true),
            predicate<ChatStates>(
              (s) =>
                  s.sendMessageState?.isLoading == false &&
                  s.sendMessageState?.data == message,
            ),
          ]),
        );
        viewModel.doIntent(
          SendMessageEvent(content: message.content, roomId: message.roomId),
        );

        await emitted;
      });
      test('failure case with error response', () async {
        final dummyException = Exception('Network Error');
        when(mockGetCurrentUserUseCase.call()).thenAnswer(
          (_) async => SuccessResponse<UserEntity>(data: dummyCurrentUser),
        );

        when(
          mockSendMessageUseCase.call(
            senderId: dummyCurrentUser.id,
            senderName: dummyCurrentUser.name,
            roomId: message.roomId,
            content: message.content,
          ),
        ).thenAnswer(
          (_) async => ErrorResponse<MessageEntity>(error: dummyException),
        );
        viewModel.doIntent(LoadCurrentUserEvent());
        await Future<void>.delayed(Duration.zero);
        final emitted = expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<ChatStates>((s) => s.sendMessageState?.isLoading == true),
            predicate<ChatStates>(
              (s) =>
                  s.sendMessageState?.isLoading == false &&
                  s.sendMessageState?.errorMessage == dummyException.toString(),
            ),
          ]),
        );
        viewModel.doIntent(
          SendMessageEvent(content: message.content, roomId: message.roomId),
        );
        await emitted;
      });
    });
    group('UpdateMessageTextEvent', () {
      test('success case updates messageText', () async {
        const newText = 'hello world';

        final emitted = expectLater(
          viewModel.stream,
          emits(predicate<ChatStates>((s) => s.messageText == newText)),
        );

        viewModel.doIntent(UpdateMessageTextEvent(newText));
        await emitted;
      });
      test('clears messageText when empty string is passed', () async {
        // seed some text first
        viewModel.doIntent(UpdateMessageTextEvent('something'));

        final emitted = expectLater(
          viewModel.stream,
          emits(predicate<ChatStates>((s) => s.messageText == '')),
        );

        viewModel.doIntent(UpdateMessageTextEvent(''));
        await emitted;
      });
    });
  });
}
