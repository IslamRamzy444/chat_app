import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/ui_utils/dialog_utils.dart';
import 'package:chat_app/features/home/domain/entities/category_entity.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_states.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_view_model.dart';
import 'package:chat_app/features/home/presentation/views/screens/create_room_screen.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../auth/login/presentation/views/screens/test_dialog_utils.dart';
import 'create_room_screen_test.mocks.dart';

@GenerateMocks([RoomsViewModel])
void main() {
  late MockRoomsViewModel mockRoomsViewModel;
  late GetIt getIt;
  setUp(() {
    mockRoomsViewModel = MockRoomsViewModel();
    getIt = GetIt.instance;
    if (getIt.isRegistered<RoomsViewModel>()) {
      getIt.unregister<RoomsViewModel>();
    }
    getIt.registerSingleton<RoomsViewModel>(mockRoomsViewModel);
    when(mockRoomsViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockRoomsViewModel.state).thenReturn(RoomsStates());
    DialogUtils.setShowLoadingOverride(TestDialogUtils.showLoading);
    DialogUtils.setRemoveLoadingOverride(TestDialogUtils.removeLoading);
    TestDialogUtils.reset();
  });
  tearDown(() {
    if (getIt.isRegistered<RoomsViewModel>()) {
      getIt.unregister<RoomsViewModel>();
    }
    DialogUtils.resetToDefault();
  });
  Widget buildTestableWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.home) {
          return MaterialPageRoute(
            builder: (context) =>
                const Scaffold(body: Center(child: Text('Test Home Screen'))),
          );
        }
        return MaterialPageRoute(
          builder: (context) => const CreateRoomScreen(),
        );
      },
      home: const CreateRoomScreen(),
    );
  }

  testWidgets('create room screen initial state', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    final context = tester.element(find.byType(CreateRoomScreen).first);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(
      find.byType(DropdownButtonFormField<CategoryEntity>),
      findsOneWidget,
    );
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(7));
    expect(find.text(AppLocalizations.of(context)!.chat_app), findsOneWidget);
    expect(
      find.text(AppLocalizations.of(context)!.create_new_room),
      findsOneWidget,
    );
    expect(
      find.text(AppLocalizations.of(context)!.room_description),
      findsOneWidget,
    );
    expect(
      find.text(AppLocalizations.of(context)!.select_category),
      findsOneWidget,
    );
    expect(find.text(AppLocalizations.of(context)!.room_name), findsOneWidget);
    expect(
      find.text(AppLocalizations.of(context)!.create_room),
      findsOneWidget,
    );
  });
  testWidgets('should show validation error for empty room name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestableWidget());
    final context = tester.element(find.byType(CreateRoomScreen).first);
    final nameField = find.byType(TextFormField).first;
    final button = find.byType(ElevatedButton);
    await tester.enterText(nameField, '');
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(Text), findsNWidgets(10));
    expect(
      find.text(AppLocalizations.of(context)!.required_field),
      findsNWidgets(2),
    );
    expect(find.text(AppLocalizations.of(context)!.category_selection_required), findsOneWidget);
  });
   testWidgets('should show validation error for short room name (less than 3 characters)', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final context = tester.element(find.byType(CreateRoomScreen).first);
      final nameField = find.byType(TextFormField).first;
      final button = find.byType(ElevatedButton);
      await tester.enterText(nameField, 'AB');
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsNWidgets(10));
      expect(
      find.text(AppLocalizations.of(context)!.required_field),
      findsOneWidget,
    );
      expect(find.text(AppLocalizations.of(context)!.room_name_length), findsOneWidget);
    });
    testWidgets('should show validation error for room name starting with non-letter', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final context = tester.element(find.byType(CreateRoomScreen).first);
      final nameField = find.byType(TextFormField).first;
      final button = find.byType(ElevatedButton);
      await tester.enterText(nameField, '123Room');
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizations.of(context)!.room_name_start_with_letter), findsOneWidget);
    });
    testWidgets('should show validation error for empty description', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final context = tester.element(find.byType(CreateRoomScreen).first);
      final nameField = find.byType(TextFormField).first;
      final descriptionField = find.byType(TextFormField).at(1);
      final button = find.byType(ElevatedButton);
      await tester.enterText(nameField, 'Test Room');
      await tester.enterText(descriptionField, '');
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizations.of(context)!.required_field), findsOneWidget);
    });
    testWidgets('should show validation error for short description (less than 3 characters)', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final context = tester.element(find.byType(CreateRoomScreen).first);
      final nameField = find.byType(TextFormField).first;
      final descriptionField = find.byType(TextFormField).at(1);
      final button = find.byType(ElevatedButton);
      await tester.enterText(nameField, 'Test Room');
      await tester.enterText(descriptionField, 'AB');
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizations.of(context)!.description_min_length), findsOneWidget);
    });
    testWidgets('should show validation error for description starting with non-letter', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final context = tester.element(find.byType(CreateRoomScreen).first);
      final nameField = find.byType(TextFormField).first;
      final descriptionField = find.byType(TextFormField).at(1);
      final button = find.byType(ElevatedButton);
      await tester.enterText(nameField, 'Test Room');
      await tester.enterText(descriptionField, '123Description');
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizations.of(context)!.description_start_with_letter), findsOneWidget);
    });
    testWidgets('should show validation error when no category selected', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final context = tester.element(find.byType(CreateRoomScreen).first);
      final nameField = find.byType(TextFormField).first;
      final descriptionField = find.byType(TextFormField).at(1);
      final button = find.byType(ElevatedButton);
      await tester.enterText(nameField, 'Test Room');
      await tester.enterText(descriptionField, 'Test Description');
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizations.of(context)!.category_selection_required), findsOneWidget);
    });
    testWidgets('should call CreateRoomEvent when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      final nameField = find.byType(TextFormField).first;
      final descriptionField = find.byType(TextFormField).at(1);
      final dropdown = find.byType(DropdownButtonFormField<CategoryEntity>);
      final button = find.byType(ElevatedButton);
      await tester.enterText(nameField, 'Test Room');
      await tester.enterText(descriptionField, 'Test Description');
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      final firstCategory = find.text('Sports');
      await tester.tap(firstCategory);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
      verify(mockRoomsViewModel.doIntent(any)).called(1);
    });
}
