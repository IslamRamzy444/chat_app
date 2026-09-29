import 'dart:async';

import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_events.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_states.dart';
import 'package:chat_app/features/chat/presentation/view_model/chat_view_model.dart';
import 'package:chat_app/features/chat/presentation/views/screens/chat_screen.dart';
import 'package:chat_app/features/chat/presentation/views/widgets/message_bubble.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_screen_test.mocks.dart';

@GenerateMocks([ChatViewModel])
void main() {
  late MockChatViewModel mockChatViewModel;
  late GetIt getIt;
  late StreamController<ChatStates> streamController;
  late GlobalKey<NavigatorState> navKey;
  setUp(() {
    navKey = GlobalKey<NavigatorState>();
    streamController = StreamController<ChatStates>.broadcast();
    mockChatViewModel = MockChatViewModel();
    getIt = GetIt.instance;
    if (getIt.isRegistered<ChatViewModel>()) {
      getIt.unregister<ChatViewModel>();
    }
    getIt.registerSingleton<ChatViewModel>(mockChatViewModel);
    when(mockChatViewModel.stream).thenAnswer((_) => streamController.stream);
    when(mockChatViewModel.state).thenReturn(ChatStates());
    when(mockChatViewModel.doIntent(any)).thenReturn(null);
  });
  tearDown(() async {
    await streamController.close();
    if (getIt.isRegistered<ChatViewModel>()) {
      getIt.unregister<ChatViewModel>();
    }
  });
  Widget buildTestableWidget() {
    return MaterialApp(
      navigatorKey: navKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.chat) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => const ChatScreen(),
          );
        }
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Test Rooms Screen'))),
        );
      },
    );
  }

  Future<void> pumpChatScreen(
    WidgetTester tester, {
    String roomId = 'room_1',
    String roomName = 'Test Room',
    bool settle = true,
  }) async {
    await tester.pumpWidget(buildTestableWidget());
    navKey.currentState!.pushNamed(
      AppRoutes.chat,
      arguments: {'roomId': roomId, 'roomName': roomName},
    );

    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  testWidgets('renders room name in app bar and input + send button', (
    tester,
  ) async {
    await pumpChatScreen(tester, roomName: 'My Room');
    expect(find.text('My Room'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
  testWidgets('dispatches LoadCurrentUserEvent and LoadMessagesEvent on init', (
    tester,
  ) async {
    await pumpChatScreen(tester, roomId: 'room_42');
    verify(
      mockChatViewModel.doIntent(argThat(isA<LoadCurrentUserEvent>())),
    ).called(1);
    verify(
      mockChatViewModel.doIntent(
        argThat(
          isA<LoadMessagesEvent>().having((e) => e.roomId, 'roomId', 'room_42'),
        ),
      ),
    ).called(1);
  });
  testWidgets('shows CircularProgressIndicator while current user loads', (
    tester,
  ) async {
    when(mockChatViewModel.state).thenReturn(
      ChatStates(currentUserState: BaseState<UserEntity>(isLoading: true)),
    );

    await pumpChatScreen(tester, settle: false);

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
  testWidgets('shows error message when current user load fails', (
    tester,
  ) async {
    when(mockChatViewModel.state).thenReturn(
      ChatStates(
        currentUserState: BaseState<UserEntity>(
          isLoading: false,
          errorMessage: 'Network error',
        ),
      ),
    );

    await pumpChatScreen(tester);

    expect(find.text('Network error'), findsOneWidget);
  });
  testWidgets('shows empty-state text when there are no messages', (
    tester,
  ) async {
    when(mockChatViewModel.state).thenReturn(
      ChatStates(
        currentUserState: BaseState<UserEntity>(
          isLoading: false,
          data: UserEntity(id: 'u1', email: 'a@a.com', name: 'Alice'),
        ),
        messagesState: BaseState<List<MessageEntity>>(
          isLoading: false,
          data: const [],
        ),
      ),
    );

    await pumpChatScreen(tester);
    final context = tester.element(find.byType(ChatScreen));
    final l10n = AppLocalizations.of(context)!;
    expect(find.text(l10n.no_messages), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });
  testWidgets('renders one MessageBubble per message', (tester) async {
    final messages = [
      MessageEntity(
        content: 'hi',
        senderId: 'u1',
        senderName: 'Alice',
        dateTime: DateTime(2026, 9, 27),
        roomId: 'r1',
      ),
      MessageEntity(
        content: 'hello',
        senderId: 'u2',
        senderName: 'Bob',
        dateTime: DateTime(2026, 9, 28),
        roomId: 'r1',
      ),
    ];

    when(mockChatViewModel.state).thenReturn(
      ChatStates(
        currentUserState: BaseState<UserEntity>(
          isLoading: false,
          data: UserEntity(id: 'u1', email: 'a@a.com', name: 'Alice'),
        ),
        messagesState: BaseState<List<MessageEntity>>(
          isLoading: false,
          data: messages,
        ),
      ),
    );

    await pumpChatScreen(tester);

    expect(find.byType(MessageBubble), findsNWidgets(messages.length));
  });
  testWidgets('typing in the field dispatches UpdateMessageTextEvent', (
    tester,
  ) async {
    await pumpChatScreen(tester);

    await tester.enterText(find.byType(TextFormField), 'hello');
    await tester.pump();

    verify(
      mockChatViewModel.doIntent(
        argThat(
          isA<UpdateMessageTextEvent>().having((e) => e.text, 'text', 'hello'),
        ),
      ),
    ).called(1);
  });
  testWidgets('send button is disabled when message text is empty', (
    tester,
  ) async {
    when(mockChatViewModel.state).thenReturn(
      ChatStates(
        messageText: '',
        currentUserState: BaseState<UserEntity>(
          isLoading: false,
          data: UserEntity(id: 'u1', email: 'a@a.com', name: 'Alice'),
        ),
      ),
    );

    await pumpChatScreen(tester);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });
  testWidgets('tapping send dispatches SendMessageEvent and clears field', (
    tester,
  ) async {
    when(mockChatViewModel.state).thenReturn(
      ChatStates(
        messageText: 'hi there',
        currentUserState: BaseState<UserEntity>(
          isLoading: false,
          data: UserEntity(id: 'u1', email: 'a@a.com', name: 'Alice'),
        ),
      ),
    );

    await pumpChatScreen(tester, roomId: 'room_7');

    await tester.enterText(find.byType(TextFormField), 'hi there');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    verify(
      mockChatViewModel.doIntent(
        argThat(
          isA<SendMessageEvent>()
              .having((e) => e.content, 'content', 'hi there')
              .having((e) => e.roomId, 'roomId', 'room_7'),
        ),
      ),
    ).called(1);

    final field = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(field.controller?.text ?? '', isEmpty);
  });
  testWidgets('send button is disabled while a message is being sent', (
    tester,
  ) async {
    when(mockChatViewModel.state).thenReturn(
      ChatStates(
        messageText: 'hi',
        currentUserState: BaseState<UserEntity>(
          isLoading: false,
          data: UserEntity(id: 'u1', email: 'a@a.com', name: 'Alice'),
        ),
        sendMessageState: BaseState<MessageEntity>(isLoading: true),
      ),
    );

    await pumpChatScreen(tester, settle: false);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);

    expect(
      find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );
  });
}
