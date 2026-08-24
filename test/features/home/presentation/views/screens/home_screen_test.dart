import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_states.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_view_model.dart';
import 'package:chat_app/features/home/presentation/views/screens/home_screen.dart';
import 'package:chat_app/features/home/presentation/views/widgets/room_item.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_screen_test.mocks.dart';
@GenerateMocks([RoomsViewModel])
void main() {
  late MockRoomsViewModel mockRoomsViewModel;
  late GetIt getIt;
  setUp(() {
    mockRoomsViewModel=MockRoomsViewModel();
    getIt=GetIt.instance;
    if(getIt.isRegistered<RoomsViewModel>()){
      getIt.unregister<RoomsViewModel>();
    }
    getIt.registerSingleton<RoomsViewModel>(mockRoomsViewModel);
    when(mockRoomsViewModel.stream).thenAnswer((_) => const Stream.empty(),);
    when(mockRoomsViewModel.state).thenReturn(RoomsStates());
  },);
  tearDown(() {
    if(getIt.isRegistered<RoomsViewModel>()){
      getIt.unregister<RoomsViewModel>();
    }
  },);
  Widget buildTestableWidget(){
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: (settings) {
        if(settings.name==AppRoutes.createRoom){
          return MaterialPageRoute(builder: (context) => const Scaffold(
            body: Center(child: Text('Test create room screen'),),
          ),);
        }
        return MaterialPageRoute(builder: (context) => const HomeScreen(),);
      },
      home: const HomeScreen(),
    );
  }
  testWidgets('home screen loading state', (WidgetTester tester) async {
    when(mockRoomsViewModel.stream).thenAnswer((_) => Stream.value(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: true
    ))),);
    when(mockRoomsViewModel.state).thenReturn(RoomsStates(roomsState: BaseState<List<RoomEntity>>(isLoading: true)));
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(HomeScreen).first);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.chat_app), findsOneWidget);
  });
  testWidgets('home screen error state', (WidgetTester tester) async{
    final dummyException=Exception('Firestore error');
    when(mockRoomsViewModel.stream).thenAnswer((_) => Stream.value(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: false,
      errorMessage: dummyException.toString()
    ))),);
    when(mockRoomsViewModel.state).thenReturn(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: false,
      errorMessage: dummyException.toString()
    )));
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(HomeScreen).first);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.chat_app), findsOneWidget);
    expect(find.text(dummyException.toString()), findsOneWidget);
  },);
  testWidgets('home screen success state with no rooms', (WidgetTester tester) async{
    when(mockRoomsViewModel.stream).thenAnswer((_) => Stream.value(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: false,
      data: []
    ))),);
    when(mockRoomsViewModel.state).thenReturn(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: false,
      data: []
    )));
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(HomeScreen).first);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.chat_app), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.no_rooms), findsOneWidget);
  },);
  testWidgets('home screen success states with rooms', (WidgetTester tester) async{
    final dummyRooms=[
      RoomEntity(name: 'Sports Community', description: 'sports_desc', categoryId: 'sports'),
      RoomEntity(name: 'Music Community', description: 'music_desc', categoryId: 'music'),
      RoomEntity(name: 'Programmers Community', description: 'programmers_desc', categoryId: 'technology'),
      RoomEntity(name: 'Food Lovers Community', description: 'food_desc', categoryId: 'food')
    ];
    when(mockRoomsViewModel.stream).thenAnswer((_) => Stream.value(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: false,
      data: dummyRooms
    ))),);
    when(mockRoomsViewModel.state).thenReturn(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: false,
      data: dummyRooms
    )));
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(HomeScreen).first);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Text), findsNWidgets(9));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.chat_app), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(RoomItem), findsNWidgets(4));
    expect(find.byType(Icon), findsNWidgets(5));
    expect(find.text(dummyRooms[0].name), findsOneWidget);
    expect(find.text(dummyRooms[1].name), findsOneWidget);
    expect(find.text(dummyRooms[2].name), findsOneWidget);
    expect(find.text(dummyRooms[3].name), findsOneWidget);
    expect(find.text(dummyRooms[0].description), findsOneWidget);
    expect(find.text(dummyRooms[1].description), findsOneWidget);
    expect(find.text(dummyRooms[2].description), findsOneWidget);
    expect(find.text(dummyRooms[3].description), findsOneWidget);
    expect(find.byIcon(Icons.sports_soccer_sharp), findsOneWidget);
    expect(find.byIcon(Icons.music_note), findsOneWidget);
    expect(find.byIcon(Icons.computer), findsOneWidget);
    expect(find.byIcon(Icons.restaurant), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  },);
  testWidgets('home screen navigating to create room screen', (WidgetTester tester) async{
    when(mockRoomsViewModel.stream).thenAnswer((_) => Stream.value(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: false,
      data: []
    ))),);
    when(mockRoomsViewModel.state).thenReturn(RoomsStates(roomsState: BaseState<List<RoomEntity>>(
      isLoading: false,
      data: []
    )));
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(HomeScreen).first);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.chat_app), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.no_rooms), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Test create room screen'), findsOneWidget);
  },);
}