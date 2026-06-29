import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/auth/login/presentation/views/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> getRoutes(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen(),);
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