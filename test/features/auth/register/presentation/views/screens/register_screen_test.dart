import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/ui_utils/dialog_utils.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:chat_app/features/auth/register/presentation/view_model/register_states.dart';
import 'package:chat_app/features/auth/register/presentation/view_model/register_view_model.dart';
import 'package:chat_app/features/auth/register/presentation/views/screens/register_screen.dart';
import 'package:chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../login/presentation/views/screens/test_dialog_utils.dart';
import 'register_screen_test.mocks.dart';
@GenerateMocks([RegisterViewModel])
void main() {
  late MockRegisterViewModel mockRegisterViewModel;
  late GetIt getIt;
  setUp(() {
    mockRegisterViewModel=MockRegisterViewModel();
    getIt=GetIt.instance;
    if(getIt.isRegistered<RegisterViewModel>()){
      getIt.unregister<RegisterViewModel>();
    }
    getIt.registerSingleton<RegisterViewModel>(mockRegisterViewModel);
    when(mockRegisterViewModel.stream).thenAnswer((_) => const Stream.empty(),);
    when(mockRegisterViewModel.state).thenReturn(
      RegisterStates(
        registerState: BaseState<RegisterEntity>(isLoading: false),
        isPasswordHidden: true,
        isConfirmPasswordHidden: true
      )
    );
    DialogUtils.setShowLoadingOverride(TestDialogUtils.showLoading);
    DialogUtils.setRemoveLoadingOverride(TestDialogUtils.removeLoading);
    
    TestDialogUtils.reset();
  },);
  tearDown(() {
    if(getIt.isRegistered<RegisterViewModel>()){
      getIt.unregister<RegisterViewModel>();
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
          ),);
        }else if(settings.name==AppRoutes.login){
          return MaterialPageRoute(builder: (context) => const Scaffold(
            body: Text('Test Login Screen'),
          ),);
        }
        return MaterialPageRoute(builder: (context) => const RegisterScreen(),);
      },
      home: const RegisterScreen(),
    );
  }
  testWidgets('register screen initial state', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(RegisterScreen).first);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(9));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.create_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.confirm_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.already_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsOneWidget));
  });
  testWidgets('error validation state with empty fields', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(RegisterScreen).first);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(Text), findsNWidgets(13));
    expect(find.text(AppLocalizations.of(context)!.required_field), equals(findsNWidgets(4)));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.create_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.confirm_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.already_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsOneWidget));
  },);
  testWidgets('error validation state with invalid username', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(RegisterScreen).first);
    final userNameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);
    await tester.enterText(userNameField, 'jack_false');
    await tester.enterText(emailField, 'islam1@gmail.com');
    await tester.enterText(passwordField, 'Solm@2001');
    await tester.enterText(confirmPasswordField, 'Solm@2001');
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(Text), findsNWidgets(10));
    expect(find.text(AppLocalizations.of(context)!.valid_user_name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.create_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.confirm_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.already_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsOneWidget));
  },);
  testWidgets('error validation state with invalid email', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(RegisterScreen).first);
    final userNameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);
    await tester.enterText(userNameField, 'Islam-Ahmed');
    await tester.enterText(emailField, 'islam.com');
    await tester.enterText(passwordField, 'Solm@2001');
    await tester.enterText(confirmPasswordField, 'Solm@2001');
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(Text), findsNWidgets(10));
    expect(find.text(AppLocalizations.of(context)!.valid_email), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.create_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.confirm_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.already_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsOneWidget));
  },);
  testWidgets('error validation state with invalid password', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(RegisterScreen).first);
    final userNameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);
    await tester.enterText(userNameField, 'Islam-Ahmed');
    await tester.enterText(emailField, 'islam1@gmail.com');
    await tester.enterText(passwordField, 'inv');
    await tester.enterText(confirmPasswordField, 'Solm@2001');
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(Text), findsNWidgets(11));
    expect(find.text(AppLocalizations.of(context)!.valid_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.passwords_mismatch), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.create_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.confirm_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.already_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsOneWidget));
  },);
  testWidgets('error validation state with invalid repassword', (WidgetTester tester) async{
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(RegisterScreen).first);
    final userNameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);
    await tester.enterText(userNameField, 'Islam-Ahmed');
    await tester.enterText(emailField, 'islam1@gmail.com');
    await tester.enterText(passwordField, 'Solm@2001');
    await tester.enterText(confirmPasswordField, 'inv');
    await tester.pump(Duration(milliseconds: 300));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(Text), findsNWidgets(10));
    expect(find.text(AppLocalizations.of(context)!.passwords_mismatch), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.create_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.confirm_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.already_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsOneWidget));
  },);
  testWidgets('firebase auth error', (WidgetTester tester) async{
    final dummyException=Exception('Account already exists');
    when(mockRegisterViewModel.stream).thenAnswer((_) async*{
      yield RegisterStates(
        registerState: BaseState<RegisterEntity>(
          isLoading: true,
        ),
        isPasswordHidden: true,
        isConfirmPasswordHidden: true
      );
      await Future.delayed(Duration.zero);
      yield RegisterStates(
        registerState: BaseState<RegisterEntity>(
          isLoading: false,
          errorMessage: dummyException.toString()
        ),
        isPasswordHidden: true,
        isConfirmPasswordHidden: true
      );
    },);
    when(mockRegisterViewModel.state).thenReturn(
      RegisterStates(
        registerState: BaseState<RegisterEntity>(
          isLoading: false,
          errorMessage: dummyException.toString()
        ),
        isPasswordHidden: true,
        isConfirmPasswordHidden: true
      )
    );
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(RegisterScreen).first);
    final userNameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);
    await tester.enterText(userNameField, 'Islam-Ahmed');
    await tester.enterText(emailField, 'islam1@gmail.com');
    await tester.enterText(passwordField, 'Solm@2001');
    await tester.enterText(confirmPasswordField, 'Solm@2001');
    await tester.pumpAndSettle();
    expect(TestDialogUtils.loadingShown, isTrue);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(Text), findsNWidgets(12));
    expect(find.text(AppLocalizations.of(context)!.failure), equals(findsOneWidget));
    expect(find.text(dummyException.toString()), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.cancel), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.create_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.confirm_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.already_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsOneWidget));
  },);
  testWidgets('firebase auth success with valid credentials', (WidgetTester tester) async{
    final testEntity=RegisterEntity(
      userId: 'test_user_123',
      email: 'islam1@gmail.com',
      name: 'Test User',
    );
    when(mockRegisterViewModel.stream).thenAnswer((_) async*{
      yield RegisterStates(
        registerState: BaseState<RegisterEntity>(
          isLoading: true,
        ),
        isPasswordHidden: true,
        isConfirmPasswordHidden: true
      );
      await Future.delayed(Duration.zero);
      yield RegisterStates(
        registerState: BaseState<RegisterEntity>(
          isLoading: false,
          data: testEntity
        ),
        isPasswordHidden: true,
        isConfirmPasswordHidden: true
      );
    },);
    when(mockRegisterViewModel.state).thenReturn(
      RegisterStates(
        registerState: BaseState<RegisterEntity>(
          isLoading: false,
          data: testEntity
        ),
        isPasswordHidden: true,
        isConfirmPasswordHidden: true
      )
    );
    await tester.pumpWidget(buildTestableWidget());
    final context=tester.element(find.byType(RegisterScreen).first);
    final userNameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);
    await tester.enterText(userNameField, 'Islam-Ahmed');
    await tester.enterText(emailField, 'islam1@gmail.com');
    await tester.enterText(passwordField, 'Solm@2001');
    await tester.enterText(confirmPasswordField, 'Solm@2001');
    await tester.pumpAndSettle();
    expect(TestDialogUtils.loadingShown, isTrue);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(Text), findsNWidgets(12));
    expect(find.text(AppLocalizations.of(context)!.success), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.ok), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.register), equals(findsNWidgets(2)));
    expect(find.text(AppLocalizations.of(context)!.create_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.name), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.confirm_password), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.already_have_account), equals(findsOneWidget));
    expect(find.text(AppLocalizations.of(context)!.login), equals(findsOneWidget));
    await tester.tap(find.text(AppLocalizations.of(context)!.ok));
    await tester.pumpAndSettle();
    expect(find.text('Test Home Screen'), equals(findsOneWidget));
  },);
  testWidgets('navigating to loginscreen', (WidgetTester tester) async{
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Screen')),
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed('/register');
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
    final context=tester.element(find.byType(RegisterScreen).first);
    await tester.tap(find.text(AppLocalizations.of(context)!.login));
    await tester.pumpAndSettle();
    expect(find.text('Login Screen'), equals(findsOneWidget));
  },);
}