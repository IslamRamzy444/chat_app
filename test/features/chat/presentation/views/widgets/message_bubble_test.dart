import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/presentation/views/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tDateTime = DateTime(2026, 9, 29, 14, 30);

  final tMessage = MessageEntity(
    content: 'Hello world',
    senderId: 'u1',
    senderName: 'Alice',
    dateTime: tDateTime,
    roomId: 'r1',
  );

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('MessageBubble', () {
    testWidgets('renders the message content', (tester) async {
      await tester.pumpWidget(
        wrap(MessageBubble(message: tMessage, isSentByMe: true)),
      );

      expect(find.text('Hello world'), findsOneWidget);
    });

    testWidgets('renders the formatted time (HH:mm)', (tester) async {
      await tester.pumpWidget(
        wrap(MessageBubble(message: tMessage, isSentByMe: true)),
      );

      expect(find.text('14:30'), findsOneWidget);
    });

    testWidgets('shows sender name when message is NOT sent by me',
        (tester) async {
      await tester.pumpWidget(
        wrap(MessageBubble(message: tMessage, isSentByMe: false)),
      );

      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('hides sender name when message IS sent by me',
        (tester) async {
      await tester.pumpWidget(
        wrap(MessageBubble(message: tMessage, isSentByMe: true)),
      );

      expect(find.text('Alice'), findsNothing);
    });

    testWidgets('uses primary color background when sent by me',
        (tester) async {
      await tester.pumpWidget(
        wrap(MessageBubble(message: tMessage, isSentByMe: true)),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Hello world'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, AppColors.primaryColor);
    });

    testWidgets('uses white background when NOT sent by me', (tester) async {
      await tester.pumpWidget(
        wrap(MessageBubble(message: tMessage, isSentByMe: false)),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Hello world'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, AppColors.whiteColor);
    });
  });
}