import 'package:chat_app/core/resources/app_colors.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/presentation/views/widgets/room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoomItem widget tests', () {
    final testRoom = RoomEntity(
      id: 'room123',
      name: 'Test Room',
      description: 'This is a test room description',
      categoryId: 'sports',
    );

    final testRoomWithUnknownCategory = RoomEntity(
      id: 'room456',
      name: 'Unknown Category Room',
      description: 'Room with unknown category',
      categoryId: 'unknown_category',
    );

    Widget buildTestableWidget(RoomEntity room) {
      return MaterialApp(
        home: Scaffold(
          body: RoomItem(room: room),
        ),
      );
    }

    testWidgets('should render room name and description correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(testRoom));

      expect(find.text('Test Room'), findsOneWidget);
      expect(find.text('This is a test room description'), findsOneWidget);
    });

    testWidgets('should render category icon for valid category', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(testRoom));

      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsOneWidget);

      final Icon icon = tester.widget(iconFinder);
      expect(icon.icon, Icons.sports_soccer_sharp);
      expect(icon.size, 72);
    });

    testWidgets('should render fallback icon for unknown category', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(testRoomWithUnknownCategory));

      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsOneWidget);

      final Icon icon = tester.widget(iconFinder);
      expect(icon.icon, Icons.help_outline);
      expect(icon.size, 72);
    });

    testWidgets('should render container with correct decoration', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(testRoom));

      final containerFinder = find.byType(Container).first;
      expect(containerFinder, findsOneWidget);

      final Container container = tester.widget(containerFinder);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, AppColors.whiteColor);
      expect(decoration.borderRadius, isA<BorderRadius>());
      expect(decoration.boxShadow, isNotNull);
    });
  });
}