import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/auth/login/presentation/views/screens/login_screen.dart';
import 'package:chat_app/features/auth/register/presentation/views/screens/register_screen.dart';
import 'package:chat_app/features/home/presentation/views/screens/home_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> getRoutes(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen(),);
      case AppRoutes.register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen(),);
      case AppRoutes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen(),);
       default:
        return unDefinedRoute();
    }
  }
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}