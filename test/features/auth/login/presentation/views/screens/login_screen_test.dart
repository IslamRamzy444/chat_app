import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/ui_utils/dialog_utils.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:chat_app/features/auth/login/presentation/view_model/login_states.dart';
import 'package:chat_app/features/auth/login/presentation/view_model/login_view_model.dart';
import 'package:chat_app/features/auth/login/presentation/views/screens/login_screen.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_screen_test.mocks.dart';
import 'test_dialog_utils.dart';
@GenerateMocks([LoginViewModel])
void main() {
  late MockLoginViewModel mockLoginViewModel;
  late GetIt getIt;
  setUp(() {
    mockLoginViewModel=MockLoginViewModel();
    getIt=GetIt.instance;
    if(getIt.isRegistered<LoginViewModel>()){
      getIt.unregister<LoginViewModel>();
    }
    getIt.registerSingleton<LoginViewModel>(mockLoginViewModel);
    when(mockLoginViewModel.stream).thenAnswer((_) => const Stream.empty(),);
    when(mockLoginViewModel.state).thenReturn(LoginStates(
      loginUserState: BaseState<LoginEntity>(isLoading: false),
      isPasswordHidden: true
    ));
    DialogUtils.setShowLoadingOverride(TestDialogUtils.showLoading);
    DialogUtils.setRemoveLoadingOverride(TestDialogUtils.removeLoading);
    
    TestDialogUtils.reset();
  },);
  tearDown(() {
    if(getIt.isRegistered<LoginViewModel>()){
      getIt.unregister<LoginViewModel>();
    }
    DialogUtils.resetToDefault();
  },);
  Widget buildTestableWidget(){
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: (settings) {
        if(settings.name==AppRoutes.home){
          return MaterialPageRoute(builder: (context) => const Scaffold(
            body: Text('Test Home Screen'),
          ));
        }else if(settings.name==AppRoutes.register){
          return MaterialPageRoute(builder: (context) => const Scaffold(
            body: Text('Test Register Screen'),
          ),);
        }
        return MaterialPageRoute(builder: (context) => const LoginScreen(),);
      },
      home: const LoginScreen(),
    );
  }
  testWidgets('login screen initial state', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(7));
    final context = tester.element(find.byType(LoginScreen).first);
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.email), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.do_not_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsOneWidget));
  });
  testWidgets('error validation state with empty fields', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context = tester.element(find.byType(LoginScreen).first);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Text), findsNWidgets(9));
    expect(find.text(AppLocalizations.of(context)!.required_field), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.email), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.do_not_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsOneWidget));
  },);
  testWidgets('error validation case of invalid email', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context = tester.element(find.byType(LoginScreen).first);
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).at(1);
    await tester.enterText(emailField, 'inv-email');
    await tester.enterText(passwordField, 'Solm@2001');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Text), findsNWidgets(8));
    expect(find.text(AppLocalizations.of(context)!.required_field), equals(findsNothing));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.email), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.valid_email), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.do_not_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsOneWidget));
  },);
  testWidgets('Error Validation state of invalid password', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context = tester.element(find.byType(LoginScreen).first);
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).at(1);
    await tester.enterText(emailField, 'islam1@gmail.com');
    await tester.enterText(passwordField, 'inv');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Text), findsNWidgets(8));
    expect(find.text(AppLocalizations.of(context)!.required_field), equals(findsNothing));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.email), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.valid_email), equals(findsNothing));
    expect(find.text(AppLocalizations.of(context)!.valid_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.do_not_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsOneWidget));
  },);
  testWidgets('firebase auth error with invalid credentials', (WidgetTester tester) async {
    final dummyException = Exception('Invalid email or password');
    when(mockLoginViewModel.stream).thenAnswer((_) async* {
      yield LoginStates(
        loginUserState: BaseState<LoginEntity>(isLoading: true),
        isPasswordHidden: true,
      );
      await Future.delayed(Duration.zero);
      yield LoginStates(
        loginUserState: BaseState<LoginEntity>(
          isLoading: false,
          errorMessage: dummyException.toString(),
        ),
        isPasswordHidden: true,
      );
    });
    when(mockLoginViewModel.state).thenReturn(
      LoginStates(
        loginUserState: BaseState<LoginEntity>(
          isLoading: false,
          errorMessage: dummyException.toString(),
        ),
        isPasswordHidden: true,
      ),
    );

    await tester.pumpWidget(buildTestableWidget());
    final context = tester.element(find.byType(LoginScreen).first);
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).at(1);
    await tester.enterText(emailField, 'wrong@example.com');
    await tester.enterText(passwordField, 'WrongPassword123!');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(TestDialogUtils.loadingShown, isTrue);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text(dummyException.toString()), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(10));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.email), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.failure), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.cancel), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.do_not_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsOneWidget));
  });
  testWidgets('firebase auth success with valid credentials', (WidgetTester tester) async {
    final testEntity = LoginEntity(
      userId: 'test_user_123',
      email: 'islam1@gmail.com',
      name: 'Test User',
    );
    when(mockLoginViewModel.stream).thenAnswer((_) async* {
      yield LoginStates(
        loginUserState: BaseState<LoginEntity>(isLoading: true),
        isPasswordHidden: true,
      );
      await Future.delayed(Duration.zero);
      yield LoginStates(
        loginUserState: BaseState<LoginEntity>(
          isLoading: false,
          data: testEntity,
        ),
        isPasswordHidden: true,
      );
    });
    when(mockLoginViewModel.state).thenReturn(
      LoginStates(
        loginUserState: BaseState<LoginEntity>(
          isLoading: false,
          data: testEntity,
        ),
        isPasswordHidden: true,
      ),
    );
    await tester.pumpWidget(buildTestableWidget());
    final context = tester.element(find.byType(LoginScreen).first);
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).at(1);
    await tester.enterText(emailField, 'islam1@gmail.com');
    await tester.enterText(passwordField, 'CorrectPassword123!');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(TestDialogUtils.loadingShown, isTrue);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(10));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.email), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.success), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.ok), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.do_not_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsOneWidget));
    await tester.tap(find.text(AppLocalizations.of(context)!.ok));
    await tester.pumpAndSettle();
    expect(find.text('Test Home Screen'), equals(findsOneWidget));
  });
  testWidgets('navigating to test register screen', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context = tester.element(find.byType(LoginScreen).first);
    await tester.tap(find.text(AppLocalizations.of(context)!.register));
    await tester.pumpAndSettle();
    expect(find.text('Test Register Screen'), equals(findsOneWidget));
  },);
}